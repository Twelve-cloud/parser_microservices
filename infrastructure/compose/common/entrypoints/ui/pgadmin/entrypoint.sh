#!/bin/sh

# Exit if any command here fails
set -e

# Running pgadmin entrypoint
echo "Running pgadmin entrypoint"

# Substitute template variables
envsubst < ${_PGADMIN_CONF_TEMPLATE_PATH} > ${_PGADMIN_CONF_PATH}
envsubst < ${_PGADMIN_SERVERS_TEMPLATE_PATH} > ${_PGADMIN_SERVERS_PATH}

# Fixup the passwd file, in case we're on OpenShift
if ! whoami > /dev/null 2>&1; then
    # Check if the current user ID is not 5050 (a common default in some environments)
    if [ "$(id -u)" -ne 5050 ]; then
        # If /etc/passwd is writable, append a new user entry for pgadminr or another specified username
        if [ -w /etc/passwd ]; then
            echo "${USER_NAME:-pgadminr}:x:$(id -u):0:${USER_NAME:-pgadminr} user:${HOME}:/sbin/nologin"                \
            >> /etc/passwd
        fi
    fi
fi


# Check if config_distro.py exists and has content. If not, create it with default settings.
if [ "$(wc -m /pgadmin4/config_distro.py | awk '{ print $1 }')" = "0" ]; then
    cat << EOF > /pgadmin4/config_distro.py
CA_FILE = '/etc/ssl/certs/ca-certificates.crt'
LOG_FILE = '/dev/null'
HELP_PATH = '../../docs'
DEFAULT_BINARY_PATHS = {
        'pg': '/usr/local/pgsql-16',
        'pg-16': '/usr/local/pgsql-16',
        'pg-15': '/usr/local/pgsql-15',
        'pg-14': '/usr/local/pgsql-14',
        'pg-13': '/usr/local/pgsql-13',
        'pg-12': '/usr/local/pgsql-12'
}
EOF

    # Iterate through all environment variables starting with "PGADMIN_CONFIG_" and append them to config_distro.py.
    for var in $(env | grep "^PGADMIN_CONFIG_" | cut -d "=" -f 1); do
        echo ${var#PGADMIN_CONFIG_} = $(eval "echo \$$var") >> /pgadmin4/config_distro.py
    done
fi

# Initialize pgadmin before starting Gunicorn
if [ ! -f /var/lib/pgadmin/pgadmin4.db ]; then
    # Check if both PGADMIN_DEFAULT_EMAIL and PGADMIN_DEFAULT_PASSWORD are set, otherwise fail
    if [ -z "${PGADMIN_DEFAULT_EMAIL}" ] || { [ -z "${PGADMIN_DEFAULT_PASSWORD}" ]; }; then
        echo 'You need to define the PGADMIN_DEFAULT_EMAIL and PGADMIN_DEFAULT_PASSWORD.'
        exit 1
    fi

    # Check if the email is valid
    if ! echo "${PGADMIN_DEFAULT_EMAIL}" | grep -E "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$" > /dev/null; then
        echo "'${PGADMIN_DEFAULT_EMAIL}' does not appear to be a valid email address. "
        exit 1
    fi

    # Read secret contents
    if [ -n "${PGADMIN_DEFAULT_PASSWORD_FILE}" ]; then
        PGADMIN_DEFAULT_PASSWORD=$(cat "${PGADMIN_DEFAULT_PASSWORD_FILE}")
        export PGADMIN_DEFAULT_PASSWORD
    fi

    # Set the default username
    export PGADMIN_SETUP_EMAIL="${PGADMIN_DEFAULT_EMAIL}"

    # Set the default password
    export PGADMIN_SETUP_PASSWORD="${PGADMIN_DEFAULT_PASSWORD}"

    # Initialize pgadmin. Importing pgadmin4 (from this script) is enough
    /venv/bin/python3 run_pgadmin.py

    # Set the server file
    export PGADMIN_SERVER_JSON_FILE="${PGADMIN_SERVER_JSON_FILE:-/pgadmin4/servers.json}"

    # Set the preferences file
    export PGADMIN_PREFERENCES_JSON_FILE="${PGADMIN_PREFERENCES_JSON_FILE:-/pgadmin4/preferences.json}"

    # Pre-load any required servers
    if [ -f "${PGADMIN_SERVER_JSON_FILE}" ]; then
        if [ "${PGADMIN_CONFIG_SERVER_MODE}" = "False" ]; then
            /venv/bin/python3 /pgadmin4/setup.py load-servers "${PGADMIN_SERVER_JSON_FILE}" --replace
        else
            /venv/bin/python3 /pgadmin4/setup.py load-servers "${PGADMIN_SERVER_JSON_FILE}"                             \
            --user "${PGADMIN_DEFAULT_EMAIL}" --replace
        fi
    fi

    # Pre-load any required preferences
    if [ -f "${PGADMIN_PREFERENCES_JSON_FILE}" ]; then
        if [ "${PGADMIN_CONFIG_SERVER_MODE}" = "False" ]; then
            DESKTOP_USER=$(cd /pgadmin4 && /venv/bin/python3 -c 'import config; print(config.DESKTOP_USER)')
            /venv/bin/python3 /pgadmin4/setup.py set-prefs "${DESKTOP_USER}"                                            \
            --input-file "${PGADMIN_PREFERENCES_JSON_FILE}"
        else
            /venv/bin/python3 /pgadmin4/setup.py set-prefs "${PGADMIN_DEFAULT_EMAIL}"                                   \
            --input-file "${PGADMIN_PREFERENCES_JSON_FILE}"
        fi
    fi

fi

# Start Postfix to handle password resets etc.
if [ -z "${PGADMIN_DISABLE_POSTFIX}" ]; then
    sudo /usr/sbin/postfix start
fi

# Get the session timeout from the pgAdmin config. We'll use this (in seconds) to define the Gunicorn worker timeout
TIMEOUT=$(cd /pgadmin4 && /venv/bin/python3 -c 'import config; print(config.SESSION_EXPIRATION_TIME * 60 * 60 * 24)')

# Set the bind address
if [ -n "${PGADMIN_ENABLE_SOCK}" ]; then
    BIND_ADDRESS="unix:/run/pgadmin/pgadmin.sock"
else
    if [ -n "${PGADMIN_ENABLE_TLS}" ]; then
        BIND_ADDRESS="${PGADMIN_LISTEN_ADDRESS:-[::]}:${PGADMIN_LISTEN_PORT:-443}"
    else
        BIND_ADDRESS="${PGADMIN_LISTEN_ADDRESS:-[::]}:${PGADMIN_LISTEN_PORT:-80}"
    fi
fi

# Run pgadmin using Gunicorn
if [ -n "${PGADMIN_ENABLE_TLS}" ]; then
    exec /venv/bin/gunicorn                                                                                             \
    --limit-request-line "${GUNICORN_LIMIT_REQUEST_LINE:-8190}"                                                         \
    --timeout "${TIMEOUT}" --bind "${BIND_ADDRESS}" -w 1                                                                \
    --threads "${GUNICORN_THREADS:-25}"                                                                                 \
    --access-logfile "${GUNICORN_ACCESS_LOGFILE:--}"                                                                    \
    --keyfile /certs/server.key --certfile /certs/server.cert                                                           \
    -c gunicorn_config.py run_pgadmin:app
else
    exec /venv/bin/gunicorn                                                                                             \
    --limit-request-line "${GUNICORN_LIMIT_REQUEST_LINE:-8190}"                                                         \
    --timeout "${TIMEOUT}" --bind "${BIND_ADDRESS}" -w 1                                                                \
    --threads "${GUNICORN_THREADS:-25}"                                                                                 \
    --access-logfile "${GUNICORN_ACCESS_LOGFILE:--}"                                                                    \
    -c gunicorn_config.py run_pgadmin:app
fi

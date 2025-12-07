#!/bin/bash


# Exit if any command here fails
set -e


log_message() {
    # Get message
    local message="$1"

    # Get timestamp
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S.%3N %Z')

    # Get PID
    local pid=$$

    # Log message
    echo "[${timestamp}] [PID ${pid}] LOG: ${message}"
}


initialize_database() {
    log_message "Initializing database (running initdb)"

    pg_ctl init                                                                                             \
        --silent                                                                                            \
        --pgdata "${_ENTRYPOINT_POSTGRES_PGDATA}"                                                           \
        -o "                                                                                                \
            --username=${_ENTRYPOINT_POSTGRES_USER}                                                         \
            --auth=reject                                                                                   \
        "

    log_message "Database has been initialized (initdb complete)"
}


start_temporary_server() {
    log_message "Starting temporary server (pg_ctl start)"

    pg_ctl start                                                                                            \
        --silent                                                                                            \
        --wait                                                                                              \
        --pgdata "${_ENTRYPOINT_POSTGRES_PGDATA}"                                                           \
        -o "                                                                                                \
            --config_file=${_ENTRYPOINT_POSTGRES_CONFIG_PATH}                                               \
        "

    log_message "Temporary server has been started (pg_ctl start)"
}


apply_init_files() {
    log_message "Applying init files"

    local init_file

    for init_file in "${@}"; do
        case "${init_file}" in
            *.sql) log_message "Running SQL file: ${init_file}"; run_sql -f "${init_file}" ;;
        esac
    done

    log_message "Init files have been applied"
}


run_sql() {
    local query_runner=(
        psql
        --variable ON_ERROR_STOP=1
        --quiet
        --no-psqlrc
        "                                                                                                   \
            host=${_ENTRYPOINT_POSTGRES_HOST}                                                               \
            port=${_ENTRYPOINT_POSTGRES_PORT}                                                               \
            user=${_ENTRYPOINT_POSTGRES_USER}                                                               \
            dbname=${_ENTRYPOINT_POSTGRES_DB}                                                               \
            sslmode=verify-full                                                                             \
            sslkey=${_ENTRYPOINT_POSTGRES_SSL_KEY_PATH}                                                     \
            sslcert=${_ENTRYPOINT_POSTGRES_SSL_CRT_PATH}                                                    \
            sslrootcert=${_ENTRYPOINT_POSTGRES_SSL_CA_CRT_PATH}                                             \
        "
    )

    "${query_runner[@]}" "$@"
}


stop_temporary_server() {
    log_message "Stopping temporary server (pg_ctl stop)"

    pg_ctl stop                                                                                             \
        --silent                                                                                            \
        --wait                                                                                              \
        --pgdata "${_ENTRYPOINT_POSTGRES_PGDATA}"                                                           \
        --mode smart

    log_message "Temporary server has been stopped (pg_ctl stop)"
}


main() {
    log_message "Running postgres entrypoint"

    log_message "Substituting template variables"

    envsubst < "${_ENTRYPOINT_POSTGRES_CONFIG_TEMPLATE_PATH}" > "${_ENTRYPOINT_POSTGRES_CONFIG_PATH}"
    envsubst < "${_ENTRYPOINT_POSTGRES_HBA_TEMPLATE_PATH}" > "${_ENTRYPOINT_POSTGRES_HBA_PATH}"
    envsubst < "${_ENTRYPOINT_POSTGRES_IDENT_TEMPLATE_PATH}" > "${_ENTRYPOINT_POSTGRES_IDENT_PATH}"
    envsubst < "${_ENTRYPOINT_POSTGRES_INIT_SQL_TEMPLATE_PATH}" > "${_ENTRYPOINT_POSTGRES_INIT_SQL_PATH}"

    log_message "Template variables have been substituted"

    log_message "Unsetting PGDATA environment variable"

    unset PGDATA

    log_message "PGDATA environment variable has been unset"

    # If database is not initialized (file PG_VERSION does not exist or empty)
    if [[ ! -s "${_ENTRYPOINT_POSTGRES_PGDATA}/PG_VERSION" ]]; then
        initialize_database

        start_temporary_server

        apply_init_files "${_ENTRYPOINT_POSTGRES_INIT_SQL_PATH}"

        stop_temporary_server

        log_message "PostgreSQL has been initialized; Ready for start up"
    else
        log_message "PostgreSQL is initialized; Skipping initialization"
    fi

    exec "${@}"
}


main "${@}"

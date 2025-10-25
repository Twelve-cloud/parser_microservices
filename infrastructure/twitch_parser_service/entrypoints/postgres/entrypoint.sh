#!/bin/bash

# Exit if any command here fails
set -e

# Function to initialize database
initialize_database() {
    echo "Initializing database (running initdb)"

    # Initialize database (create system databases, etc...)
    pg_ctl init                                                                                             \
        --pgdata "${_ENTRYPOINT_POSTGRES_PGDATA}"                                                           \
        -o "                                                                                                \
            --username=${_ENTRYPOINT_POSTGRES_USER}                                                         \
            --auth=reject                                                                                   \
        "

    echo "Database has been initialized (initdb complete)"
}

# Function to start temporary server
start_temporary_server() {
    echo "Starting temporary server (pg_ctl start)"

    # Start temporary server
    pg_ctl start                                                                                            \
        --wait                                                                                              \
        --pgdata "${_ENTRYPOINT_POSTGRES_PGDATA}"                                                           \
        -o "                                                                                                \
            -p ${_CONFIG_POSTGRES_PORT}                                                                     \
            -c listen_addresses=${_ENTRYPOINT_POSTGRES_HOST}                                                \
            -c unix_socket_directories=''                                                                   \
            -c ssl=on                                                                                       \
            -c ssl_min_protocol_version=TLSv1.3                                                             \
            -c ssl_key_file=${_ENTRYPOINT_POSTGRES_SSL_KEY_PATH}                                            \
            -c ssl_cert_file=${_ENTRYPOINT_POSTGRES_SSL_CRT_PATH}                                           \
            -c ssl_ca_file=${_ENTRYPOINT_POSTGRES_SSL_CA_CRT_PATH}                                          \
            -c hba_file=${_ENTRYPOINT_POSTGRES_HBA_PATH}                                                    \
            -c ident_file=${_ENTRYPOINT_POSTGRES_IDENT_PATH}                                                \
        "

    echo "Temporary server has been started (pg_ctl start)"
}

# Function to apply init files
apply_init_files() {
        echo "Applying init files"

        # Create variable to store path to init files
        local init_file

        # Loop through init files
        for init_file in "${@}"; do
            # Check if init file is SQL
            case "${init_file}" in
                # If init file is SQL run it
                *.sql) echo "Running SQL file: ${init_file}"; run_sql -f "${init_file}" ;;
            esac
        done

        echo "Init files have been applied"
}

# Function to run SQL
run_sql() {
    # Create variable to store psql connection parameters
    local query_runner=(
        psql
        --variable ON_ERROR_STOP=1
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

    # Run SQL
    "${query_runner[@]}" "$@"
}

# Function to stop temporary server
stop_temporary_server() {
    echo "Stopping temporary server (pg_ctl stop)"

    # Stop temporary server
    pg_ctl stop                                                                                             \
        --wait                                                                                              \
        --pgdata "${_ENTRYPOINT_POSTGRES_PGDATA}"                                                           \
        --mode smart

    echo "Temporary server has been stopped (pg_ctl stop)"
}

main() {
    echo "Running postgres entrypoint"

    echo "Substituting template variables"

    # Substitute template variables
    envsubst < "${_ENTRYPOINT_POSTGRES_CONFIG_TEMPLATE_PATH}" > "${_ENTRYPOINT_POSTGRES_CONFIG_PATH}"
    envsubst < "${_ENTRYPOINT_POSTGRES_HBA_TEMPLATE_PATH}" > "${_ENTRYPOINT_POSTGRES_HBA_PATH}"
    envsubst < "${_ENTRYPOINT_POSTGRES_IDENT_TEMPLATE_PATH}" > "${_ENTRYPOINT_POSTGRES_IDENT_PATH}"
    envsubst < "${_ENTRYPOINT_POSTGRES_INIT_SQL_TEMPLATE_PATH}" > "${_ENTRYPOINT_POSTGRES_INIT_SQL_PATH}"

    echo "Template variables have been substituted"

    # If database is not initialized (file PG_VERSION does not exist or empty)
    if [[ ! -s "${_ENTRYPOINT_POSTGRES_PGDATA}/PG_VERSION" ]]; then

        # Initialize database
        initialize_database

        # Start temporary server
        start_temporary_server

        # Apply init files
        apply_init_files "${_ENTRYPOINT_POSTGRES_INIT_SQL_PATH}"

        # Stop temporary server
        stop_temporary_server

        echo "PostgreSQL init process complete; Ready for start up"
    else
        echo "PostgreSQL Database directory contain a database; Skipping initialization"
    fi

    # Run postgres
    exec "${@}" -D "${_ENTRYPOINT_POSTGRES_PGDATA}" # Bug: without -D does not work, but should
}

# Run main
main "${@}"

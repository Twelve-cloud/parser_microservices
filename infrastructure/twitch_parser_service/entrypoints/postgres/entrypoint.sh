#!/bin/sh

# Exit if any command here fails
set -e

# Running postgres entrypoint
echo "Running postgres entrypoint"

# Substitute template variables
envsubst < ${_ENTRYPOINT_POSTGRES_CONFIG_TEMPLATE_PATH} > ${_ENTRYPOINT_POSTGRES_CONFIG_PATH}
envsubst < ${_ENTRYPOINT_POSTGRES_HBA_TEMPLATE_PATH} > ${_ENTRYPOINT_POSTGRES_HBA_PATH}
envsubst < ${_ENTRYPOINT_POSTGRES_IDENT_TEMPLATE_PATH} > ${_ENTRYPOINT_POSTGRES_IDENT_PATH}
envsubst < ${_ENTRYPOINT_POSTGRES_INIT_SQL_TEMPLATE_PATH} > ${_ENTRYPOINT_POSTGRES_INIT_SQL_PATH}

# Run original entrypoint
exec ${_ENTRYPOINT_POSTGRES_ORIGINAL_ENTRYPOINT_PATH} "$@"

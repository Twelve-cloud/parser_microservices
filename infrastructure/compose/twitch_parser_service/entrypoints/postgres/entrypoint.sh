#!/bin/sh

# Exit if any command here fails
set -e

# Running postgres entrypoint
echo "Running postgres entrypoint"

# Giving permission for postgres data folder
chmod -R 0700 ${PGDATA}

# Substitute template variables
envsubst < ${_POSTGRES_CONFIG_TEMPLATE_PATH} > ${_POSTGRES_CONFIG_PATH}
envsubst < ${_POSTGRES_HBA_TEMPLATE_PATH} > ${_POSTGRES_HBA_PATH}

# Run original entrypoint
exec ${_POSTGRES_ORIGINAL_ENTRYPOINT_PATH} "$@"

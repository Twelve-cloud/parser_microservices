#!/bin/sh

# Exit if any command here fails
set -e

# Running postgres entrypoint
echo "Running postgres entrypoint"

# Giving permission for postgres data folder
chmod -R 0700 ${PGDATA}

# Substitute template variables
envsubst < ${POSTGRES_CONFIG_TEMPLATE_PATH} > ${POSTGRES_CONFIG_PATH}

# Run original entrypoint
exec ${POSTGRES_ORIGINAL_ENTRYPOINT_PATH} "$@"

#!/bin/sh

# Exit if any command here fails
set -e

# Running redis entrypoint
echo "Running redis entrypoint"

# Substitute template variables
envsubst < ${REDIS_CONFIG_TEMPLATE_PATH} > ${REDIS_CONFIG_PATH}

# Run original entrypoint
exec ${REDIS_ORIGINAL_ENTRYPOINT_PATH} "$@"

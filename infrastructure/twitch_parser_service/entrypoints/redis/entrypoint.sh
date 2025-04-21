#!/bin/sh

# Exit if any command here fails
set -e

# Running redis entrypoint
echo "Running redis entrypoint"

# Substitute template variables
envsubst < ${_REDIS_CONFIG_TEMPLATE_PATH} > ${_REDIS_CONFIG_PATH}

# Run original entrypoint
exec ${_REDIS_ORIGINAL_ENTRYPOINT_PATH} "$@"

#!/bin/sh

# Exit if any command here fails
set -e

# Running mongo entrypoint
echo "Running mongo entrypoint"

# Substitute template variables
envsubst < ${_MONGO_CONFIG_TEMPLATE_PATH} > ${_MONGO_CONFIG_PATH}

# Run original entrypoint
exec ${_MONGO_ORIGINAL_ENTRYPOINT_PATH} "$@"

#!/bin/sh

# Exit if any command here fails
set -e

# Running mongo entrypoint
echo "Running mongo entrypoint"

# Substitute template variables
envsubst < ${MONGO_CONFIG_TEMPLATE_PATH} > ${MONGO_CONFIG_PATH}

# Run original entrypoint
exec ${MONGO_ORIGINAL_ENTRYPOINT_PATH} "$@"

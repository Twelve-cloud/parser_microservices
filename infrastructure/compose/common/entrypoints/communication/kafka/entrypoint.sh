#!/bin/sh

# Exit if any command here fails
set -e

# Running kafka entrypoint
echo "Running kafka entrypoint"

# Substitute template variables
envsubst < ${_KAFKA_CONFIG_TEMPLATE_PATH} > ${_KAFKA_CONFIG_PATH}

# Run original entrypoint
exec ${_KAFKA_ORIGINAL_ENTRYPOINT_PATH} "$@"

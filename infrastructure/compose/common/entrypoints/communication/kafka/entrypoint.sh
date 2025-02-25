#!/bin/sh

# Exit if any command here fails
set -e

# Running kafka entrypoint
echo "Running kafka entrypoint"

# Substitute template variables
envsubst < ${KAFKA_CONFIG_TEMPLATE_PATH} > ${KAFKA_CONFIG_PATH}

# Run original entrypoint
exec ${KAFKA_ORIGINAL_ENTRYPOINT_PATH} "$@"

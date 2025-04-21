#!/bin/sh

# Exit if any command here fails
set -e

# Running redpanda entrypoint
echo "Running redpanda entrypoint"

# Substitute template variables
envsubst < ${_REDPANDA_CONFIG_TEMPLATE_PATH} > ${_REDPANDA_CONFIG_PATH}

# Execute any input parameters
exec "$@"

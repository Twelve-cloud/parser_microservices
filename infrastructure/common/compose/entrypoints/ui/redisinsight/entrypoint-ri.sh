#!/bin/sh

# Exit if any command here fails
set -e

# Running redis insight entrypoint
echo "Running redis insight entrypoint"

# Substitute template variables
envsubst < ${REDIS_INSIGHT_CONFIG_TEMPLATE_PATH} > ${REDIS_INSIGHT_CONFIG_PATH}

# Run original entrypoint
echo "Exporting environment variables"

# Load redis-insight configuration
set -o allexport
source ${REDIS_INSIGHT_CONFIG_PATH}
set +o allexport

# Environment variables has been exported
echo "Environment variables has been exported"

# Execute any input parameters
exec "$@"

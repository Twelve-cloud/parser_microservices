#!/bin/sh

# Exit if any command here fails
set -e

# Running redis insight entrypoint
echo "Running redis insight entrypoint"

# Substitute template variables
envsubst < ${RI_CONFIG_TEMPLATE_PATH} > ${RI_CONFIG_PATH}

# Run original entrypoint
echo "Exporting environment variables"

# Load redis-insight configuration
set -o allexport
source ${RI_CONFIG_PATH}
set +o allexport

# Environment variables has been exported
echo "Environment variables has been exported"

# Execute any input parameters
exec "$@"

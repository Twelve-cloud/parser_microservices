#!/bin/sh

# Exit if any command here fails
set -e

# Running redis insight entrypoint
echo "Running redis insight entrypoint"

# Run original entrypoint
echo "Exporting environment variables"

# Load redis-insight configuration
set -o allexport
source ./config/default.conf
set +o allexport

# Environment variables has been exported
echo "Environment variables has been exported"

# Execute any input parameters
exec "$@"

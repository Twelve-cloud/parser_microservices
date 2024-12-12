#!/bin/sh

set -e

echo "Running redis insight entrypoint"

echo "Exporting environment variables"

# Load redis-insight configuration
set -o allexport
source ./config/default.conf
set +o allexport

echo "Environment variables has been exported"

exec "$@"

#!/bin/sh

set -e

echo "Running redis insight docker-entry.sh"

echo "Exporting environment variables"

set -o allexport
source ./config/default.conf
set +o allexport

echo "Environment variables has been exported"

exec "$@"

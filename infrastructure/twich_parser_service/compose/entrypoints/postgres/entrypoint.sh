#!/bin/sh

# Exit if any command here fails
set -e

# Running postgres entrypoint
echo "Running postgres entrypoint"

# Run original entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"

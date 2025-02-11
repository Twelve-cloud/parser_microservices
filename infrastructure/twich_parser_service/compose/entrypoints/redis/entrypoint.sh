#!/bin/sh

# Exit if any command here fails
set -e

# Running redis entrypoint
echo "Running redis entrypoint"

# Run original entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"

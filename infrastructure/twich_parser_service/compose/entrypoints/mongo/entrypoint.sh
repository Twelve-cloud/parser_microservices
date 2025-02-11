#!/bin/sh

# Exit if any command here fails
set -e

# Running mongo entrypoint
echo "Running mongo entrypoint"

# Run original entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"

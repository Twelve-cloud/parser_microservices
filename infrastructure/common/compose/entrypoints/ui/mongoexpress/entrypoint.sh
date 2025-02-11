#!/bin/sh

# Exit if any command here fails
set -e

# Running mongo-express entrypoint
echo "Running mongo-express entrypoint"

# Run original entrypoint
exec /docker-entrypoint.sh "$@"

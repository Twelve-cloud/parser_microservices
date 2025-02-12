#!/bin/sh

# Exit if any command here fails
set -e

# Running postgres entrypoint
echo "Running postgres entrypoint"

# Giving permission for postgres data folder
chmod -R 0700 ${PGDATA}

# Run original entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"

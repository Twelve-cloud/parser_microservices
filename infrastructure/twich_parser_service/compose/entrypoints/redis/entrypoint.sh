#!/bin/sh

# Exit if any command here fails
set -e

# Running redis entrypoint
echo "Running redis entrypoint"

# Substitute template variables
envsubst < /etc/templates/redis/redis.conf.template > /etc/redis/redis.conf

# Run original entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"

#!/bin/sh

# Exit if any command here fails
set -e

# Running redis entrypoint
echo "Running redis entrypoint"

# Copy redis config file from template
cp /etc/templates/redis/redis.conf.template /etc/redis/redis.conf

# Substitute template variables
sed -i                                                                         \
    -e "s|\${REDIS_HOST}|${REDIS_HOST}|g"                                      \
    -e "s|\${REDIS_PORT}|${REDIS_PORT}|g"                                      \
    -e "s|\${REDIS_TLS_PORT}|${REDIS_TLS_PORT}|g"                              \
    /etc/redis/redis.conf

# Run original entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"

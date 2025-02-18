#!/bin/sh

# Exit if any command here fails
set -e

# Running mongo entrypoint
echo "Running mongo entrypoint"

# Substitute template variables
envsubst < /etc/templates/mongo/mongo.conf.template > /etc/mongo/mongo.conf

# Run original entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"

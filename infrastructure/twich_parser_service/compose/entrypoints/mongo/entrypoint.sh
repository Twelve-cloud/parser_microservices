#!/bin/sh

# Exit if any command here fails
set -e

# Running mongo entrypoint
echo "Running mongo entrypoint"

# Copy mongo config file from template
cp /etc/templates/mongo/mongo.conf.template /etc/mongo/mongo.conf

# Substitute template variables
sed -i                                                                         \
    -e "s|\${MONGO_HOST}|${MONGO_HOST}|g"                                      \
    -e "s|\${MONGO_PORT}|${MONGO_PORT}|g"                                      \
    /etc/mongo/mongo.conf

# Run original entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"

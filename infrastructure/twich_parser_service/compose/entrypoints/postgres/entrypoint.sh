#!/bin/sh

# Exit if any command here fails
set -e

# Running postgres entrypoint
echo "Running postgres entrypoint"

# Giving permission for postgres data folder
chmod -R 0700 ${PGDATA}

# Copy postgres config file from template
cp /etc/templates/postgres/postgres.conf.template /etc/postgres/postgres.conf

# Substitute template variables
sed -i                                                                         \
    -e "s|\${POSTGRES_HOST}|${POSTGRES_HOST}|g"                                \
    -e "s|\${POSTGRES_PORT}|${POSTGRES_PORT}|g"                                \
    /etc/postgres/postgres.conf

# Run original entrypoint
exec /usr/local/bin/docker-entrypoint.sh "$@"

#!/bin/sh

# Exit if any command here fails
set -e

# Running mongo-express entrypoint
echo "Running mongo-express entrypoint"

# Substitute template variables
envsubst < /etc/templates/mongoexpress/connect.js.template > /app/lib/db.js
envsubst < /etc/templates/mongoexpress/mongoexpress.js.template > /app/config.default.js

# Run original entrypoint
exec /docker-entrypoint.sh "$@"

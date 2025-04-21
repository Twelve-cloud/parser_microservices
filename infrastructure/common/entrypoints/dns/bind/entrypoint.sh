#!/bin/sh

# Exit if any command here fails
set -e

# Running bind entrypoint
echo "Running bind entrypoint"

# Substitute template variables
envsubst < ${_BIND_CONFIG_TEMPLATE_PATH} > ${_BIND_CONFIG_PATH}

# Change all
cp /etc/templates/bind/zones/db.par     /var/lib/bind/db.par
cp /etc/templates/bind/zones/db.ui.par  /var/lib/bind/db.ui.par

# Run original entrypoint
exec ${_BIND_ORIGINAL_ENTRYPOINT_PATH} "$@"

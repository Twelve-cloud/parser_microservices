#!/bin/sh

# Exit if any command here fails
set -e

# Running redis insight nginx entrypoint
echo "Running redis insight nginx entrypoint to setup basic auth"

# Substitute template variables
envsubst < /etc/templates/nginx/nginx.conf.template | sed -e 's/§/$/g' > /etc/nginx/nginx.conf

# Create htpasswd file
echo "Creating htpasswd file"

# Create htpasswd file
echo "${RI_DEFAULT_EMAIL}:{PLAIN}${RI_DEFAULT_PASSWORD}" > /tmp/.htpasswd

# Execute any input parameters
exec "$@"

#!/bin/sh

# Exit if any command here fails
set -e

# Running redis insight nginx entrypoint
echo "Running redis insight nginx entrypoint to setup basic auth"

# Substitute template variables
envsubst < ${RI_PROXY_CONFIG_TEMPLATE_PATH} | sed -e 's/§/$/g' > ${RI_PROXY_CONFIG_PATH}

# Create htpasswd file
echo "Creating htpasswd file"

# Create htpasswd file
echo "${RI_DEFAULT_EMAIL}:{PLAIN}${RI_DEFAULT_PASSWORD}" > ${RI_PROXY_BASIC_AUTH_FILE_PASS}

# Execute any input parameters
exec "$@"

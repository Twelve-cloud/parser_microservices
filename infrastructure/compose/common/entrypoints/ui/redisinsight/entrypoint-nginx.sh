#!/bin/sh

# Exit if any command here fails
set -e

# Running redis insight nginx entrypoint
echo "Running redis insight nginx entrypoint to setup basic auth"

# Substitute template variables
envsubst < ${REDIS_INSIGHT_PROXY_CONFIG_TEMPLATE_PATH} | sed -e 's/§/$/g' > ${REDIS_INSIGHT_PROXY_CONFIG_PATH}

# Create htpasswd file
echo "Creating htpasswd file"

# Create htpasswd file
echo "${REDIS_INSIGHT_DEFAULT_EMAIL}:{PLAIN}${REDIS_INSIGHT_DEFAULT_PASSWORD}" > ${REDIS_INSIGHT_PROXY_BASIC_AUTH_FILE_PASS}

# Execute any input parameters
exec "$@"

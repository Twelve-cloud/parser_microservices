#! /bin/sh

set -e

echo "Running redis insight nginx entrypoint to setup basic auth"

echo "Creating htpasswd file"

# Create htpasswd file
echo "${RI_DEFAULT_EMAIL}:{PLAIN}${RI_DEFAULT_PASSWORD}" > /tmp/.htpasswd

# Execute any input parameters
exec "$@"

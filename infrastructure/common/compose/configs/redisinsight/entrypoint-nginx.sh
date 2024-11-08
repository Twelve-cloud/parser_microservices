#! /bin/sh

set -e

echo "Running redis insight nginx entrypoint to setup basic auth"

echo "Creating htpasswd file"

echo "${RI_DEFAULT_EMAIL}:{PLAIN}${RI_DEFAULT_PASSWORD}" > /tmp/.htpasswd

exec "$@"

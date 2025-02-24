#!/bin/sh

# Exit if any command here fails
set -e

# Running mongo-express entrypoint
echo "Running mongo-express entrypoint"

# Substitute template variables
envsubst < ${MONGO_EXPRESS_CONNECT_TEMPLATE_PATH} > ${MONGO_EXPRESS_CONNECT_PATH}
envsubst < ${MONGO_EXPRESS_CONFIG_TEMPLATE_PATH} > ${MONGO_EXPRESS_CONFIG_PATH}

# Run original entrypoint
exec ${MONGO_EXPRESS_ORIGINAL_ENTRYPOINT_PATH} "$@"

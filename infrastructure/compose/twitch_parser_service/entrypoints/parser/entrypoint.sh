#!/bin/sh

# Exit if any command here fails
set -e

# Running twitch parser entrypoint
echo "Running twitch parser entrypoint"

# Substitute template variables
envsubst < ${_PARSER_CONFIG_TEMPLATE_PATH} > ${_PARSER_CONFIG_PATH}

# Change directory to src
cd src

# Every command that passed to this entrypoint will be executed
exec "$@"

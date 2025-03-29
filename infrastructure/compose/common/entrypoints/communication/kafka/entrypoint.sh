#!/bin/sh

# Exit if any command here fails
set -e

# Running kafka entrypoint
echo "Running kafka entrypoint"

# Substitute template variables
envsubst < ${_KAFKA_CONFIG_TEMPLATE_PATH} > ${_KAFKA_CONFIG_PATH}
envsubst < ${_KAFKA_SERVER_JAAS_TEMPLATE_PATH} > ${_KAFKA_SERVER_JAAS_PATH}

# Check if metadata file exists
if [ -f "${_KAFKA_LOG_DATA_PATH}/meta.properties" ]; then
    # If metadata file exists getting cluster ID from it
    export CLUSTER_ID=$(grep 'cluster.id' ${_KAFKA_LOG_DATA_PATH}/meta.properties | cut -d'=' -f2 | tr -d '[:space:]')
else
    # If metadata file doesn't exist generating new cluster ID
    export CLUSTER_ID="$(/opt/kafka/bin/kafka-storage.sh random-uuid)"

    # Generate storage with new cluster ID and user credentials
    /opt/kafka/bin/kafka-storage.sh format                                                                          \
    --cluster-id ${CLUSTER_ID}                                                                                      \
    --config ${_KAFKA_CONFIG_PATH}                                                                                  \
    --ignore-formatted                                                                                              \
    --add-scram "SCRAM-SHA-256=[name=${_KAFKA_BROKER_USER},password=${_KAFKA_BROKER_PASSWORD}]"                     \
    --add-scram "SCRAM-SHA-256=[name=${_KAFKA_CONTROLLER_USER},password=${_KAFKA_CONTROLLER_PASSWORD}]"             \
    --add-scram "SCRAM-SHA-256=[name=${_KAFKA_CLIENT_USER},password=${_KAFKA_CLIENT_PASSWORD}]"
fi

# Export cluster ID
export KAFKA_CLUSTER_ID="${CLUSTER_ID}"

# Export JAAS configuration
export KAFKA_OPTS="-Djava.security.auth.login.config=${_KAFKA_SERVER_JAAS_PATH}"

# Run original entrypoint
exec ${_KAFKA_ORIGINAL_ENTRYPOINT_PATH} "$@"

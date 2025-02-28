#!/bin/sh

# Exit if any command here fails
set -e

# Running redis insight entrypoint
echo "Running redis insight entrypoint"

# Substitute template variables
envsubst < ${_REDIS_INSIGHT_CONFIG_TEMPLATE_PATH} > ${_REDIS_INSIGHT_CONFIG_PATH}

# Exporting environment variables
echo "Exporting environment variables"

# Load redis-insight configuration
set -o allexport && source ${_REDIS_INSIGHT_CONFIG_PATH} && set +o allexport

# Environment variables has been exported
echo "Environment variables has been exported"

# Execute any input parameters in background
"$@" &

# Capture the PID of the background process
REDIS_INSIGHT_PID=$!

# Waiting for Redis Insight to become available
echo "Waiting for Redis Insight to become available"

# Do curl until its become healthy
while ! curl                                                                      \
  --silent --insecure --output /dev/null --fail                                   \
  ${_REDIS_INSIGHT_ADDRESS}/api/health;                                           \
do
  sleep 1
done

# Redis Insight is ready
echo "Redis Insight is ready"

# Get certificates and key filenames
tls_key=$(sed ':a;N;$!ba;s/\n/\\n/g' ${_REDIS_INSIGHT_SSL_KEY_PATH})
tls_crt=$(sed ':a;N;$!ba;s/\n/\\n/g' ${_REDIS_INSIGHT_SSL_CERT_PATH})
tls_ca_crt=$(sed ':a;N;$!ba;s/\n/\\n/g' ${_REDIS_INSIGHT_SSL_CA_PATH})

# Change encryption agreement
echo "Changing encryption agreement"

# Create post body for changing encryption agreement
change_encryption_agreement_json=$(cat << EOF
{
  "agreements": {
    "eula": true,
    "analytics": true,
    "notifications": true,
    "encryption": false
  }
}
EOF
)

# Change encryption agreement
response=$(curl --silent --insecure                                               \
  -X "PATCH" ${_REDIS_INSIGHT_ADDRESS}/api/settings                               \
  -H "Content-Type: application/json; charset=utf-8"                              \
  -d "${change_encryption_agreement_json}"                                        \
)

# Response from redis insight for changing encryption agreement
echo "Changing agreement response: ${response}"

# Create predefined servers
echo "Creating parser redis predefined servers"

# Create post body for creating predefined servers
parser_redis_connection_options_json=$(cat << EOF
{
  "name": "${_PARSER_REDIS_CONNECTION_NAME}",
  "host": "${_PARSER_REDIS_HOST}",
  "port": ${_PARSER_REDIS_PORT},
  "username": "${_PARSER_REDIS_USER}",
  "password": "${_PARSER_REDIS_PASS}",
  "tls": true,
  "caCert": {
    "certificate": "${tls_ca_crt}",
    "name": "parser_redis_ca_cert"
  },
  "clientCert": {
    "certificate": "${tls_crt}",
    "key": "${tls_key}",
    "name": "redis_insight_cert"
  },
  "verifyServerCert": true,
  "ssh": false
}
EOF
)

# Create predefined servers
response=$(curl --silent --insecure                                               \
 -X "POST" ${_REDIS_INSIGHT_ADDRESS}/api/databases                                \
 -H "Content-Type: application/json; charset=utf-8"                               \
 -d "${parser_redis_connection_options_json}"                                     \
)

# Response from redis insight for creating predefined servers
echo "Creating parser redis predefined servers response: ${response}"

# Trap to kill the background process on SIGINT/SIGTERM and exit
trap "kill -s SIGTERM $REDIS_INSIGHT_PID; wait $REDIS_INSIGHT_PID; exit $?" INT TERM

# Wait for Redis Insight server to stop
wait $REDIS_INSIGHT_PID

# Exit from shell with the exit code of $REDIS_INSIGHT_PID process
exit $?

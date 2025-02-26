#!/bin/sh

# Exit if any command here fails
set -e

# Running redis insight curl entrypoint
echo "Running redis insight curl entrypoint to setup predefined servers"

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
response=$(curl --silent --insecure                                          \
  -X "PATCH" ${_REDIS_INSIGHT_PROXY_PASS}/api/settings                       \
  -H "Content-Type: application/json; charset=utf-8"                         \
  -d "${change_encryption_agreement_json}"                                   \
)

# Response from redis insight for changing encryption agreement
echo "Response: ${response}"

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
response=$(curl --silent --insecure                                          \
 -X "POST" ${_REDIS_INSIGHT_PROXY_PASS}/api/databases                        \
 -H "Content-Type: application/json; charset=utf-8"                          \
 -d "${parser_redis_connection_options_json}"                                \
)

# Response from redis insight for creating predefined servers
echo "Response: ${response}"

# Execute any input parameters
exec "$@"

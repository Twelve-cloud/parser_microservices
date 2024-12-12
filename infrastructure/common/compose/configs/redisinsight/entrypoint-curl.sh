#! /bin/sh

set -e

echo "Running redis insight curl entrypoint to setup predefined servers"

# Get certificates and key filenames
tls_key=$(sed ':a;N;$!ba;s/\n/\\n/g' /etc/ssl/redisinsight/server.key)
tls_crt=$(sed ':a;N;$!ba;s/\n/\\n/g' /etc/ssl/redisinsight/server.crt)
tls_ca_crt=$(sed ':a;N;$!ba;s/\n/\\n/g' /etc/ssl/ca/server-ca.crt)

echo "Changing encryption agreement"

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
  -X "PATCH" https://redis-insight:5540/api/settings                         \
  -H "Content-Type: application/json; charset=utf-8"                         \
  -d "${change_encryption_agreement_json}"                                   \
)

echo "Response: ${response}"

echo "Creating parser redis predefined servers"

parser_redis_connection_options_json=$(cat << EOF
{
  "name": "TwitchParser #1",
  "host": "parser-redis",
  "port": 7379,
  "username": "Twelve",
  "password": "${PARSER_REDIS_PASSWORD}",
  "tls": true,
  "caCert": {
    "certificate": "${tls_ca_crt}",
    "name": "parser_redis_server_ca_cert"
  },
  "clientCert": {
    "certificate": "${tls_crt}",
    "key": "${tls_key}",
    "name": "parser_redis_client_cert"
  },
  "verifyServerCert": true,
  "ssh": false
}
EOF
)

# Create predefined servers
response=$(curl --silent --insecure                                          \
 -X "POST" https://redis-insight:5540/api/databases                          \
 -H "Content-Type: application/json; charset=utf-8"                          \
 -d "${parser_redis_connection_options_json}"                                \
)

echo "Response: ${response}"

exec "$@"

#! /bin/bash

# Exit if any command here fails
set -e

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            LEAF_KEY_PATH=*)            LEAF_KEY_PATH=${argument#*=} ;;
            LEAF_CRT_PATH=*)            LEAF_CRT_PATH=${argument#*=} ;;
            LEAF_P12_PATH=*)            LEAF_P12_PATH=${argument#*=} ;;
            CHAIN_CA_PATH=*)            CHAIN_CA_PATH=${argument#*=} ;;
            KEYSTORE_PATH=*)            KEYSTORE_PATH=${argument#*=} ;;
            TRUSTSTORE_PATH=*)          TRUSTSTORE_PATH=${argument#*=} ;;
            P12_PASSWORD=*)             P12_PASSWORD=${argument#*=} ;;
            KEYSTORE_PASSWORD=*)        KEYSTORE_PASSWORD=${argument#*=} ;;
            TRUSTSTORE_PASSWORD=*)      TRUSTSTORE_PASSWORD=${argument#*=} ;;
            *)                          echo "Unknown parameter: ${argument}"; return 1 ;;
        esac

    done

    return 0
}

# Parse named parameters
parse_named_parameters "$@"

# Check if the parsing was successful
if [[ $? -ne 0 ]]; then
    echo "Usage: generate_ca_certificate.sh param=value, param=value, ..."
    exit 1
fi

# Generate PKCS#12 file with server certificate and private key
source scripts/common/execute_command.sh openssl pkcs12 -export -in ${LEAF_CRT_PATH} -inkey ${LEAF_KEY_PATH} -out ${LEAF_P12_PATH} -passout pass:${P12_PASSWORD} -name server

# Import PKCS#12 file into keystore
source scripts/common/execute_command.sh keytool -importkeystore -srckeystore ${LEAF_P12_PATH} -srcstoretype PKCS12 -srcstorepass ${P12_PASSWORD} -destkeystore ${KEYSTORE_PATH} -deststoretype JKS -deststorepass ${KEYSTORE_PASSWORD}

# Import intermediate ca certificate into truststore
source scripts/common/execute_command.sh keytool -import -trustcacerts -file ${CHAIN_CA_PATH} -keystore ${TRUSTSTORE_PATH} -storepass ${TRUSTSTORE_PASSWORD} -alias ca -noprompt

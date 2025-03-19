#! /bin/bash

# Exit if any command here fails
set -e

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            SERVER_KEY_PATH=*)          SERVER_KEY_PATH=${argument#*=} ;;
            SERVER_CRT_PATH=*)          SERVER_CRT_PATH=${argument#*=} ;;
            SERVER_P12_PATH=*)          SERVER_P12_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_CRT_PATH=*) INTERMEDIATE_CA_CRT_PATH=${argument#*=} ;;
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
    echo "Usage: generate_certificate.sh CN=value CSR_PATH=value KEY_PATH=value CRT_PATH=value PEM_PATH=value CA_CRT_PATH=value CA_KEY_PATH=value"
    exit 1
fi

# Generate PKCS#12 file with server certificate and private key
source scripts/common/execute_command.sh openssl pkcs12 -export -in ${SERVER_CRT_PATH} -inkey ${SERVER_KEY_PATH} -out ${SERVER_P12_PATH} -passout pass:${P12_PASSWORD} -name server

# Import PKCS#12 file into keystore
source scripts/common/execute_command.sh keytool -importkeystore -srckeystore ${SERVER_P12_PATH} -srcstoretype PKCS12 -srcstorepass ${P12_PASSWORD} -destkeystore ${KEYSTORE_PATH} -deststoretype JKS -deststorepass ${KEYSTORE_PASSWORD}

# Import intermediate ca certificate into truststore
source scripts/common/execute_command.sh keytool -import -trustcacerts -file ${INTERMEDIATE_CA_CRT_PATH} -keystore ${TRUSTSTORE_PATH} -storepass ${TRUSTSTORE_PASSWORD} -alias ca -noprompt

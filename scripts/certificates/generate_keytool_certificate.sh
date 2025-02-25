#! /bin/bash

# Exit if any command here fails
set -e

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            CN=*)              CN=${argument#*=} ;;
            KEYSTORE_PATH=*)   KEYSTORE_PATH=${argument#*=} ;;
            KEYSTORE_PASSWORD=*) KEYSTORE_PASSWORD=${argument#*=} ;;
            TRUSTSTORE_PATH=*) TRUSTSTORE_PATH=${argument#*=} ;;
            TRUSTSTORE_PASSWORD=*) TRUSTSTORE_PASSWORD=${argument#*=} ;;
            CSR_PATH=*)        CSR_PATH=${argument#*=} ;;
            PEM_PATH=*)        PEM_PATH=${argument#*=} ;;
            KEY_PASSWORD=*)    KEY_PASSWORD=${argument#*=} ;;
            CA_PEM_PATH=*)     CA_PEM_PATH=${argument#*=} ;;
            CA_KEY_PATH=*)     CA_KEY_PATH=${argument#*=} ;;
            *)                 echo "Unknown parameter: ${argument}"; return 1 ;;
        esac

    done

    return 0
}

# Parse named parameters
parse_named_parameters "$@"

# Check if the parsing was successful
if [[ $? -ne 0 ]]; then
    echo "Usage: generate_certificate.sh CN=value KEYSTORE_PATH=value TRUSTSTORE_PATH=value CSR_PATH=value PEM_PATH=value CA_CRT_PATH=value CA_KEY_PATH=value"
    exit 1
fi

# Generate key and certificate
source scripts/common/execute_command.sh keytool -genkey -keystore ${KEYSTORE_PATH} -alias ${CN} -keyalg RSA -keysize 2048 -validity 3650 -storetype pkcs12 -storepass ${KEYSTORE_PASSWORD} -keypass ${KEY_PASSWORD} -dname "CN=${CN}"

# Generate certificate signing request
source scripts/common/execute_command.sh keytool -certreq -alias ${CN} -file ${CSR_PATH} -keystore ${KEYSTORE_PATH} -storepass ${KEYSTORE_PASSWORD} -keypass ${KEY_PASSWORD}

# Sign certificate
source scripts/common/execute_command.sh openssl x509 -req -CA ${CA_PEM_PATH} -CAkey ${CA_KEY_PATH} -in ${CSR_PATH} -out ${PEM_PATH} -days 3650

# Import CA certificate in keystore
source scripts/common/execute_command.sh keytool -keystore ${KEYSTORE_PATH} -alias CA -import -file ${CA_PEM_PATH} -storepass ${KEYSTORE_PASSWORD} -noprompt

# Import signed certificate in keystore
source scripts/common/execute_command.sh keytool -keystore ${KEYSTORE_PATH} -alias ${CN} -import -file ${PEM_PATH} -storepass ${KEYSTORE_PASSWORD} -keypass ${KEY_PASSWORD} -noprompt

# Import CA certificate in truststore
source scripts/common/execute_command.sh keytool -keystore ${TRUSTSTORE_PATH} -alias CA -import -file ${CA_PEM_PATH} -storepass ${TRUSTSTORE_PASSWORD} -noprompt

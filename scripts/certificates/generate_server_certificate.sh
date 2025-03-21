#! /bin/bash

# Exit if any command here fails
set -e

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            SERVER_KEY_PATH=*)              SERVER_KEY_PATH=${argument#*=} ;;
            SERVER_CSR_PATH=*)              SERVER_CSR_PATH=${argument#*=} ;;
            SERVER_CRT_PATH=*)              SERVER_CRT_PATH=${argument#*=} ;;
            SERVER_PEM_PATH=*)              SERVER_PEM_PATH=${argument#*=} ;;
            SERVER_CONFIG_PATH=*)           SERVER_CONFIG_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_DIR_PATH=*)     INTERMEDIATE_CA_DIR_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_CONFIG_PATH=*)  INTERMEDIATE_CA_CONFIG_PATH=${argument#*=} ;;
            *)                              echo "Unknown parameter: ${argument}"; return 1 ;;
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

# Export intermediate ca directory variable to use it in openssl commands with -config flag to use it in config itself
export INTERMEDIATE_CA_DIR=${INTERMEDIATE_CA_DIR_PATH}

# Generate private key (EdDSA curve Ed448)
source scripts/common/execute_command.sh openssl genpkey -algorithm RSA -out ${SERVER_KEY_PATH} -pkeyopt rsa_keygen_bits:2048

# Generate certificate signing request (new)
source scripts/common/execute_command.sh openssl req -new -config ${SERVER_CONFIG_PATH} -key ${SERVER_KEY_PATH} -out ${SERVER_CSR_PATH}

# Generate server certificate (no text in certificate, do not ask questions)
source scripts/common/execute_command.sh openssl ca -notext -batch -config ${INTERMEDIATE_CA_CONFIG_PATH} -in ${SERVER_CSR_PATH} -out ${SERVER_CRT_PATH}

# Create server pem file
cat ${SERVER_CRT_PATH} ${SERVER_KEY_PATH} > ${SERVER_PEM_PATH}

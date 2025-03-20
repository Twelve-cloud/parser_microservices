#! /bin/bash

# Exit if any command here fails
set -e

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            INTERMEDIATE_CA_DIR_PATH=*)     INTERMEDIATE_CA_DIR_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_KEY_PATH=*)     INTERMEDIATE_CA_KEY_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_CSR_PATH=*)     INTERMEDIATE_CA_CSR_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_CRT_PATH=*)     INTERMEDIATE_CA_CRT_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_PEM_PATH=*)     INTERMEDIATE_CA_PEM_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_CONFIG_PATH=*)  INTERMEDIATE_CA_CONFIG_PATH=${argument#*=} ;;
            ROOT_CA_DIR_PATH=*)             ROOT_CA_DIR_PATH=${argument#*=} ;;
            ROOT_CA_CONFIG_PATH=*)          ROOT_CA_CONFIG_PATH=${argument#*=} ;;
            *)                              echo "Unknown parameter: ${argument}"; return 1 ;;
        esac

    done

    return 0
}

# Parse named parameters
parse_named_parameters "$@"

# Check if the parsing was successful
if [[ $? -ne 0 ]]; then
    echo "Usage: generate_ca_certificate.sh CN=value CA_CRT_PATH=value CA_KEY_PATH=value CA_PEM_PATH=value"
    exit 1
fi

# Export root ca directory variable to use it in openssl commands with -config flag to use it in config itself
export ROOT_CA_DIR=${ROOT_CA_DIR_PATH}

# Export intermediate ca directory variable to use it in openssl commands with -config flag to use it in config itself
export INTERMEDIATE_CA_DIR=${INTERMEDIATE_CA_DIR_PATH}

# Create index file if not exist otherwise update the access and modification times
source scripts/common/execute_command.sh touch ${INTERMEDIATE_CA_DIR_PATH}/database/index.txt

# Generate private key (EdDSA curve Ed448)
source scripts/common/execute_command.sh openssl genpkey -algorithm ED448 -out ${INTERMEDIATE_CA_KEY_PATH}

# Generate certificate signing request (new)
source scripts/common/execute_command.sh openssl req -new -config ${INTERMEDIATE_CA_CONFIG_PATH} -key ${INTERMEDIATE_CA_KEY_PATH} -out ${INTERMEDIATE_CA_CSR_PATH}

# Generate intermediate ca certificate (no text in certificate, do not ask questions)
source scripts/common/execute_command.sh openssl ca -notext -batch -config ${ROOT_CA_CONFIG_PATH} -in ${INTERMEDIATE_CA_CSR_PATH} -out ${INTERMEDIATE_CA_CRT_PATH}

# Create intermediate ca pem file
cat ${INTERMEDIATE_CA_CRT_PATH} ${INTERMEDIATE_CA_KEY_PATH} > ${INTERMEDIATE_CA_PEM_PATH}

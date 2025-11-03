#! /bin/bash

# Exit if any command here fails
set -e

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            INTERMEDIATE_CA_KEY_PATH=*)              INTERMEDIATE_CA_KEY_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_CSR_PATH=*)              INTERMEDIATE_CA_CSR_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_CRT_PATH=*)              INTERMEDIATE_CA_CRT_PATH=${argument#*=} ;;
            INTERMEDIATE_CA_PEM_PATH=*)              INTERMEDIATE_CA_PEM_PATH=${argument#*=} ;;
            CONFIG_INTERMEDIATE_CA_CSR_PATH=*)       CONFIG_INTERMEDIATE_CA_CSR_PATH=${argument#*=} ;;
            CONFIG_ROOT_CA_DIR_PATH=*)               CONFIG_ROOT_CA_DIR_PATH=${argument#*=} ;;
            CONFIG_ROOT_CA_INTERMEDIATE_SIGN_PATH=*) CONFIG_ROOT_CA_INTERMEDIATE_SIGN_PATH=${argument#*=} ;;
            *)                                       echo "Unknown parameter: ${argument}"; return 1 ;;
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

# Export ca directory variable to use it in openssl commands with -config flag to use it in config itself
export ROOT_CA_DIR=${CONFIG_ROOT_CA_DIR_PATH}

# Create index file if not exist otherwise update the access and modification times
source scripts/common/execute_command.sh touch ${ROOT_CA_DIR}/database/index.txt

# Generate private key (RSA key 2048)
source scripts/common/execute_command.sh openssl genpkey -algorithm RSA -out ${INTERMEDIATE_CA_KEY_PATH} -pkeyopt rsa_keygen_bits:2048

# Generate certificate signing request (new)
source scripts/common/execute_command.sh openssl req -new -config ${CONFIG_INTERMEDIATE_CA_CSR_PATH} -key ${INTERMEDIATE_CA_KEY_PATH} -out ${INTERMEDIATE_CA_CSR_PATH}

# Generate intermediate ca certificate (no text in certificate, do not ask questions)
source scripts/common/execute_command.sh openssl ca -notext -batch -config ${CONFIG_ROOT_CA_INTERMEDIATE_SIGN_PATH} -in ${INTERMEDIATE_CA_CSR_PATH} -out ${INTERMEDIATE_CA_CRT_PATH}

# Create intermediate ca pem file
cat ${INTERMEDIATE_CA_CRT_PATH} ${INTERMEDIATE_CA_KEY_PATH} > ${INTERMEDIATE_CA_PEM_PATH}

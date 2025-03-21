#! /bin/bash

# Exit if any command here fails
set -e

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            ROOT_CA_DIR_PATH=*)     ROOT_CA_DIR_PATH=${argument#*=} ;;
            ROOT_CA_KEY_PATH=*)     ROOT_CA_KEY_PATH=${argument#*=} ;;
            ROOT_CA_CSR_PATH=*)     ROOT_CA_CSR_PATH=${argument#*=} ;;
            ROOT_CA_CRT_PATH=*)     ROOT_CA_CRT_PATH=${argument#*=} ;;
            ROOT_CA_PEM_PATH=*)     ROOT_CA_PEM_PATH=${argument#*=} ;;
            ROOT_CA_CONFIG_PATH=*)  ROOT_CA_CONFIG_PATH=${argument#*=} ;;
            *)                      echo "Unknown parameter: ${argument}"; return 1 ;;
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

# Export ca directory variable to use it in openssl commands with -config flag to use it in config itself
export ROOT_CA_DIR=${ROOT_CA_DIR_PATH}

# Create index file if not exist otherwise update the access and modification times
source scripts/common/execute_command.sh touch ${ROOT_CA_DIR_PATH}/database/index.txt

# Generate private key (EdDSA curve Ed448)
source scripts/common/execute_command.sh openssl genpkey -algorithm RSA -out ${ROOT_CA_KEY_PATH} -pkeyopt rsa_keygen_bits:2048

# Generate certificate signing request (new)
source scripts/common/execute_command.sh openssl req -new -config ${ROOT_CA_CONFIG_PATH} -key ${ROOT_CA_KEY_PATH} -out ${ROOT_CA_CSR_PATH}

# Generate root ca certificate (self-signed, no text in certificate, do not ask questions)
source scripts/common/execute_command.sh openssl ca -selfsign -notext -batch -extensions root_cert_extension_section -config ${ROOT_CA_CONFIG_PATH} -in ${ROOT_CA_CSR_PATH} -out ${ROOT_CA_CRT_PATH}

# Create root ca pem file
cat ${ROOT_CA_CRT_PATH} ${ROOT_CA_KEY_PATH} > ${ROOT_CA_PEM_PATH}

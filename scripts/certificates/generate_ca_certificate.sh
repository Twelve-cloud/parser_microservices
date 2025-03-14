#! /bin/bash

# Exit if any command here fails
set -e

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            CA_DIR_PATH=*)  CA_DIR_PATH=${argument#*=} ;;
            CA_KEY_PATH=*)  CA_KEY_PATH=${argument#*=} ;;
            CA_CSR_PATH=*)  CA_CSR_PATH=${argument#*=} ;;
            CA_CRT_PATH=*)  CA_CRT_PATH=${argument#*=} ;;
            CA_CONFIG_PATH=*) CA_CONFIG_PATH=${argument#*=} ;;
            *)              echo "Unknown parameter: ${argument}"; return 1 ;;
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
export CA_DIR=${CA_DIR_PATH}

# Create index file if not exist otherwise update the access and modification times
source scripts/common/execute_command.sh touch ${CA_DIR}/database/index.txt

# Create crlnumber file if not exist otherwise update the access and modification times
source scripts/common/execute_command.sh touch ${CA_DIR}/crl/crlnumber.txt

# Generate private key (EdDSA curve Ed448)
source scripts/common/execute_command.sh openssl genpkey -algorithm ED448 -out ${CA_KEY_PATH}

# Generate certificate signing request (new)
source scripts/common/execute_command.sh openssl req -new -config ${CA_CONFIG_PATH} -key ${CA_KEY_PATH} -out ${CA_CSR_PATH}

# Generate ca certificate (self-signed, no text in certificate, do not ask questions)
source scripts/common/execute_command.sh openssl ca -selfsign -notext -batch -config ${CA_CONFIG_PATH} -in ${CA_CSR_PATH} -out ${CA_CRT_PATH}

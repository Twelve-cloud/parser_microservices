#! /bin/bash

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            CN=*)           CN=${argument#*=} ;;
            CSR_PATH=*)     CSR_PATH=${argument#*=} ;;
            KEY_PATH=*)     KEY_PATH=${argument#*=} ;;
            CRT_PATH=*)     CRT_PATH=${argument#*=} ;;
            PEM_PATH=*)     PEM_PATH=${argument#*=} ;;
            CA_CRT_PATH=*)  CA_CRT_PATH=${argument#*=} ;;
            CA_KEY_PATH=*)  CA_KEY_PATH=${argument#*=} ;;
            FOLDER=*)       FOLDER=${argument#*=} ;;
            *)              echo "Unknown parameter: ${argument}"; return 1 ;;
        esac

    done

    return 0
}

# Parse named parameters
parse_named_parameters "$@"

# Check if the parsing was successful
if [[ $? -ne 0 ]]; then
    echo "Usage: generate_certificate.sh CN=value CSR_PATH=value KEY_PATH=value CRT_PATH=value PEM_PATH=value CA_CRT_PATH=value CA_KEY_PATH=value FOLDER=value"
    exit 1
fi

# Function to execute a command
function execute_command() {

    # Execute the command
    "$@" &> /dev/null

    # Check if the command failed
    if [[ $? -ne 0 ]]; then
        echo "Error: Command '$*' failed."
        exit 1
    fi
}

# Generate csr and key
execute_command openssl req -sha256 -new -nodes -subj "/CN=${CN}" -out ${CSR_PATH} -keyout ${KEY_PATH}

# Generate signed certificate
execute_command openssl x509 -req -sha256 -days 3650 -in ${CSR_PATH} -CA ${CA_CRT_PATH} -CAkey ${CA_KEY_PATH} -out ${CRT_PATH}

# Create certificate in PEM format
execute_command bash -c "cat ${CRT_PATH} ${KEY_PATH} > ${PEM_PATH}"

#! /bin/bash

# Function to parse named parameters
function parse_named_parameters() {

    # Loop through all parameter passed to the script
    for argument in "$@"; do

        # Check if the current argument is a named parameter
        case ${argument} in
            CN=*)           CN=${argument#*=} ;;
            CA_CRT_PATH=*)  CA_CRT_PATH=${argument#*=} ;;
            CA_KEY_PATH=*)  CA_KEY_PATH=${argument#*=} ;;
            CA_PEM_PATH=*)  CA_PEM_PATH=${argument#*=} ;;
            CA_FOLDER=*)    CA_FOLDER=${argument#*=} ;;
            *)              echo "Unknown parameter: ${argument}"; return 1 ;;
        esac

    done

    return 0
}

# Parse named parameters
parse_named_parameters "$@"

# Check if the parsing was successful
if [[ $? -ne 0 ]]; then
    echo "Usage: generate_ca_certificate.sh CN=value CA_CRT_PATH=value CA_KEY_PATH=value CA_PEM_PATH=value CA_FOLDER=value"
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

# Generate CA certificate
execute_command openssl req -sha256 -new -x509 -days 3650 -nodes -subj "/CN=${CN}" -out ${CA_CRT_PATH} -keyout ${CA_KEY_PATH}

# Create CA certificate in PEM format
execute_command bash -c "cat ${CA_CRT_PATH} ${CA_KEY_PATH} > ${CA_PEM_PATH}"

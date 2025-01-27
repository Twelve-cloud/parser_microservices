#! /bin/bash

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

# Execute the command
execute_command "$@"

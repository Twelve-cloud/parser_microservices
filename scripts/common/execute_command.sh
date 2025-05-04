#!/bin/bash

# Disable immediate exit on errors to handle them manually
set +e

# Style variables (ANSI escape codes)
RESET="\033[0m"           # Reset all styles
BOLD="\033[1m"            # Bold text
RED="\033[1;31m"          # Red text (bold)
YELLOW="\033[1;33m"       # Yellow text (bold)
WHITE="\033[1;37m"        # White text (bold)
BORDER_COLOR="\033[1;34m" # Blue color for borders
BORDER_CHAR="-"           # Border character
BORDER_LENGTH=120         # Border length

# Function to execute commands with error handling
execute_command() {
    # Create temporary file to capture output
    local tmpfile=$(mktemp)

    # Execute command, redirecting stdout and stderr to file
    "${@}" > ${tmpfile} 2>&1

    # Save command exit status
    local status=${?}

    # Read command output into variable
    local output
    output=$(<${tmpfile})

    # Remove temporary file
    rm -f ${tmpfile}

    # If command failed
    if [[ ${status} -ne 0 ]]; then
        # Create visual border
        local boundary
        boundary=$(printf "${BORDER_COLOR}%${BORDER_LENGTH}s${RESET}" | tr ' ' "${BORDER_CHAR}")

        # Print error header
        echo -e "${boundary}"
        echo -e "${RED}${BOLD}ERROR${RESET}: Command failed with status ${RED}${status}${RESET}"
        echo -e "Command: ${YELLOW}${BOLD}${*}${RESET}"
        echo -e "${boundary}"

        # Print command output
        echo -e "${WHITE}${BOLD}OUTPUT:${RESET}"
        echo -e "${output}"

        # Print closing border
        echo -e "${boundary}"

        # Exit with error code
        exit 1
    fi
}

# Execute the passed command
execute_command "${@}"

# Base image
FROM dpage/pgadmin4:9.11

# Change user to root
USER root

# Update index and install all dependencies
RUN                                             \
    # Update apk
    apk update &&                               \
    # Install dependencies
    apk add                                     \
    # Install envsubst
    envsubst                                    \
    # Install curl
    curl                                        \
    # Install bash
    bash

# Change user to pgadmin
USER pgadmin

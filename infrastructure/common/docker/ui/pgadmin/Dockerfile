# Base image
FROM dpage/pgadmin4:8.9

# Change user to root
USER root

# Change ownership to pgadmin user
RUN chown -R 5050:5050 /pgadmin4

# Update index and install all dependencies
RUN                                             \
    # Update apk
    apk update &&                               \
    # Install dependencies
    apk add                                     \
    # Install envsubst
    envsubst                                    \
    # Install curl
    curl

# Change user to pgadmin
USER pgadmin

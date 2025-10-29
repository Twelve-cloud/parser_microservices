# Base image
FROM postgres:18.0-alpine3.22

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
    # Install locales (locale, etc...)
    musl-locales                                \
    # Install coreutils (date, etc...)
    coreutils

# Change user to postgres
USER postgres

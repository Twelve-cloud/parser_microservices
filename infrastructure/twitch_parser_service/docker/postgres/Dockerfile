# Base image
FROM postgres:18.0-alpine3.22

# Change user to root
USER root

# Add envsubst and locale
RUN apk update && apk add envsubst musl-locales

# Change user to postgres
USER postgres

# Base image
FROM postgres:17.4-alpine3.20

# Change user to root
USER root

# Add envsubst and locale
RUN apk update && apk add envsubst musl-locales

# Change user to postgres
USER postgres

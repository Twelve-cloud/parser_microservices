# Base image
FROM postgres:16.3-alpine3.20

# Change user to root
USER root

# Add envsubst
RUN apk update && apk add envsubst

# Change user to postgres
USER postgres

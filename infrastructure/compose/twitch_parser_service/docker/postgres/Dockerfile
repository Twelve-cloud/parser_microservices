# Base image
FROM postgres:17.4-alpine3.21

# Change user to root
USER root

# Add envsubst
RUN apk update && apk add envsubst

# Change user to postgres
USER postgres

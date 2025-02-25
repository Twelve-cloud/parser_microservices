# Base image
FROM redis:7.4.0-alpine

# Change user to root
USER root

# Add envsubst
RUN apk update && apk add envsubst

# Change user to redis
USER redis

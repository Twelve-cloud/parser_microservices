# Base image
FROM apache/kafka:3.9.0

# Change user to root
USER root

# Add envsubst
RUN apk update && apk add envsubst

# Change user to appuser
USER appuser

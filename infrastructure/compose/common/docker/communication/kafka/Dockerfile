# Base image
FROM apache/kafka:3.9.0

# Change user to root
USER root

# Change ownership to kafka user
RUN chown -R 1000:1000 /mnt/shared/config

# Add envsubst
RUN apk update && apk add envsubst

# Change user to appuser
USER appuser

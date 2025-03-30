# Base image
FROM redpandadata/console:v2.8.3

# Change user to root
USER root

# Change ownership to redpandaconsole user
RUN chown -R 100:101 /app

# Add envsubst
RUN apk update && apk add envsubst curl

# Change user to redpandaconsole
USER redpandaconsole

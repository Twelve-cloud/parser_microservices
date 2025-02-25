# Base image
FROM mongo:7.0-rc-jammy

# Change user to root
USER root

# Add envsubst
RUN apt-get update && apt-get install gettext-base

# Change user to mongodb
USER mongodb

# Base image
FROM mongo:8.0.5-noble

# Change user to root
USER root

# Add envsubst
RUN apt-get update && apt-get install gettext-base

# Change user to mongodb
USER mongodb

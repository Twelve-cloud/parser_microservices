# Base image
FROM ubuntu/bind9:9.20-24.10_beta

# Change user to root
USER root

# Change ownership to bind user
RUN chown -R 100:101 /etc/bind

# Add envsubst
RUN apt-get update && apt-get install gettext-base

# Change user to bind
USER bind

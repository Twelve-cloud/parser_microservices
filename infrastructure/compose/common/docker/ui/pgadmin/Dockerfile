# Base image
FROM dpage/pgadmin4:8.9

# Change user to root
USER root

# Change ownership to pgadmin user
RUN chown -R 5050:5050 /pgadmin4

# Add envsubst
RUN apk update && apk add envsubst

# Change user to pgadmin
USER pgadmin

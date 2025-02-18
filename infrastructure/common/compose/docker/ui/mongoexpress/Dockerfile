# Base image
FROM mongo-express:1.0.2

# Change user to root
USER root

# Change ownership to mongoexpress user
RUN chown -R 1000:1000 /app

# Add envsubst
RUN apk update && apk add envsubst

# Change user to node
USER node

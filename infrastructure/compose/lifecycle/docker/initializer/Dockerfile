# Base image
FROM alpine:3.20

# Install openssl keytool and make
RUN apk update &&                                           \
    apk add                                                 \
    --no-cache                                              \
    openssl=3.3.3-r0                                        \
    openjdk21=21.0.6_p7-r0                                  \
    make=4.4.1-r2

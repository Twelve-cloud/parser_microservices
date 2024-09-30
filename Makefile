include .env
export

# ------------------------------------- ENV ------------------------------------------------------------------

.RECIPEPREFIX := $() $()
SHELL := bash -O extglob

COMPOSE :=                                                                                                   \
    -f docker-compose.yaml                                                                                   \
    -f ${COMPOSE_TWT_PARSER_POSTGRES}                                                                        \
    -f ${COMPOSE_TWT_PARSER_MONGO}                                                                           \
    -f ${COMPOSE_TWT_PARSER_REDIS}

COMPOSE_ENV :=                                                                                               \
    --env-file=.env                                                                                          \
    --env-file=infrastructure/twich_parser_service/compose/env/compose/.env                                  \

# ------------------------------------- APP ------------------------------------------------------------------

cbuild: docker-compose.yaml
    sudo docker compose -p parser-microservices ${COMPOSE_ENV} ${COMPOSE} up --build

cstart: docker-compose.yaml
    sudo docker compose -p parser-microservices ${COMPOSE_ENV} ${COMPOSE} up

cstart_detach: docker-compose.yaml
    sudo docker compose -p parser-microservices ${COMPOSE_ENV} ${COMPOSE} up --detach

cstop: docker-compose.yaml
    sudo docker compose -p parser-microservices ${COMPOSE_ENV} ${COMPOSE} down

# ---------------------------------- CONFIGURATION -----------------------------------------------------------

# Update CA certificates for server and client (10 years).
ca_certificates_update:
    sudo openssl req -sha256 -new -x509 -days 3650 -nodes -subj "/CN=CA"                                     \
    -out infrastructure/common/compose/certs/ca/server-ca.crt                                                \
    -keyout infrastructure/common/compose/certs/ca/server-ca.key

    sudo cat infrastructure/common/compose/certs/ca/server-ca.crt                                            \
    infrastructure/common/compose/certs/ca/server-ca.key                                                     \
    > infrastructure/common/compose/certs/ca/server-ca.pem

    sudo openssl req -sha256 -new -x509 -days 3650 -nodes -subj "/CN=CA"                                     \
    -out infrastructure/common/compose/certs/ca/client-ca.crt                                                \
    -keyout infrastructure/common/compose/certs/ca/client-ca.key

    sudo cat infrastructure/common/compose/certs/ca/client-ca.crt                                            \
    infrastructure/common/compose/certs/ca/client-ca.key                                                     \
    > infrastructure/common/compose/certs/ca/client-ca.pem

    sudo chmod a+r infrastructure/common/compose/certs/ca/*

# Create folder to store postgres data and give access to this folder to postgres user in container.
# You must use postgres alpine image instead of debian because debian image has different PID/GID.
cpostgres_init:
    sudo mkdir -p .compose-data/twich_parser_service/postgres-data
    sudo chown -R 70:70 .compose-data/twich_parser_service/postgres-data

# Update postgres server certificates (10 years).
cpostgres_certificates_update:
    sudo openssl req -sha256 -new -nodes -subj "/CN=postgres"                                                \
    -out infrastructure/twich_parser_service/compose/certs/postgres/server.csr                               \
    -keyout infrastructure/twich_parser_service/compose/certs/postgres/server.key

    sudo openssl x509 -req -sha256 -days 3650                                                                \
    -in infrastructure/twich_parser_service/compose/certs/postgres/server.csr                                \
    -CA infrastructure/common/compose/certs/ca/server-ca.crt                                                 \
    -CAkey infrastructure/common/compose/certs/ca/server-ca.key                                              \
    -out infrastructure/twich_parser_service/compose/certs/postgres/server.crt

    sudo cat infrastructure/twich_parser_service/compose/certs/postgres/server.crt                           \
    infrastructure/twich_parser_service/compose/certs/postgres/server.key                                    \
    > infrastructure/twich_parser_service/compose/certs/postgres/server.pem

    sudo chown -R 70:70 infrastructure/twich_parser_service/compose/certs/postgres/server.key
    sudo chown -R 70:70 infrastructure/twich_parser_service/compose/certs/postgres/server.crt

# Create folder to store mongo data and give access to this folder to mongo user in container.
# You must use mongo jammy image instead of nano image because nano image has different PID/GID.
cmongo_init:
    sudo mkdir -p .compose-data/twich_parser_service/mongo-data
    sudo chown -R 999:999 .compose-data/twich_parser_service/mongo-data

# Update mongo server certificates (10 years).
cmongo_certificates_update:
    sudo openssl req -sha256 -new -nodes -subj "/CN=mongo"                                                   \
    -out infrastructure/twich_parser_service/compose/certs/mongo/server.csr                                  \
    -keyout infrastructure/twich_parser_service/compose/certs/mongo/server.key

    sudo openssl x509 -req -sha256 -days 3650                                                                \
    -in infrastructure/twich_parser_service/compose/certs/mongo/server.csr                                   \
    -CA infrastructure/common/compose/certs/ca/server-ca.crt                                                 \
    -CAkey infrastructure/common/compose/certs/ca/server-ca.key                                              \
    -out infrastructure/twich_parser_service/compose/certs/mongo/server.crt

    sudo cat infrastructure/twich_parser_service/compose/certs/mongo/server.crt                              \
    infrastructure/twich_parser_service/compose/certs/mongo/server.key                                       \
    > infrastructure/twich_parser_service/compose/certs/mongo/server.pem

    sudo chown -R 999:999 infrastructure/twich_parser_service/compose/certs/mongo/server.pem

# Create folder to store redis data and give access to this folder to redis user in container.
# You must use redis alpine image instead of debian image because debian image has different PID/GID.
credis_init:
    sudo mkdir -p .compose-data/twich_parser_service/redis-data
    sudo chown -R 999:1000 .compose-data/twich_parser_service/redis-data

# Update redis server certificates (10 years).
credis_certificates_update:
    sudo openssl req -sha256 -new -nodes -subj "/CN=redis"                                                   \
    -out infrastructure/twich_parser_service/compose/certs/redis/server.csr                                  \
    -keyout infrastructure/twich_parser_service/compose/certs/redis/server.key

    sudo openssl x509 -req -sha256 -days 3650                                                                \
    -in infrastructure/twich_parser_service/compose/certs/redis/server.csr                                   \
    -CA infrastructure/common/compose/certs/ca/server-ca.crt                                                 \
    -CAkey infrastructure/common/compose/certs/ca/server-ca.key                                              \
    -out infrastructure/twich_parser_service/compose/certs/redis/server.crt

    sudo cat infrastructure/twich_parser_service/compose/certs/redis/server.crt                              \
    infrastructure/twich_parser_service/compose/certs/redis/server.key                                       \
    > infrastructure/twich_parser_service/compose/certs/redis/server.pem

    sudo chown -R 999:1000 infrastructure/twich_parser_service/compose/certs/redis/server.key
    sudo chown -R 999:1000 infrastructure/twich_parser_service/compose/certs/redis/server.crt

# Initialization.
cinit:
    $(MAKE) ca_certificates_update
    $(MAKE) cpostgres_init
    $(MAKE) cpostgres_certificates_update
    $(MAKE) cmongo_init
    $(MAKE) cmongo_certificates_update
    $(MAKE) credis_init
    $(MAKE) credis_certificates_update

# Remove all certificates and data folders.
cclear:
    sudo rm -rf .compose-data
    sudo rm -f infrastructure/common/compose/certs/ca/!(*example*)
    sudo rm -f infrastructure/twich_parser_service/compose/certs/postgres/!(*example*)
    sudo rm -f infrastructure/twich_parser_service/compose/certs/mongo/!(*example*)
    sudo rm -f infrastructure/twich_parser_service/compose/certs/redis/!(*example*)



####
cparser_certificates_update:
    sudo openssl req -sha256 -new -nodes -subj "/CN=parser"                                                   \
    -out infrastructure/twich_parser_service/compose/certs/parser/server.csr                                  \
    -keyout infrastructure/twich_parser_service/compose/certs/parser/server.key

    sudo openssl x509 -req -sha256 -days 3650                                                                \
    -in infrastructure/twich_parser_service/compose/certs/parser/server.csr                                   \
    -CA infrastructure/common/compose/certs/ca/client-ca.crt                                                 \
    -CAkey infrastructure/common/compose/certs/ca/client-ca.key                                              \
    -out infrastructure/twich_parser_service/compose/certs/parser/server.crt

    sudo cat infrastructure/twich_parser_service/compose/certs/parser/server.crt                              \
    infrastructure/twich_parser_service/compose/certs/parser/server.key                                       \
    > infrastructure/twich_parser_service/compose/certs/parser/server.pem

    sudo chmod a+r infrastructure/twich_parser_service/compose/certs/parser/*

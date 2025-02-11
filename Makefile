# ---------------------------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------- COMMON ---------------------------------------------------------------------

# ----------------------------------------------------------- INIT ----------------------------------------------------------------------

.RECIPEPREFIX := $() $()
SHELL := bash -O extglob

# ----------------------------------------------------------- ENV -----------------------------------------------------------------------

CERT_SCRIPTS_PATH := scripts/certificates/*
GENERATE_CA_CERTIFICATE_PATH := scripts/certificates/generate_ca_certificate.sh
GENERATE_CERTIFICATE_PATH := scripts/certificates/generate_certificate.sh

# ---------------------------------------------------------- SCRIPTS --------------------------------------------------------------------

_c_set_cert_scripts_permissions:
    @sudo chmod a+x $(CERT_SCRIPTS_PATH)

_c_configure_scripts:
    @$(MAKE) --no-print-directory _c_set_cert_scripts_permissions

# --------------------------------------------------------- COMPOSE ---------------------------------------------------------------------

# ----------------------------------------------------------- ENV -----------------------------------------------------------------------

COMPOSE_COMMON_CA_CRT_PATH := infrastructure/common/compose/certs/ca/ca.crt
COMPOSE_COMMON_CA_KEY_PATH := infrastructure/common/compose/certs/ca/ca.key
COMPOSE_COMMON_CA_PEM_PATH := infrastructure/common/compose/certs/ca/ca.pem
COMPOSE_COMMON_CA_CERTS_PATH := infrastructure/common/compose/certs/ca/!(*example*)
COMPOSE_COMMON_PGADMIN_CSR_PATH := infrastructure/common/compose/certs/ui/pgadmin/server.csr
COMPOSE_COMMON_PGADMIN_CRT_PATH := infrastructure/common/compose/certs/ui/pgadmin/server.crt
COMPOSE_COMMON_PGADMIN_KEY_PATH := infrastructure/common/compose/certs/ui/pgadmin/server.key
COMPOSE_COMMON_PGADMIN_PEM_PATH := infrastructure/common/compose/certs/ui/pgadmin/server.pem
COMPOSE_COMMON_PGADMIN_CERTS_PATH := infrastructure/common/compose/certs/ui/pgadmin/!(*example*)
COMPOSE_COMMON_MONGO_EXPRESS_CSR_PATH := infrastructure/common/compose/certs/ui/mongoexpress/server.csr
COMPOSE_COMMON_MONGO_EXPRESS_CRT_PATH := infrastructure/common/compose/certs/ui/mongoexpress/server.crt
COMPOSE_COMMON_MONGO_EXPRESS_KEY_PATH := infrastructure/common/compose/certs/ui/mongoexpress/server.key
COMPOSE_COMMON_MONGO_EXPRESS_PEM_PATH := infrastructure/common/compose/certs/ui/mongoexpress/server.pem
COMPOSE_COMMON_MONGO_EXPRESS_CERTS_PATH := infrastructure/common/compose/certs/ui/mongoexpress/!(*example*)
COMPOSE_COMMON_REDIS_INSIGHT_CSR_PATH := infrastructure/common/compose/certs/ui/redisinsight/server.csr
COMPOSE_COMMON_REDIS_INSIGHT_CRT_PATH := infrastructure/common/compose/certs/ui/redisinsight/server.crt
COMPOSE_COMMON_REDIS_INSIGHT_KEY_PATH := infrastructure/common/compose/certs/ui/redisinsight/server.key
COMPOSE_COMMON_REDIS_INSIGHT_PEM_PATH := infrastructure/common/compose/certs/ui/redisinsight/server.pem
COMPOSE_COMMON_REDIS_INSIGHT_CERTS_PATH := infrastructure/common/compose/certs/ui/redisinsight/!(*example*)

COMPOSE_TWT_PARSER_POSTGRES_CSR_PATH := infrastructure/twich_parser_service/compose/certs/postgres/server.csr
COMPOSE_TWT_PARSER_POSTGRES_CRT_PATH := infrastructure/twich_parser_service/compose/certs/postgres/server.crt
COMPOSE_TWT_PARSER_POSTGRES_KEY_PATH := infrastructure/twich_parser_service/compose/certs/postgres/server.key
COMPOSE_TWT_PARSER_POSTGRES_PEM_PATH := infrastructure/twich_parser_service/compose/certs/postgres/server.pem
COMPOSE_TWT_PARSER_POSTGRES_CERTS_PATH := infrastructure/twich_parser_service/compose/certs/postgres/!(*example*)
COMPOSE_TWT_PARSER_MONGO_CSR_PATH := infrastructure/twich_parser_service/compose/certs/mongo/server.csr
COMPOSE_TWT_PARSER_MONGO_CRT_PATH := infrastructure/twich_parser_service/compose/certs/mongo/server.crt
COMPOSE_TWT_PARSER_MONGO_KEY_PATH := infrastructure/twich_parser_service/compose/certs/mongo/server.key
COMPOSE_TWT_PARSER_MONGO_PEM_PATH := infrastructure/twich_parser_service/compose/certs/mongo/server.pem
COMPOSE_TWT_PARSER_MONGO_CERTS_PATH := infrastructure/twich_parser_service/compose/certs/mongo/!(*example*)
COMPOSE_TWT_PARSER_REDIS_CSR_PATH := infrastructure/twich_parser_service/compose/certs/redis/server.csr
COMPOSE_TWT_PARSER_REDIS_CRT_PATH := infrastructure/twich_parser_service/compose/certs/redis/server.crt
COMPOSE_TWT_PARSER_REDIS_KEY_PATH := infrastructure/twich_parser_service/compose/certs/redis/server.key
COMPOSE_TWT_PARSER_REDIS_PEM_PATH := infrastructure/twich_parser_service/compose/certs/redis/server.pem
COMPOSE_TWT_PARSER_REDIS_CERTS_PATH := infrastructure/twich_parser_service/compose/certs/redis/!(*example*)

COMPOSE_COMMON_PGADMIN_CONFIG_PATH := infrastructure/common/compose/configs/ui/pgadmin/*
COMPOSE_COMMON_PGADMIN_ENTRYPOINT_PATH := infrastructure/common/compose/entrypoints/ui/pgadmin/*
COMPOSE_COMMON_MONGO_EXPRESS_CONFIG_PATH := infrastructure/common/compose/configs/ui/mongoexpress/*
COMPOSE_COMMON_MONGO_EXPRESS_ENTRYPOINT_PATH := infrastructure/common/compose/entrypoints/ui/mongoexpress/*
COMPOSE_COMMON_REDIS_INSIGHT_CONFIG_PATH := infrastructure/common/compose/configs/ui/redisinsight/redisinsight.conf
COMPOSE_COMMON_REDIS_INSIGHT_NGINX_CONFIG_PATH := infrastructure/common/compose/configs/ui/redisinsight/nginx.conf
COMPOSE_COMMON_REDIS_INSIGHT_ENTRYPOINT_PATH := infrastructure/common/compose/entrypoints/ui/redisinsight/entrypoint-ri.sh
COMPOSE_COMMON_REDIS_INSIGHT_ENTRYPOINT_NGINX_PATH := infrastructure/common/compose/entrypoints/ui/redisinsight/entrypoint-nginx.sh
COMPOSE_COMMON_REDIS_INSIGHT_ENTRYPOINT_CURL_PATH := infrastructure/common/compose/entrypoints/ui/redisinsight/entrypoint-curl.sh

COMPOSE_TWT_PARSER_POSTGRES_CONFIG_PATH := infrastructure/twich_parser_service/compose/configs/postgres/*
COMPOSE_TWT_PARSER_MONGO_CONFIG_PATH := infrastructure/twich_parser_service/compose/configs/mongo/*
COMPOSE_TWT_PARSER_REDIS_CONFIG_PATH := infrastructure/twich_parser_service/compose/configs/redis/*
COMPOSE_TWT_PARSER_POSTGRES_ENTRYPOINT_PATH := infrastructure/twich_parser_service/compose/entrypoints/postgres/*
COMPOSE_TWT_PARSER_MONGO_ENTRYPOINT_PATH := infrastructure/twich_parser_service/compose/entrypoints/mongo/*
COMPOSE_TWT_PARSER_REDIS_ENTRYPOINT_PATH := infrastructure/twich_parser_service/compose/entrypoints/redis/*

COMPOSE_COMMON_REDIS_INSIGHT_SCRIPTS_PATH := infrastructure/common/compose/entrypoints/ui/redisinsight/*.sh

COMPOSE_COMMON_ENV_FILE_PATH := infrastructure/common/compose/env/compose/.env
COMPOSE_TWT_PARSER_ENV_FILE_PATH := infrastructure/twich_parser_service/compose/env/compose/.env

COMPOSE_COMMON_PGADMIN_PATH := infrastructure/common/compose/manifests/ui/docker-compose.pgadmin.override.yaml
COMPOSE_COMMON_MONGO_EXPRESS_PATH := infrastructure/common/compose/manifests/ui/docker-compose.mongoexpress.override.yaml
COMPOSE_COMMON_REDIS_INSIGHT_PATH := infrastructure/common/compose/manifests/ui/docker-compose.redisinsight.override.yaml

COMPOSE_TWT_PARSER_POSTGRES_PATH := infrastructure/twich_parser_service/compose/manifests/docker-compose.postgres.override.yaml
COMPOSE_TWT_PARSER_MONGO_PATH := infrastructure/twich_parser_service/compose/manifests/docker-compose.mongo.override.yaml
COMPOSE_TWT_PARSER_REDIS_PATH := infrastructure/twich_parser_service/compose/manifests/docker-compose.redis.override.yaml

# ------------------------------------------------------- ABBREVATIONS ------------------------------------------------------------------

COMPOSE_FILE_PATHS :=                                                                                                                   \
    -f $(COMPOSE_COMMON_PGADMIN_PATH)                                                                                                   \
    -f $(COMPOSE_COMMON_MONGO_EXPRESS_PATH)                                                                                             \
    -f $(COMPOSE_COMMON_REDIS_INSIGHT_PATH)                                                                                             \
    -f $(COMPOSE_TWT_PARSER_POSTGRES_PATH)                                                                                              \
    -f $(COMPOSE_TWT_PARSER_MONGO_PATH)                                                                                                 \
    -f $(COMPOSE_TWT_PARSER_REDIS_PATH)                                                                                                 \

COMPOSE_ENV_FILE_PATHS :=                                                                                                               \
    --env-file=$(COMPOSE_COMMON_ENV_FILE_PATH)                                                                                          \
    --env-file=$(COMPOSE_TWT_PARSER_ENV_FILE_PATH)                                                                                      \

# ------------------------------------------------------- CERTIFICATES ------------------------------------------------------------------

_c_generate_ca_certificate:
    @source $(GENERATE_CA_CERTIFICATE_PATH)                                                                                             \
    CN=CA                                                                                                                               \
    CA_CRT_PATH=$(COMPOSE_COMMON_CA_CRT_PATH)                                                                                           \
    CA_KEY_PATH=$(COMPOSE_COMMON_CA_KEY_PATH)                                                                                           \
    CA_PEM_PATH=$(COMPOSE_COMMON_CA_PEM_PATH)                                                                                           \

_c_generate_pgadmin_certificate:
    @source $(GENERATE_CERTIFICATE_PATH)                                                                                                \
    CN=pgadmin                                                                                                                          \
    CSR_PATH=$(COMPOSE_COMMON_PGADMIN_CSR_PATH)                                                                                         \
    CRT_PATH=$(COMPOSE_COMMON_PGADMIN_CRT_PATH)                                                                                         \
    KEY_PATH=$(COMPOSE_COMMON_PGADMIN_KEY_PATH)                                                                                         \
    PEM_PATH=$(COMPOSE_COMMON_PGADMIN_PEM_PATH)                                                                                         \
    CA_CRT_PATH=$(COMPOSE_COMMON_CA_CRT_PATH)                                                                                           \
    CA_KEY_PATH=$(COMPOSE_COMMON_CA_KEY_PATH)                                                                                           \

_c_generate_mongo_express_certificate:
    @source $(GENERATE_CERTIFICATE_PATH)                                                                                                \
    CN=mongo-express                                                                                                                    \
    CSR_PATH=$(COMPOSE_COMMON_MONGO_EXPRESS_CSR_PATH)                                                                                   \
    CRT_PATH=$(COMPOSE_COMMON_MONGO_EXPRESS_CRT_PATH)                                                                                   \
    KEY_PATH=$(COMPOSE_COMMON_MONGO_EXPRESS_KEY_PATH)                                                                                   \
    PEM_PATH=$(COMPOSE_COMMON_MONGO_EXPRESS_PEM_PATH)                                                                                   \
    CA_CRT_PATH=$(COMPOSE_COMMON_CA_CRT_PATH)                                                                                           \
    CA_KEY_PATH=$(COMPOSE_COMMON_CA_KEY_PATH)                                                                                           \

_c_generate_redis_insight_certificate:
    @source $(GENERATE_CERTIFICATE_PATH)                                                                                                \
    CN=redis-insight                                                                                                                    \
    CSR_PATH=$(COMPOSE_COMMON_REDIS_INSIGHT_CSR_PATH)                                                                                   \
    CRT_PATH=$(COMPOSE_COMMON_REDIS_INSIGHT_CRT_PATH)                                                                                   \
    KEY_PATH=$(COMPOSE_COMMON_REDIS_INSIGHT_KEY_PATH)                                                                                   \
    PEM_PATH=$(COMPOSE_COMMON_REDIS_INSIGHT_PEM_PATH)                                                                                   \
    CA_CRT_PATH=$(COMPOSE_COMMON_CA_CRT_PATH)                                                                                           \
    CA_KEY_PATH=$(COMPOSE_COMMON_CA_KEY_PATH)                                                                                           \

_c_generate_twt_parser_postgres_certificate:
    @source $(GENERATE_CERTIFICATE_PATH)                                                                                                \
    CN=parser-postgres                                                                                                                  \
    CSR_PATH=$(COMPOSE_TWT_PARSER_POSTGRES_CSR_PATH)                                                                                    \
    CRT_PATH=$(COMPOSE_TWT_PARSER_POSTGRES_CRT_PATH)                                                                                    \
    KEY_PATH=$(COMPOSE_TWT_PARSER_POSTGRES_KEY_PATH)                                                                                    \
    PEM_PATH=$(COMPOSE_TWT_PARSER_POSTGRES_PEM_PATH)                                                                                    \
    CA_CRT_PATH=$(COMPOSE_COMMON_CA_CRT_PATH)                                                                                           \
    CA_KEY_PATH=$(COMPOSE_COMMON_CA_KEY_PATH)                                                                                           \

_c_generate_twt_parser_mongo_certificate:
    @source $(GENERATE_CERTIFICATE_PATH)                                                                                                \
    CN=parser-mongo                                                                                                                     \
    CSR_PATH=$(COMPOSE_TWT_PARSER_MONGO_CSR_PATH)                                                                                       \
    CRT_PATH=$(COMPOSE_TWT_PARSER_MONGO_CRT_PATH)                                                                                       \
    KEY_PATH=$(COMPOSE_TWT_PARSER_MONGO_KEY_PATH)                                                                                       \
    PEM_PATH=$(COMPOSE_TWT_PARSER_MONGO_PEM_PATH)                                                                                       \
    CA_CRT_PATH=$(COMPOSE_COMMON_CA_CRT_PATH)                                                                                           \
    CA_KEY_PATH=$(COMPOSE_COMMON_CA_KEY_PATH)                                                                                           \

_c_generate_twt_parser_redis_certificate:
    @source $(GENERATE_CERTIFICATE_PATH)                                                                                                \
    CN=parser-redis                                                                                                                     \
    CSR_PATH=$(COMPOSE_TWT_PARSER_REDIS_CSR_PATH)                                                                                       \
    CRT_PATH=$(COMPOSE_TWT_PARSER_REDIS_CRT_PATH)                                                                                       \
    KEY_PATH=$(COMPOSE_TWT_PARSER_REDIS_KEY_PATH)                                                                                       \
    PEM_PATH=$(COMPOSE_TWT_PARSER_REDIS_PEM_PATH)                                                                                       \
    CA_CRT_PATH=$(COMPOSE_COMMON_CA_CRT_PATH)                                                                                           \
    CA_KEY_PATH=$(COMPOSE_COMMON_CA_KEY_PATH)                                                                                           \

# ------------------------------------------------------- PERMISSIONS -------------------------------------------------------------------

_c_set_ca_permissions:
    @sudo chmod a+r $(COMPOSE_COMMON_CA_CERTS_PATH)

_c_set_pgadmin_permissions:
    @sudo chown 5050:5050 $(COMPOSE_COMMON_PGADMIN_CERTS_PATH)
    @sudo chown 5050:5050 $(COMPOSE_COMMON_PGADMIN_CONFIG_PATH)
    @sudo chown 5050:5050 $(COMPOSE_COMMON_PGADMIN_ENTRYPOINT_PATH)
    @sudo chmod +x $(COMPOSE_COMMON_PGADMIN_ENTRYPOINT_PATH)

_c_set_mongo_express_permissions:
    @sudo chown 1000:1000 $(COMPOSE_COMMON_MONGO_EXPRESS_CERTS_PATH)
    @sudo chown 1000:1000 $(COMPOSE_COMMON_MONGO_EXPRESS_CONFIG_PATH)
    @sudo chown 1000:1000 $(COMPOSE_COMMON_MONGO_EXPRESS_ENTRYPOINT_PATH)
    @sudo chmod +x $(COMPOSE_COMMON_MONGO_EXPRESS_ENTRYPOINT_PATH)

_c_set_redis_insight_permissions:
    @sudo chown 1000:1000 $(COMPOSE_COMMON_REDIS_INSIGHT_CERTS_PATH)
    @sudo chmod a+r $(COMPOSE_COMMON_REDIS_INSIGHT_CERTS_PATH)

    @sudo chown 1000:1000 $(COMPOSE_COMMON_REDIS_INSIGHT_CONFIG_PATH)
    @sudo chown 1000:1000 $(COMPOSE_COMMON_REDIS_INSIGHT_ENTRYPOINT_PATH)
    @sudo chmod +x $(COMPOSE_COMMON_REDIS_INSIGHT_ENTRYPOINT_PATH)

    @sudo chown 101:101 $(COMPOSE_COMMON_REDIS_INSIGHT_NGINX_CONFIG_PATH)
    @sudo chown 101:101 $(COMPOSE_COMMON_REDIS_INSIGHT_NGINX_ENTRYPOINT_PATH)
    @sudo chmod +x $(COMPOSE_COMMON_REDIS_INSIGHT_NGINX_ENTRYPOINT_PATH)

    @sudo chown 100:101 $(COMPOSE_COMMON_REDIS_INSIGHT_CURL_ENTRYPOINT_PATH)
    @sudo chmod +x $(COMPOSE_COMMON_REDIS_INSIGHT_CURL_ENTRYPOINT_PATH)

_c_set_twt_parser_postgres_permissions:
    @sudo chown 70:70 $(COMPOSE_TWT_PARSER_POSTGRES_CERTS_PATH)
    @sudo chown 70:70 $(COMPOSE_TWT_PARSER_POSTGRES_CONFIG_PATH)
    @sudo chown 70:70 $(COMPOSE_TWT_PARSER_POSTGRES_ENTRYPOINT_PATH)
    @sudo chmod +x $(COMPOSE_TWT_PARSER_POSTGRES_ENTRYPOINT_PATH)

_c_set_twt_parser_mongo_permissions:
    @sudo chown 999:999 $(COMPOSE_TWT_PARSER_MONGO_CERTS_PATH)
    @sudo chown 999:999 $(COMPOSE_TWT_PARSER_MONGO_CONFIG_PATH)
    @sudo chown 999:999 $(COMPOSE_TWT_PARSER_MONGO_ENTRYPOINT_PATH)
    @sudo chmod +x $(COMPOSE_TWT_PARSER_MONGO_ENTRYPOINT_PATH)

_c_set_twt_parser_redis_permissions:
    @sudo chown 999:1000 $(COMPOSE_TWT_PARSER_REDIS_CERTS_PATH)
    @sudo chown 999:1000 $(COMPOSE_TWT_PARSER_REDIS_CONFIG_PATH)
    @sudo chown 999:1000 $(COMPOSE_TWT_PARSER_REDIS_ENTRYPOINT_PATH)
    @sudo chmod +x $(COMPOSE_TWT_PARSER_REDIS_ENTRYPOINT_PATH)

# ------------------------------------------------------ CONFIGURATION ------------------------------------------------------------------

_c_configure_ca:
    @$(MAKE) --no-print-directory _c_generate_ca_certificate
    @$(MAKE) --no-print-directory _c_set_ca_permissions

_c_configure_pgadmin:
    @$(MAKE) --no-print-directory _c_generate_pgadmin_certificate
    @$(MAKE) --no-print-directory _c_set_pgadmin_permissions

_c_configure_mongo_express:
    @$(MAKE) --no-print-directory _c_generate_mongo_express_certificate
    @$(MAKE) --no-print-directory _c_set_mongo_express_permissions

_c_configure_redis_insight:
    @$(MAKE) --no-print-directory _c_generate_redis_insight_certificate
    @$(MAKE) --no-print-directory _c_set_redis_insight_permissions

_c_configure_twt_parser_postgres:
    @$(MAKE) --no-print-directory _c_generate_twt_parser_postgres_certificate
    @$(MAKE) --no-print-directory _c_set_twt_parser_postgres_permissions

_c_configure_twt_parser_mongo:
    @$(MAKE) --no-print-directory _c_generate_twt_parser_mongo_certificate
    @$(MAKE) --no-print-directory _c_set_twt_parser_mongo_permissions

_c_configure_twt_parser_redis:
    @$(MAKE) --no-print-directory _c_generate_twt_parser_redis_certificate
    @$(MAKE) --no-print-directory _c_set_twt_parser_redis_permissions

# --------------------------------------------------------- COMMANDS --------------------------------------------------------------------

cbuild:
    @docker compose --project-name parser-microservices --project-directory . $(COMPOSE_ENV_FILE_PATHS) $(COMPOSE_FILE_PATHS) up --build

cstart:
    @docker compose --project-name parser-microservices --project-directory . $(COMPOSE_ENV_FILE_PATHS) $(COMPOSE_FILE_PATHS) up

cstartd:
    @docker compose --project-name parser-microservices --project-directory . $(COMPOSE_ENV_FILE_PATHS) $(COMPOSE_FILE_PATHS) up --detach

cstop:
    @docker compose --project-name parser-microservices --project-directory . $(COMPOSE_ENV_FILE_PATHS) $(COMPOSE_FILE_PATHS) down

cclean:
    @sudo rm -f $(COMPOSE_COMMON_CA_CERTS_PATH)
    @sudo rm -f $(COMPOSE_COMMON_PGADMIN_CERTS_PATH)
    @sudo rm -f $(COMPOSE_COMMON_MONGO_EXPRESS_CERTS_PATH)
    @sudo rm -f $(COMPOSE_COMMON_REDIS_INSIGHT_CERTS_PATH)
    @sudo rm -f $(COMPOSE_TWT_PARSER_POSTGRES_CERTS_PATH)
    @sudo rm -f $(COMPOSE_TWT_PARSER_MONGO_CERTS_PATH)
    @sudo rm -f $(COMPOSE_TWT_PARSER_REDIS_CERTS_PATH)

cinit:
    @$(MAKE) --no-print-directory _c_configure_scripts
    @$(MAKE) --no-print-directory _c_configure_ca
    @$(MAKE) --no-print-directory _c_configure_pgadmin
    @$(MAKE) --no-print-directory _c_configure_mongo_express
    @$(MAKE) --no-print-directory _c_configure_redis_insight
    @$(MAKE) --no-print-directory _c_configure_twt_parser_postgres
    @$(MAKE) --no-print-directory _c_configure_twt_parser_mongo
    @$(MAKE) --no-print-directory _c_configure_twt_parser_redis

# ---------------------------------------------------------------------------------------------------------------------------------------

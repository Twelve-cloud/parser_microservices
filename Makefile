include .env
export

.RECIPEPREFIX := $() $()
SHELL := bash -O extglob

# ----------------------------------------- COMMON ------------------------------------------------------
# ----------------------------------------- SCRIPTS -----------------------------------------------------

_c_set_cert_scripts_permissions:
    @sudo chmod a+x ${CERT_SCRIPTS_PATH}

_c_configure_scripts:
    @$(MAKE) --no-print-directory _c_set_cert_scripts_permissions

# ----------------------------------------- COMPOSE ------------------------------------------------------
# ------------------------------------------- ENV --------------------------------------------------------

COMPOSE_FILE_PATHS :=                                                                                    \
    -f docker-compose.yaml                                                                               \
    -f ${COMPOSE_COMMON_PGADMIN_PATH}                                                                    \
    -f ${COMPOSE_COMMON_MONGO_EXPRESS_PATH}                                                              \
    -f ${COMPOSE_COMMON_REDIS_INSIGHT_PATH}                                                              \
    -f ${COMPOSE_TWT_PARSER_POSTGRES_PATH}                                                               \
    -f ${COMPOSE_TWT_PARSER_MONGO_PATH}                                                                  \
    -f ${COMPOSE_TWT_PARSER_REDIS_PATH}                                                                  \

COMPOSE_ENV_FILE_PATHS :=                                                                                \
    --env-file=${COMPOSE_ENV_FILE_PATH}                                                                  \
    --env-file=${COMPOSE_COMMON_ENV_FILE_PATH}                                                           \
    --env-file=${COMPOSE_TWT_PARSER_ENV_FILE_PATH}                                                       \

# ---------------------------------------- CERTIFICATES --------------------------------------------------

_c_generate_ca_certificate:
    @./scripts/certificates/generate_ca_certificate.sh                                                   \
    CN=CA                                                                                                \
    CA_CRT_PATH=${COMPOSE_CA_CRT_PATH}                                                                   \
    CA_KEY_PATH=${COMPOSE_CA_KEY_PATH}                                                                   \
    CA_PEM_PATH=${COMPOSE_CA_PEM_PATH}                                                                   \

_c_generate_pgadmin_certificate:
    @./scripts/certificates/generate_certificate.sh                                                      \
    CN=pgadmin                                                                                           \
    CSR_PATH=${COMPOSE_PGADMIN_CSR_PATH}                                                                 \
    CRT_PATH=${COMPOSE_PGADMIN_CRT_PATH}                                                                 \
    KEY_PATH=${COMPOSE_PGADMIN_KEY_PATH}                                                                 \
    PEM_PATH=${COMPOSE_PGADMIN_PEM_PATH}                                                                 \
    CA_CRT_PATH=${COMPOSE_CA_CRT_PATH}                                                                   \
    CA_KEY_PATH=${COMPOSE_CA_KEY_PATH}                                                                   \

_c_generate_mongo_express_certificate:
    @./scripts/certificates/generate_certificate.sh                                                      \
    CN=mongo-express                                                                                     \
    CSR_PATH=${COMPOSE_MONGO_EXPRESS_CSR_PATH}                                                           \
    CRT_PATH=${COMPOSE_MONGO_EXPRESS_CRT_PATH}                                                           \
    KEY_PATH=${COMPOSE_MONGO_EXPRESS_KEY_PATH}                                                           \
    PEM_PATH=${COMPOSE_MONGO_EXPRESS_PEM_PATH}                                                           \
    CA_CRT_PATH=${COMPOSE_CA_CRT_PATH}                                                                   \
    CA_KEY_PATH=${COMPOSE_CA_KEY_PATH}                                                                   \

_c_generate_redis_insight_certificate:
    @./scripts/certificates/generate_certificate.sh                                                      \
    CN=redis-insight                                                                                     \
    CSR_PATH=${COMPOSE_REDIS_INSIGHT_CSR_PATH}                                                           \
    CRT_PATH=${COMPOSE_REDIS_INSIGHT_CRT_PATH}                                                           \
    KEY_PATH=${COMPOSE_REDIS_INSIGHT_KEY_PATH}                                                           \
    PEM_PATH=${COMPOSE_REDIS_INSIGHT_PEM_PATH}                                                           \
    CA_CRT_PATH=${COMPOSE_CA_CRT_PATH}                                                                   \
    CA_KEY_PATH=${COMPOSE_CA_KEY_PATH}                                                                   \

_c_generate_twt_parser_postgres_certificate:
    @./scripts/certificates/generate_certificate.sh                                                      \
    CN=parser-postgres                                                                                   \
    CSR_PATH=${COMPOSE_TWT_PARSER_POSTGRES_CSR_PATH}                                                     \
    CRT_PATH=${COMPOSE_TWT_PARSER_POSTGRES_CRT_PATH}                                                     \
    KEY_PATH=${COMPOSE_TWT_PARSER_POSTGRES_KEY_PATH}                                                     \
    PEM_PATH=${COMPOSE_TWT_PARSER_POSTGRES_PEM_PATH}                                                     \
    CA_CRT_PATH=${COMPOSE_CA_CRT_PATH}                                                                   \
    CA_KEY_PATH=${COMPOSE_CA_KEY_PATH}                                                                   \

_c_generate_twt_parser_mongo_certificate:
    @./scripts/certificates/generate_certificate.sh                                                      \
    CN=parser-mongo                                                                                      \
    CSR_PATH=${COMPOSE_TWT_PARSER_MONGO_CSR_PATH}                                                        \
    CRT_PATH=${COMPOSE_TWT_PARSER_MONGO_CRT_PATH}                                                        \
    KEY_PATH=${COMPOSE_TWT_PARSER_MONGO_KEY_PATH}                                                        \
    PEM_PATH=${COMPOSE_TWT_PARSER_MONGO_PEM_PATH}                                                        \
    CA_CRT_PATH=${COMPOSE_CA_CRT_PATH}                                                                   \
    CA_KEY_PATH=${COMPOSE_CA_KEY_PATH}                                                                   \

_c_generate_twt_parser_redis_certificate:
    @./scripts/certificates/generate_certificate.sh                                                      \
    CN=parser-redis                                                                                      \
    CSR_PATH=${COMPOSE_TWT_PARSER_REDIS_CSR_PATH}                                                        \
    CRT_PATH=${COMPOSE_TWT_PARSER_REDIS_CRT_PATH}                                                        \
    KEY_PATH=${COMPOSE_TWT_PARSER_REDIS_KEY_PATH}                                                        \
    PEM_PATH=${COMPOSE_TWT_PARSER_REDIS_PEM_PATH}                                                        \
    CA_CRT_PATH=${COMPOSE_CA_CRT_PATH}                                                                   \
    CA_KEY_PATH=${COMPOSE_CA_KEY_PATH}                                                                   \

# ----------------------------------------- PERMISSIONS --------------------------------------------------

_c_set_ca_permissions:
    @sudo chmod a+r ${COMPOSE_CA_CERTS_PATH}

_c_set_pgadmin_permissions:
    @sudo chown 5050:5050 ${COMPOSE_PGADMIN_CERTS_PATH}

_c_set_mongo_express_permissions:
    @sudo chown 1000:1000 ${COMPOSE_MONGO_EXPRESS_CERTS_PATH}

_c_set_redis_insight_permissions:
    @sudo chown 1000:1000 ${COMPOSE_REDIS_INSIGHT_CERTS_PATH}
    @sudo chmod a+r ${COMPOSE_REDIS_INSIGHT_CERTS_PATH}
    @sudo chmod a+x ${COMPOSE_REDIS_INSIGHT_SCRIPTS_PATH}

_c_set_twt_parser_postgres_permissions:
    @sudo chown 70:70 ${COMPOSE_TWT_PARSER_POSTGRES_CERTS_PATH}

_c_set_twt_parser_mongo_permissions:
    @sudo chown 999:999 ${COMPOSE_TWT_PARSER_MONGO_CERTS_PATH}

_c_set_twt_parser_redis_permissions:
    @sudo chown 999:1000 ${COMPOSE_TWT_PARSER_REDIS_CERTS_PATH}

# ----------------------------------------- CONFIGURATION ------------------------------------------------

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

# ------------------------------------------- COMMANDS ---------------------------------------------------

cbuild: docker-compose.yaml
    @docker compose -p parser-microservices ${COMPOSE_ENV_FILE_PATHS} ${COMPOSE_FILE_PATHS} up --build

cstart: docker-compose.yaml
    @docker compose -p parser-microservices ${COMPOSE_ENV_FILE_PATHS} ${COMPOSE_FILE_PATHS} up

cstartd: docker-compose.yaml
    @docker compose -p parser-microservices ${COMPOSE_ENV_FILE_PATHS} ${COMPOSE_FILE_PATHS} up --detach

cstop: docker-compose.yaml
    @docker compose -p parser-microservices ${COMPOSE_ENV_FILE_PATHS} ${COMPOSE_FILE_PATHS} down

cclean:
    @sudo rm -f ${COMPOSE_CA_CERTS_PATH}
    @sudo rm -f ${COMPOSE_PGADMIN_CERTS_PATH}
    @sudo rm -f ${COMPOSE_MONGO_EXPRESS_CERTS_PATH}
    @sudo rm -f ${COMPOSE_REDIS_INSIGHT_CERTS_PATH}
    @sudo rm -f ${COMPOSE_TWT_PARSER_POSTGRES_CERTS_PATH}
    @sudo rm -f ${COMPOSE_TWT_PARSER_MONGO_CERTS_PATH}
    @sudo rm -f ${COMPOSE_TWT_PARSER_REDIS_CERTS_PATH}

cinit:
    @$(MAKE) --no-print-directory _c_configure_scripts
    @$(MAKE) --no-print-directory _c_configure_ca
    @$(MAKE) --no-print-directory _c_configure_pgadmin
    @$(MAKE) --no-print-directory _c_configure_mongo_express
    @$(MAKE) --no-print-directory _c_configure_redis_insight
    @$(MAKE) --no-print-directory _c_configure_twt_parser_postgres
    @$(MAKE) --no-print-directory _c_configure_twt_parser_mongo
    @$(MAKE) --no-print-directory _c_configure_twt_parser_redis

# ---------------------------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------- COMMON ---------------------------------------------------------------------

# ----------------------------------------------------------- INIT ----------------------------------------------------------------------

include .env
export

.RECIPEPREFIX := $() $()
SHELL := bash -O extglob

# ---------------------------------------------------------- SCRIPTS --------------------------------------------------------------------

_set_common_scripts_permissions:
    @sudo chmod a+x ${COMMON_SCRIPTS_PATH}

_set_cert_scripts_permissions:
    @sudo chmod a+x ${CERTIFICATES_SCRIPTS_PATH}

_configure_scripts:
    @$(MAKE) --no-print-directory _set_common_scripts_permissions
    @$(MAKE) --no-print-directory _set_cert_scripts_permissions

# --------------------------------------------------------- COMMANDS --------------------------------------------------------------------

check_key:
    @openssl pkey -in $(path) -noout -text

check_csr:
    @openssl req -in $(path) -noout -text

check_crt:
    @openssl x509 -in $(path) -noout -text

verify_crt:
    @openssl verify -verbose -show_chain $(path)

# --------------------------------------------------------- COMPOSE ---------------------------------------------------------------------

# ------------------------------------------------------- ABBREVATIONS ------------------------------------------------------------------

COMPOSE_FILE_PATHS :=                                                                                                                   \
    -f ${COMPOSE_COMMON_REDPANDA_PATH}                                                                                                  \
    -f ${COMPOSE_COMMON_PGADMIN_PATH}                                                                                                   \
    -f ${COMPOSE_COMMON_MONGO_EXPRESS_PATH}                                                                                             \
    -f ${COMPOSE_COMMON_REDIS_INSIGHT_PATH}                                                                                             \
    -f ${COMPOSE_COMMON_BIND_PATH}                                                                                                      \
    -f ${COMPOSE_COMMON_KAFKA_PATH}                                                                                                     \
    -f ${COMPOSE_TWT_PARSER_POSTGRES_PATH}                                                                                              \
    -f ${COMPOSE_TWT_PARSER_MONGO_PATH}                                                                                                 \
    -f ${COMPOSE_TWT_PARSER_REDIS_PATH}                                                                                                 \

# ------------------------------------------------------- CERTIFICATES ------------------------------------------------------------------

_c_generate_root_ca_certificate:
    @source ${GENERATE_ROOT_CA_CERTIFICATE_PATH}                                                                                        \
    ROOT_CA_DIR_PATH=${COMPOSE_COMMON_ROOT_CA_DIR_PATH}                                                                                 \
    ROOT_CA_KEY_PATH=${COMPOSE_COMMON_ROOT_CA_KEY_PATH}                                                                                 \
    ROOT_CA_CSR_PATH=${COMPOSE_COMMON_ROOT_CA_CSR_PATH}                                                                                 \
    ROOT_CA_CRT_PATH=${COMPOSE_COMMON_ROOT_CA_CRT_PATH}                                                                                 \
    ROOT_CA_CONFIG_PATH=${COMPOSE_COMMON_ROOT_CA_OPENSSL_CONFIG_PATH}                                                                   \

_c_generate_intermediate_ca_certificate:
    @source ${GENERATE_INTERMEDIATE_CA_CERTIFICATE_PATH}                                                                                \
    INTERMEDIATE_CA_DIR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_DIR_PATH}                                                                 \
    INTERMEDIATE_CA_KEY_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_KEY_PATH}                                                                 \
    INTERMEDIATE_CA_CSR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_CSR_PATH}                                                                 \
    INTERMEDIATE_CA_CRT_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_CRT_PATH}                                                                 \
    INTERMEDIATE_CA_CONFIG_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                                   \
    ROOT_CA_DIR_PATH=${COMPOSE_COMMON_ROOT_CA_DIR_PATH}                                                                                 \
    ROOT_CA_CONFIG_PATH=${COMPOSE_COMMON_ROOT_CA_OPENSSL_CONFIG_PATH}                                                                   \

_c_generate_redpanda_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                                         \
    SERVER_KEY_PATH=${COMPOSE_COMMON_REDPANDA_KEY_PATH}                                                                                 \
    SERVER_CSR_PATH=${COMPOSE_COMMON_REDPANDA_CSR_PATH}                                                                                 \
    SERVER_CRT_PATH=${COMPOSE_COMMON_REDPANDA_CRT_PATH}                                                                                 \
    SERVER_CONFIG_PATH=${COMPOSE_COMMON_REDPANDA_OPENSSL_CONFIG_PATH}                                                                   \
    INTERMEDIATE_CA_DIR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_DIR_PATH}                                                                 \
    INTERMEDIATE_CA_CONFIG_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                                   \

_c_generate_pgadmin_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                                         \
    SERVER_KEY_PATH=${COMPOSE_COMMON_PGADMIN_KEY_PATH}                                                                                  \
    SERVER_CSR_PATH=${COMPOSE_COMMON_PGADMIN_CSR_PATH}                                                                                  \
    SERVER_CRT_PATH=${COMPOSE_COMMON_PGADMIN_CRT_PATH}                                                                                  \
    SERVER_CONFIG_PATH=${COMPOSE_COMMON_PGADMIN_OPENSSL_CONFIG_PATH}                                                                    \
    INTERMEDIATE_CA_DIR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_DIR_PATH}                                                                 \
    INTERMEDIATE_CA_CONFIG_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                                   \

_c_generate_mongo_express_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                                         \
    SERVER_KEY_PATH=${COMPOSE_COMMON_MONGO_EXPRESS_KEY_PATH}                                                                            \
    SERVER_CSR_PATH=${COMPOSE_COMMON_MONGO_EXPRESS_CSR_PATH}                                                                            \
    SERVER_CRT_PATH=${COMPOSE_COMMON_MONGO_EXPRESS_CRT_PATH}                                                                            \
    SERVER_CONFIG_PATH=${COMPOSE_COMMON_MONGO_EXPRESS_OPENSSL_CONFIG_PATH}                                                              \
    INTERMEDIATE_CA_DIR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_DIR_PATH}                                                                 \
    INTERMEDIATE_CA_CONFIG_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                                   \

_c_generate_redis_insight_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                                         \
    SERVER_KEY_PATH=${COMPOSE_COMMON_REDIS_INSIGHT_KEY_PATH}                                                                            \
    SERVER_CSR_PATH=${COMPOSE_COMMON_REDIS_INSIGHT_CSR_PATH}                                                                            \
    SERVER_CRT_PATH=${COMPOSE_COMMON_REDIS_INSIGHT_CRT_PATH}                                                                            \
    SERVER_CONFIG_PATH=${COMPOSE_COMMON_REDIS_INSIGHT_OPENSSL_CONFIG_PATH}                                                              \
    INTERMEDIATE_CA_DIR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_DIR_PATH}                                                                 \
    INTERMEDIATE_CA_CONFIG_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                                   \

_c_generate_bind_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                                         \
    SERVER_KEY_PATH=${COMPOSE_COMMON_BIND_KEY_PATH}                                                                                     \
    SERVER_CSR_PATH=${COMPOSE_COMMON_BIND_CSR_PATH}                                                                                     \
    SERVER_CRT_PATH=${COMPOSE_COMMON_BIND_CRT_PATH}                                                                                     \
    SERVER_CONFIG_PATH=${COMPOSE_COMMON_BIND_OPENSSL_CONFIG_PATH}                                                                       \
    INTERMEDIATE_CA_DIR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_DIR_PATH}                                                                 \
    INTERMEDIATE_CA_CONFIG_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                                   \

_c_generate_kafka_certificate:
    @source ${GENERATE_KEYTOOL_CERTIFICATE_PATH}                                                                                        \
    CN=kafka                                                                                                                            \
    KEYSTORE_PATH=${COMPOSE_COMMON_KAFKA_KEYSTORE_PATH}                                                                                 \
    KEYSTORE_PASSWORD=${COMPOSE_COMMON_KAFKA_KEYSTORE_PASSWORD}                                                                         \
    TRUSTSTORE_PATH=${COMPOSE_COMMON_KAFKA_TRUSTSTORE_PATH}                                                                             \
    TRUSTSTORE_PASSWORD=${COMPOSE_COMMON_KAFKA_TRUSTSTORE_PASSWORD}                                                                     \
    CSR_PATH=${COMPOSE_COMMON_KAFKA_CSR_PATH}                                                                                           \
    PEM_PATH=${COMPOSE_COMMON_KAFKA_PEM_PATH}                                                                                           \
    KEY_PASSWORD=${COMPOSE_COMMON_KAFKA_KEY_PASSWORD}                                                                                   \
    CA_PEM_PATH=${COMPOSE_COMMON_CA_PEM_PATH}                                                                                           \
    CA_KEY_PATH=${COMPOSE_COMMON_CA_KEY_PATH}                                                                                           \

_c_generate_twt_parser_postgres_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                                         \
    SERVER_KEY_PATH=${COMPOSE_TWT_PARSER_POSTGRES_KEY_PATH}                                                                             \
    SERVER_CSR_PATH=${COMPOSE_TWT_PARSER_POSTGRES_CSR_PATH}                                                                             \
    SERVER_CRT_PATH=${COMPOSE_TWT_PARSER_POSTGRES_CRT_PATH}                                                                             \
    SERVER_CONFIG_PATH=${COMPOSE_TWT_PARSER_POSTGRES_OPENSSL_CONFIG_PATH}                                                               \
    INTERMEDIATE_CA_DIR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_DIR_PATH}                                                                 \
    INTERMEDIATE_CA_CONFIG_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                                   \

_c_generate_twt_parser_mongo_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                                         \
    SERVER_KEY_PATH=${COMPOSE_TWT_PARSER_MONGO_KEY_PATH}                                                                                \
    SERVER_CSR_PATH=${COMPOSE_TWT_PARSER_MONGO_CSR_PATH}                                                                                \
    SERVER_CRT_PATH=${COMPOSE_TWT_PARSER_MONGO_CRT_PATH}                                                                                \
    SERVER_CONFIG_PATH=${COMPOSE_TWT_PARSER_MONGO_OPENSSL_CONFIG_PATH}                                                                  \
    INTERMEDIATE_CA_DIR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_DIR_PATH}                                                                 \
    INTERMEDIATE_CA_CONFIG_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                                   \

_c_generate_twt_parser_redis_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                                         \
    SERVER_KEY_PATH=${COMPOSE_TWT_PARSER_REDIS_KEY_PATH}                                                                                \
    SERVER_CSR_PATH=${COMPOSE_TWT_PARSER_REDIS_CSR_PATH}                                                                                \
    SERVER_CRT_PATH=${COMPOSE_TWT_PARSER_REDIS_CRT_PATH}                                                                                \
    SERVER_CONFIG_PATH=${COMPOSE_TWT_PARSER_REDIS_OPENSSL_CONFIG_PATH}                                                                  \
    INTERMEDIATE_CA_DIR_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_DIR_PATH}                                                                 \
    INTERMEDIATE_CA_CONFIG_PATH=${COMPOSE_COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                                   \

# ------------------------------------------------------- PERMISSIONS -------------------------------------------------------------------

_c_set_root_ca_permissions:
    @sudo chmod a+r ${COMPOSE_COMMON_ROOT_CA_CURRENT_CERTS_PATH}

_c_set_intermediate_ca_permissions:
    @sudo chmod a+r ${COMPOSE_COMMON_INTERMEDIATE_CA_CURRENT_CERTS_PATH}

_c_set_redpanda_permissions:
    @sudo chown 100:101 ${COMPOSE_COMMON_REDPANDA_CURRENT_CERTS_PATH}
    @sudo chown 100:101 ${COMPOSE_COMMON_REDPANDA_CONFIG_PATH}
    @sudo chown 100:101 ${COMPOSE_COMMON_REDPANDA_ENTRYPOINT_PATH}
    @sudo chmod +x ${COMPOSE_COMMON_REDPANDA_ENTRYPOINT_PATH}

_c_set_pgadmin_permissions:
    @sudo chown 5050:5050 ${COMPOSE_COMMON_PGADMIN_CURRENT_CERTS_PATH}
    @sudo chown 5050:5050 ${COMPOSE_COMMON_PGADMIN_CONFIG_PATH}
    @sudo chown 5050:5050 ${COMPOSE_COMMON_PGADMIN_ENTRYPOINT_PATH}
    @sudo chmod +x ${COMPOSE_COMMON_PGADMIN_ENTRYPOINT_PATH}

_c_set_mongo_express_permissions:
    @sudo chown 1000:1000 ${COMPOSE_COMMON_MONGO_EXPRESS_CURRENT_CERTS_PATH}
    @sudo chown 1000:1000 ${COMPOSE_COMMON_MONGO_EXPRESS_CONFIG_PATH}
    @sudo chown 1000:1000 ${COMPOSE_COMMON_MONGO_EXPRESS_ENTRYPOINT_PATH}
    @sudo chmod +x ${COMPOSE_COMMON_MONGO_EXPRESS_ENTRYPOINT_PATH}

_c_set_redis_insight_permissions:
    @sudo chown 1000:1000 ${COMPOSE_COMMON_REDIS_INSIGHT_CURRENT_CERTS_PATH}
    @sudo chown 1000:1000 ${COMPOSE_COMMON_REDIS_INSIGHT_CONFIG_PATH}
    @sudo chown 1000:1000 ${COMPOSE_COMMON_REDIS_INSIGHT_ENTRYPOINT_PATH}
    @sudo chmod +x ${COMPOSE_COMMON_REDIS_INSIGHT_ENTRYPOINT_PATH}

_c_set_bind_permissions:
    @sudo chown 100:101 ${COMPOSE_COMMON_BIND_CURRENT_CERTS_PATH}
    @sudo chown 100:101 ${COMPOSE_COMMON_BIND_CONFIG_PATH}
    @sudo chown 100:101 ${COMPOSE_COMMON_BIND_ENTRYPOINT_PATH}
    @sudo chmod +x ${COMPOSE_COMMON_BIND_ENTRYPOINT_PATH}

_c_set_kafka_permissions:
    @sudo chown 1000:1000 ${COMPOSE_COMMON_KAFKA_CERTS_PATH}
    @sudo chown 1000:1000 ${COMPOSE_COMMON_KAFKA_CONFIG_PATH}
    @sudo chown 1000:1000 ${COMPOSE_COMMON_KAFKA_ENTRYPOINT_PATH}
    @sudo chmod +x ${COMPOSE_COMMON_KAFKA_ENTRYPOINT_PATH}

_c_set_twt_parser_postgres_permissions:
    @sudo chown 70:70 ${COMPOSE_TWT_PARSER_POSTGRES_CURRENT_CERTS_PATH}
    @sudo chown 70:70 ${COMPOSE_TWT_PARSER_POSTGRES_CONFIG_PATH}
    @sudo chown 70:70 ${COMPOSE_TWT_PARSER_POSTGRES_ENTRYPOINT_PATH}
    @sudo chmod +x ${COMPOSE_TWT_PARSER_POSTGRES_ENTRYPOINT_PATH}

_c_set_twt_parser_mongo_permissions:
    @sudo chown 999:999 ${COMPOSE_TWT_PARSER_MONGO_CURRENT_CERTS_PATH}
    @sudo chown 999:999 ${COMPOSE_TWT_PARSER_MONGO_CONFIG_PATH}
    @sudo chown 999:999 ${COMPOSE_TWT_PARSER_MONGO_ENTRYPOINT_PATH}
    @sudo chmod +x ${COMPOSE_TWT_PARSER_MONGO_ENTRYPOINT_PATH}

_c_set_twt_parser_redis_permissions:
    @sudo chown 999:1000 ${COMPOSE_TWT_PARSER_REDIS_CURRENT_CERTS_PATH}
    @sudo chown 999:1000 ${COMPOSE_TWT_PARSER_REDIS_CONFIG_PATH}
    @sudo chown 999:1000 ${COMPOSE_TWT_PARSER_REDIS_ENTRYPOINT_PATH}
    @sudo chmod +x ${COMPOSE_TWT_PARSER_REDIS_ENTRYPOINT_PATH}

# ------------------------------------------------------ CONFIGURATION ------------------------------------------------------------------

_c_configure_root_ca:
    @$(MAKE) --no-print-directory _c_generate_root_ca_certificate
    @$(MAKE) --no-print-directory _c_set_root_ca_permissions

_c_configure_intermediate_ca:
    @$(MAKE) --no-print-directory _c_generate_intermediate_ca_certificate
    @$(MAKE) --no-print-directory _c_set_intermediate_ca_permissions

_c_configure_redpanda:
    @$(MAKE) --no-print-directory _c_generate_redpanda_certificate
    @$(MAKE) --no-print-directory _c_set_redpanda_permissions

_c_configure_pgadmin:
    @$(MAKE) --no-print-directory _c_generate_pgadmin_certificate
    @$(MAKE) --no-print-directory _c_set_pgadmin_permissions

_c_configure_mongo_express:
    @$(MAKE) --no-print-directory _c_generate_mongo_express_certificate
    @$(MAKE) --no-print-directory _c_set_mongo_express_permissions

_c_configure_redis_insight:
    @$(MAKE) --no-print-directory _c_generate_redis_insight_certificate
    @$(MAKE) --no-print-directory _c_set_redis_insight_permissions

_c_configure_bind:
    @$(MAKE) --no-print-directory _c_generate_bind_certificate
    @$(MAKE) --no-print-directory _c_set_bind_permissions

_c_configure_kafka:
    @$(MAKE) --no-print-directory _c_generate_kafka_certificate
    @$(MAKE) --no-print-directory _c_set_kafka_permissions

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
    @docker compose --project-name parser-microservices --project-directory . ${COMPOSE_FILE_PATHS} up --build

cstart:
    @docker compose --project-name parser-microservices --project-directory . ${COMPOSE_FILE_PATHS} up

cstartd:
    @docker compose --project-name parser-microservices --project-directory . ${COMPOSE_FILE_PATHS} up --detach

ctop:
    @docker compose --project-name parser-microservices --project-directory . ${COMPOSE_FILE_PATHS} top

cstat:
    @docker compose --project-name parser-microservices --project-directory . ${COMPOSE_FILE_PATHS} stats

cps:
    @docker compose --project-name parser-microservices --project-directory . ${COMPOSE_FILE_PATHS} ps

cls:
    @docker compose --project-name parser-microservices --project-directory . ${COMPOSE_FILE_PATHS} ls

cstop:
    @docker compose --project-name parser-microservices --project-directory . ${COMPOSE_FILE_PATHS} down

cstopv:
    @docker compose --project-name parser-microservices --project-directory . ${COMPOSE_FILE_PATHS} down -v

cclean:
    @sudo rm -f ${COMPOSE_COMMON_CA_CERTS_PATH}
    @sudo rm -f ${COMPOSE_COMMON_REDPANDA_CERTS_PATH}
    @sudo rm -f ${COMPOSE_COMMON_PGADMIN_CERTS_PATH}
    @sudo rm -f ${COMPOSE_COMMON_MONGO_EXPRESS_CERTS_PATH}
    @sudo rm -f ${COMPOSE_COMMON_REDIS_INSIGHT_CERTS_PATH}
    @sudo rm -f ${COMPOSE_COMMON_BIND_CERTS_PATH}
    @sudo rm -f ${COMPOSE_COMMON_KAFKA_CERTS_PATH}
    @sudo rm -f ${COMPOSE_TWT_PARSER_POSTGRES_CERTS_PATH}
    @sudo rm -f ${COMPOSE_TWT_PARSER_MONGO_CERTS_PATH}
    @sudo rm -f ${COMPOSE_TWT_PARSER_REDIS_CERTS_PATH}

cinit:
    @$(MAKE) --no-print-directory _configure_scripts
    @$(MAKE) --no-print-directory _c_configure_root_ca
    @$(MAKE) --no-print-directory _c_configure_intermediate_ca
    @$(MAKE) --no-print-directory _c_configure_redpanda
    @$(MAKE) --no-print-directory _c_configure_pgadmin
    @$(MAKE) --no-print-directory _c_configure_mongo_express
    @$(MAKE) --no-print-directory _c_configure_redis_insight
    @$(MAKE) --no-print-directory _c_configure_bind
    # @$(MAKE) --no-print-directory _c_configure_kafka
    @$(MAKE) --no-print-directory _c_configure_twt_parser_postgres
    @$(MAKE) --no-print-directory _c_configure_twt_parser_mongo
    @$(MAKE) --no-print-directory _c_configure_twt_parser_redis

# ---------------------------------------------------------------------------------------------------------------------------------------

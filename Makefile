# ------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------------ INIT ------------------------------------------------------

-include .env
export

.RECIPEPREFIX := $() $()
SHELL := bash -O extglob

# -------------------------------------------------- SHORTCUTS -----------------------------------------------------

MANIFESTS_PATHS :=                                                                                                 \
    -f ${TWT_PARSER_POSTGRES_PATH}                                                                                 \
    # -f ${COMMON_REDPANDA_PATH}                                                                                     \
    # -f ${COMMON_PGADMIN_PATH}                                                                                      \
    # -f ${COMMON_MONGO_EXPRESS_PATH}                                                                                \
    # -f ${COMMON_REDIS_INSIGHT_PATH}                                                                                \
    # -f ${COMMON_BIND_PATH}                                                                                         \
    # -f ${COMMON_KAFKA_PATH}                                                                                        \
    # -f ${TWT_PARSER_POSTGRES_PATH}                                                                                 \
    # -f ${TWT_PARSER_MONGO_PATH}                                                                                    \
    # -f ${TWT_PARSER_REDIS_PATH}                                                                                    \
    # -f ${TWT_PARSER_PATH}                                                                                          \

# ------------------------------------------------------ ENV -------------------------------------------------------

_copy_root_env:
    @cp .env.example .env

_clean_root_env:
    @rm .env

_copy_env:
    @cp ${COMMON_REDPANDA_ENV_EXAMPLE_PATH}         ${COMMON_REDPANDA_ENV_PATH}
    @cp ${COMMON_PGADMIN_ENV_EXAMPLE_PATH}          ${COMMON_PGADMIN_ENV_PATH}
    @cp ${COMMON_MONGO_EXPRESS_ENV_EXAMPLE_PATH}    ${COMMON_MONGO_EXPRESS_ENV_PATH}
    @cp ${COMMON_REDIS_INSIGHT_ENV_EXAMPLE_PATH}    ${COMMON_REDIS_INSIGHT_ENV_PATH}
    @cp ${COMMON_BIND_ENV_EXAMPLE_PATH}             ${COMMON_BIND_ENV_PATH}
    @cp ${COMMON_KAFKA_ENV_EXAMPLE_PATH}            ${COMMON_KAFKA_ENV_PATH}
    @cp ${TWT_PARSER_POSTGRES_ENV_EXAMPLE_PATH}     ${TWT_PARSER_POSTGRES_ENV_PATH}
    @cp ${TWT_PARSER_MONGO_ENV_EXAMPLE_PATH}        ${TWT_PARSER_MONGO_ENV_PATH}
    @cp ${TWT_PARSER_REDIS_ENV_EXAMPLE_PATH}        ${TWT_PARSER_REDIS_ENV_PATH}
    @cp ${TWT_PARSER_ENV_EXAMPLE_PATH}              ${TWT_PARSER_ENV_PATH}

_clean_env:
    @sudo rm -f ${COMMON_REDPANDA_ENV_PATH}
    @sudo rm -f ${COMMON_PGADMIN_ENV_PATH}
    @sudo rm -f ${COMMON_MONGO_EXPRESS_ENV_PATH}
    @sudo rm -f ${COMMON_REDIS_INSIGHT_ENV_PATH}
    @sudo rm -f ${COMMON_BIND_ENV_PATH}
    @sudo rm -f ${COMMON_KAFKA_ENV_PATH}
    @sudo rm -f ${TWT_PARSER_POSTGRES_ENV_PATH}
    @sudo rm -f ${TWT_PARSER_MONGO_ENV_PATH}
    @sudo rm -f ${TWT_PARSER_REDIS_ENV_PATH}
    @sudo rm -f ${TWT_PARSER_ENV_PATH}

# ------------------------------------------------- CERTIFICATES ---------------------------------------------------

_create_ca_certificate_chain:
    @cat ${COMMON_INTERMEDIATE_CA_CRT_PATH} ${COMMON_ROOT_CA_CRT_PATH} > ${COMMON_CHAIN_CA_PATH}

_generate_root_ca_certificate:
    @source ${GENERATE_ROOT_CA_CERTIFICATE_PATH}                                                                   \
    ROOT_CA_DIR_PATH=${COMMON_ROOT_CA_DIR_PATH}                                                                    \
    ROOT_CA_KEY_PATH=${COMMON_ROOT_CA_KEY_PATH}                                                                    \
    ROOT_CA_CSR_PATH=${COMMON_ROOT_CA_CSR_PATH}                                                                    \
    ROOT_CA_CRT_PATH=${COMMON_ROOT_CA_CRT_PATH}                                                                    \
    ROOT_CA_PEM_PATH=${COMMON_ROOT_CA_PEM_PATH}                                                                    \
    ROOT_CA_CONFIG_PATH=${COMMON_ROOT_CA_OPENSSL_CONFIG_PATH}                                                      \

_generate_intermediate_ca_certificate:
    @source ${GENERATE_INTERMEDIATE_CA_CERTIFICATE_PATH}                                                           \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_KEY_PATH=${COMMON_INTERMEDIATE_CA_KEY_PATH}                                                    \
    INTERMEDIATE_CA_CSR_PATH=${COMMON_INTERMEDIATE_CA_CSR_PATH}                                                    \
    INTERMEDIATE_CA_CRT_PATH=${COMMON_INTERMEDIATE_CA_CRT_PATH}                                                    \
    INTERMEDIATE_CA_PEM_PATH=${COMMON_INTERMEDIATE_CA_PEM_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \
    ROOT_CA_DIR_PATH=${COMMON_ROOT_CA_DIR_PATH}                                                                    \
    ROOT_CA_CONFIG_PATH=${COMMON_ROOT_CA_OPENSSL_CONFIG_PATH}                                                      \

_generate_redpanda_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${COMMON_REDPANDA_KEY_PATH}                                                                    \
    SERVER_CSR_PATH=${COMMON_REDPANDA_CSR_PATH}                                                                    \
    SERVER_CRT_PATH=${COMMON_REDPANDA_CRT_PATH}                                                                    \
    SERVER_PEM_PATH=${COMMON_REDPANDA_PEM_PATH}                                                                    \
    SERVER_CONFIG_PATH=${COMMON_REDPANDA_OPENSSL_CONFIG_PATH}                                                      \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

_generate_pgadmin_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${COMMON_PGADMIN_KEY_PATH}                                                                     \
    SERVER_CSR_PATH=${COMMON_PGADMIN_CSR_PATH}                                                                     \
    SERVER_CRT_PATH=${COMMON_PGADMIN_CRT_PATH}                                                                     \
    SERVER_PEM_PATH=${COMMON_PGADMIN_PEM_PATH}                                                                     \
    SERVER_CONFIG_PATH=${COMMON_PGADMIN_OPENSSL_CONFIG_PATH}                                                       \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

_generate_mongo_express_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${COMMON_MONGO_EXPRESS_KEY_PATH}                                                               \
    SERVER_CSR_PATH=${COMMON_MONGO_EXPRESS_CSR_PATH}                                                               \
    SERVER_CRT_PATH=${COMMON_MONGO_EXPRESS_CRT_PATH}                                                               \
    SERVER_PEM_PATH=${COMMON_MONGO_EXPRESS_PEM_PATH}                                                               \
    SERVER_CONFIG_PATH=${COMMON_MONGO_EXPRESS_OPENSSL_CONFIG_PATH}                                                 \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

_generate_redis_insight_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${COMMON_REDIS_INSIGHT_KEY_PATH}                                                               \
    SERVER_CSR_PATH=${COMMON_REDIS_INSIGHT_CSR_PATH}                                                               \
    SERVER_CRT_PATH=${COMMON_REDIS_INSIGHT_CRT_PATH}                                                               \
    SERVER_PEM_PATH=${COMMON_REDIS_INSIGHT_PEM_PATH}                                                               \
    SERVER_CONFIG_PATH=${COMMON_REDIS_INSIGHT_OPENSSL_CONFIG_PATH}                                                 \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

_generate_bind_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${COMMON_BIND_KEY_PATH}                                                                        \
    SERVER_CSR_PATH=${COMMON_BIND_CSR_PATH}                                                                        \
    SERVER_CRT_PATH=${COMMON_BIND_CRT_PATH}                                                                        \
    SERVER_PEM_PATH=${COMMON_BIND_PEM_PATH}                                                                        \
    SERVER_CONFIG_PATH=${COMMON_BIND_OPENSSL_CONFIG_PATH}                                                          \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

_generate_kafka_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${COMMON_KAFKA_KEY_PATH}                                                                       \
    SERVER_CSR_PATH=${COMMON_KAFKA_CSR_PATH}                                                                       \
    SERVER_CRT_PATH=${COMMON_KAFKA_CRT_PATH}                                                                       \
    SERVER_PEM_PATH=${COMMON_KAFKA_PEM_PATH}                                                                       \
    SERVER_CONFIG_PATH=${COMMON_KAFKA_OPENSSL_CONFIG_PATH}                                                         \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

    @source ${IMPORT_CERTIFICATE_INTO_KEY_TRUST_STORE_PATH}                                                        \
    SERVER_KEY_PATH=${COMMON_KAFKA_KEY_PATH}                                                                       \
    SERVER_CRT_PATH=${COMMON_KAFKA_CRT_PATH}                                                                       \
    SERVER_P12_PATH=${COMMON_KAFKA_P12_PATH}                                                                       \
    CHAIN_CA_PATH=${COMMON_CHAIN_CA_PATH}                                                                          \
    KEYSTORE_PATH=${COMMON_KAFKA_KEYSTORE_PATH}                                                                    \
    TRUSTSTORE_PATH=${COMMON_KAFKA_TRUSTSTORE_PATH}                                                                \
    P12_PASSWORD=${COMMON_KAFKA_P12_PASSWORD}                                                                      \
    KEYSTORE_PASSWORD=${COMMON_KAFKA_KEYSTORE_PASSWORD}                                                            \
    TRUSTSTORE_PASSWORD=${COMMON_KAFKA_TRUSTSTORE_PASSWORD}                                                        \

_generate_twt_parser_postgres_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${TWT_PARSER_POSTGRES_KEY_PATH}                                                                \
    SERVER_CSR_PATH=${TWT_PARSER_POSTGRES_CSR_PATH}                                                                \
    SERVER_CRT_PATH=${TWT_PARSER_POSTGRES_CRT_PATH}                                                                \
    SERVER_PEM_PATH=${TWT_PARSER_POSTGRES_PEM_PATH}                                                                \
    SERVER_CONFIG_PATH=${TWT_PARSER_POSTGRES_OPENSSL_CONFIG_PATH}                                                  \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

_generate_twt_parser_mongo_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${TWT_PARSER_MONGO_KEY_PATH}                                                                   \
    SERVER_CSR_PATH=${TWT_PARSER_MONGO_CSR_PATH}                                                                   \
    SERVER_CRT_PATH=${TWT_PARSER_MONGO_CRT_PATH}                                                                   \
    SERVER_PEM_PATH=${TWT_PARSER_MONGO_PEM_PATH}                                                                   \
    SERVER_CONFIG_PATH=${TWT_PARSER_MONGO_OPENSSL_CONFIG_PATH}                                                     \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

_generate_twt_parser_redis_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${TWT_PARSER_REDIS_KEY_PATH}                                                                   \
    SERVER_CSR_PATH=${TWT_PARSER_REDIS_CSR_PATH}                                                                   \
    SERVER_CRT_PATH=${TWT_PARSER_REDIS_CRT_PATH}                                                                   \
    SERVER_PEM_PATH=${TWT_PARSER_REDIS_PEM_PATH}                                                                   \
    SERVER_CONFIG_PATH=${TWT_PARSER_REDIS_OPENSSL_CONFIG_PATH}                                                     \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

_generate_twt_parser_certificate:
    @source ${GENERATE_SERVER_CERTIFICATE_PATH}                                                                    \
    SERVER_KEY_PATH=${TWT_PARSER_KEY_PATH}                                                                         \
    SERVER_CSR_PATH=${TWT_PARSER_CSR_PATH}                                                                         \
    SERVER_CRT_PATH=${TWT_PARSER_CRT_PATH}                                                                         \
    SERVER_PEM_PATH=${TWT_PARSER_PEM_PATH}                                                                         \
    SERVER_CONFIG_PATH=${TWT_PARSER_OPENSSL_CONFIG_PATH}                                                           \
    INTERMEDIATE_CA_DIR_PATH=${COMMON_INTERMEDIATE_CA_DIR_PATH}                                                    \
    INTERMEDIATE_CA_CONFIG_PATH=${COMMON_INTERMEDIATE_CA_OPENSSL_CONFIG_PATH}                                      \

_clean_certs:
    @sudo rm -f ${COMMON_CHAIN_CA_PATH}
    @sudo rm -f ${COMMON_ROOT_CA_CURRENT_CERTS_PATH}
    @sudo rm -f ${COMMON_ROOT_CA_DATABASE_DATA_PATH}
    @sudo rm -f ${COMMON_ROOT_CA_ISSUED_DATA_PATH}
    @sudo rm -f ${COMMON_INTERMEDIATE_CA_CURRENT_CERTS_PATH}
    @sudo rm -f ${COMMON_INTERMEDIATE_CA_DATABASE_DATA_PATH}
    @sudo rm -f ${COMMON_INTERMEDIATE_CA_ISSUED_DATA_PATH}
    @sudo rm -f ${COMMON_REDPANDA_CURRENT_CERTS_PATH}
    @sudo rm -f ${COMMON_PGADMIN_CURRENT_CERTS_PATH}
    @sudo rm -f ${COMMON_MONGO_EXPRESS_CURRENT_CERTS_PATH}
    @sudo rm -f ${COMMON_REDIS_INSIGHT_CURRENT_CERTS_PATH}
    @sudo rm -f ${COMMON_BIND_CURRENT_CERTS_PATH}
    @sudo rm -f ${COMMON_KAFKA_CURRENT_CERTS_PATH}
    @sudo rm -f ${TWT_PARSER_POSTGRES_CURRENT_CERTS_PATH}
    @sudo rm -f ${TWT_PARSER_MONGO_CURRENT_CERTS_PATH}
    @sudo rm -f ${TWT_PARSER_REDIS_CURRENT_CERTS_PATH}
    @sudo rm -f ${TWT_PARSER_CURRENT_CERTS_PATH}

# ------------------------------------------------- PERMISSIONS ----------------------------------------------------

_set_common_scripts_permissions:
    @sudo chmod a+x ${COMMON_SCRIPTS_PATH}

_set_cert_scripts_permissions:
    @sudo chmod a+x ${CERTIFICATE_SCRIPTS_PATH}

_set_ca_certificate_chain_permissions:
    @sudo chmod a+r ${COMMON_CHAIN_CA_PATH}

_set_root_ca_permissions:
    @sudo chmod a+r ${COMMON_ROOT_CA_CURRENT_CERTS_PATH}

_set_intermediate_ca_permissions:
    @sudo chmod a+r ${COMMON_INTERMEDIATE_CA_CURRENT_CERTS_PATH}

_set_redpanda_permissions:
    @sudo chown 100:101 ${COMMON_REDPANDA_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${COMMON_REDPANDA_ENTRYPOINT_PATH}

_set_pgadmin_permissions:
    @sudo chown 5050:5050 ${COMMON_PGADMIN_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${COMMON_PGADMIN_ENTRYPOINT_PATH}

_set_mongo_express_permissions:
    @sudo chown 1000:1000 ${COMMON_MONGO_EXPRESS_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${COMMON_MONGO_EXPRESS_ENTRYPOINT_PATH}

_set_redis_insight_permissions:
    @sudo chown 1000:1000 ${COMMON_REDIS_INSIGHT_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${COMMON_REDIS_INSIGHT_ENTRYPOINT_PATH}

_set_bind_permissions:
    @sudo chown 100:101 ${COMMON_BIND_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${COMMON_BIND_ENTRYPOINT_PATH}

_set_kafka_permissions:
    @sudo chown 1000:1000 ${COMMON_KAFKA_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${COMMON_KAFKA_ENTRYPOINT_PATH}

_set_twt_parser_postgres_permissions:
    @sudo chown 70:70 ${TWT_PARSER_POSTGRES_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${TWT_PARSER_POSTGRES_ENTRYPOINT_PATH}

_set_twt_parser_mongo_permissions:
    @sudo chown 999:999 ${TWT_PARSER_MONGO_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${TWT_PARSER_MONGO_ENTRYPOINT_PATH}

_set_twt_parser_redis_permissions:
    @sudo chown 999:1000 ${TWT_PARSER_REDIS_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${TWT_PARSER_REDIS_ENTRYPOINT_PATH}

_set_twt_parser_permissions:
    @sudo chown 1001:1001 ${TWT_PARSER_CURRENT_CERTS_PATH}
    @sudo chmod a+x ${TWT_PARSER_ENTRYPOINT_PATH}

# ------------------------------------------------ CONFIGURATION ---------------------------------------------------

_configure_scripts:
    @$(MAKE) --no-print-directory _set_common_scripts_permissions
    @$(MAKE) --no-print-directory _set_cert_scripts_permissions

_configure_ca_certificate_chain:
    @$(MAKE) --no-print-directory _create_ca_certificate_chain
    @$(MAKE) --no-print-directory _set_ca_certificate_chain_permissions

_configure_root_ca:
    @$(MAKE) --no-print-directory _generate_root_ca_certificate
    @$(MAKE) --no-print-directory _set_root_ca_permissions

_configure_intermediate_ca:
    @$(MAKE) --no-print-directory _generate_intermediate_ca_certificate
    @$(MAKE) --no-print-directory _set_intermediate_ca_permissions

_configure_redpanda:
    @$(MAKE) --no-print-directory _generate_redpanda_certificate
    @$(MAKE) --no-print-directory _set_redpanda_permissions

_configure_pgadmin:
    @$(MAKE) --no-print-directory _generate_pgadmin_certificate
    @$(MAKE) --no-print-directory _set_pgadmin_permissions

_configure_mongo_express:
    @$(MAKE) --no-print-directory _generate_mongo_express_certificate
    @$(MAKE) --no-print-directory _set_mongo_express_permissions

_configure_redis_insight:
    @$(MAKE) --no-print-directory _generate_redis_insight_certificate
    @$(MAKE) --no-print-directory _set_redis_insight_permissions

_configure_bind:
    @$(MAKE) --no-print-directory _generate_bind_certificate
    @$(MAKE) --no-print-directory _set_bind_permissions

_configure_kafka:
    @$(MAKE) --no-print-directory _generate_kafka_certificate
    @$(MAKE) --no-print-directory _set_kafka_permissions

_configure_twt_parser_postgres:
    @$(MAKE) --no-print-directory _generate_twt_parser_postgres_certificate
    @$(MAKE) --no-print-directory _set_twt_parser_postgres_permissions

_configure_twt_parser_mongo:
    @$(MAKE) --no-print-directory _generate_twt_parser_mongo_certificate
    @$(MAKE) --no-print-directory _set_twt_parser_mongo_permissions

_configure_twt_parser_redis:
    @$(MAKE) --no-print-directory _generate_twt_parser_redis_certificate
    @$(MAKE) --no-print-directory _set_twt_parser_redis_permissions

_configure_twt_parser:
    @$(MAKE) --no-print-directory _generate_twt_parser_certificate
    @$(MAKE) --no-print-directory _set_twt_parser_permissions

# --------------------------------------------------- COMMANDS -----------------------------------------------------

build:
    @docker compose --project-name parser-microservices --project-directory . ${MANIFESTS_PATHS} up --build

start:
    @docker compose --project-name parser-microservices --project-directory . ${MANIFESTS_PATHS} up

startd:
    @docker compose --project-name parser-microservices --project-directory . ${MANIFESTS_PATHS} up --detach

top:
    @docker compose --project-name parser-microservices --project-directory . ${MANIFESTS_PATHS} top

stat:
    @docker compose --project-name parser-microservices --project-directory . ${MANIFESTS_PATHS} stats

ps:
    @docker compose --project-name parser-microservices --project-directory . ${MANIFESTS_PATHS} ps

ls:
    @docker compose --project-name parser-microservices --project-directory . ${MANIFESTS_PATHS} ls

stop:
    @docker compose --project-name parser-microservices --project-directory . ${MANIFESTS_PATHS} down

stopv:
    @docker compose --project-name parser-microservices --project-directory . ${MANIFESTS_PATHS} down -v

check_key:
    @openssl pkey -in $(path) -noout -text

check_csr:
    @openssl req -in $(path) -noout -text

check_crt:
    @openssl x509 -in $(path) -noout -text

verify_crt:
    @openssl verify -verbose -show_chain $(path)

clean:
    @$(MAKE) --no-print-directory _clean_root_env
    @$(MAKE) --no-print-directory _clean_env
    @$(MAKE) --no-print-directory _clean_certs

init:
    @$(MAKE) --no-print-directory _copy_root_env
    @$(MAKE) --no-print-directory _copy_env
    @$(MAKE) --no-print-directory _configure_scripts
    @$(MAKE) --no-print-directory _configure_root_ca
    @$(MAKE) --no-print-directory _configure_intermediate_ca
    @$(MAKE) --no-print-directory _configure_ca_certificate_chain
    @$(MAKE) --no-print-directory _configure_redpanda
    @$(MAKE) --no-print-directory _configure_pgadmin
    @$(MAKE) --no-print-directory _configure_mongo_express
    @$(MAKE) --no-print-directory _configure_redis_insight
    @$(MAKE) --no-print-directory _configure_bind
    @$(MAKE) --no-print-directory _configure_kafka
    @$(MAKE) --no-print-directory _configure_twt_parser_postgres
    @$(MAKE) --no-print-directory _configure_twt_parser_mongo
    @$(MAKE) --no-print-directory _configure_twt_parser_redis
    @$(MAKE) --no-print-directory _configure_twt_parser

# ------------------------------------------------------------------------------------------------------------------

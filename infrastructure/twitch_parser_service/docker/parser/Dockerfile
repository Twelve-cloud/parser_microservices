# ---------------------------------------------------------------------------
# Python-base stage sets up all shared env vars
FROM python:3.10-alpine3.20 AS python-base

# Metadata (author email)
LABEL author.email="kana.suzucki@gmail.com"

# Metadata (author name)
LABEL author.name="Twelve"

# Important environment variables
ENV                                                                         \
    # Force stdout and stderr streams to be unbuffered
    PYTHONUNBUFFERED=1                                                      \
    # Prevents python from creating .pyc files
    PYTHONDONTWRITEBYTECODE=1                                               \
    # Disable pip cache
    PIP_NO_CACHE_DIR=0                                                      \
    # Disable periodically checking PyPI for a new version of pip
    PIP_DISABLE_PIP_VERSION_CHECK=1                                         \
    # Set the default socket timeout
    PIP_DEFAULT_TIMEOUT=100                                                 \
    # Poetry version
    POETRY_VERSION=1.8.0                                                    \
    # Make poetry create the virtual environment in the project's root
    POETRY_VIRTUALENVS_IN_PROJECT=1                                         \
    # Root of the project
    ROOT_DIR="/code"                                                        \
    # Make poetry to be installed into this location
    POETRY_HOME="/code/poetry"                                              \
    # This is where requirements will live
    PYSETUP_PATH="/code/project"                                            \
    # This is where venv will live
    VENV_PATH="/code/project/.venv"

# Prepend poetry and venv to path
ENV                                                                         \
    # Prepend poetry and venv to path
    # This allows to use poetry without specifying full path
    # This allows to use python from venv without using poetry shell
    # This is so because python will be used as $VENV_PATH/bin/python
    PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# ---------------------------------------------------------------------------
# Builder-base stage installs all necessary core deps
FROM python-base AS builder-base

# Install core deps
RUN                                                                         \
    # Update apk
    apk update &&                                                           \
    # Install core deps
    apk add                                                                 \
    # Install bash shell (better scripting support than default /bin/sh)
    bash                                                                    \
    # Install envsubst to create config via template
    envsubst                                                                \
    # Install curl for downloading files and making HTTP requests
    curl                                                                    \
    # Install C compiler for compiling Python extensions
    gcc                                                                     \
    # Install C++ compiler for certain Python packages with C++ code
    g++                                                                     \
    # Install musl-dev (standard C library headers) for Python C extensions
    musl-dev                                                                \
    # Install PostgreSQL development libraries (for psycopg2, asyncpg, ...)
    postgresql-dev                                                          \
    # Install Python3 development headers (for building Python modules)
    python3-dev

# Override default shell from sh to bash
SHELL ["/bin/bash", "-c"]

# ---------------------------------------------------------------------------
# Poetry-base stage installs poetry, creates venv and installs project deps
FROM python-base AS poetry-base

# Install poetry
RUN                                                                         \
    # Install curl to download poetry
    apk add curl &&                                                         \
    # Install poetry with respect $POETRY_VERSION & $POETRY_HOME
    curl -sSL https://install.python-poetry.org | python3

# Set working directory
WORKDIR $PYSETUP_PATH

# Copy project requirement files here to ensure they will be cached
COPY pyproject.toml poetry.lock ./

# Install deps ($POETRY_VIRTUALENVS_IN_PROJECT used internally)
RUN poetry install --no-ansi --no-interaction --only main

# ---------------------------------------------------------------------------
# Development stage is used during development / testing
FROM builder-base AS development

# Copy poetry to development stage
COPY --from=poetry-base $POETRY_HOME $POETRY_HOME

# Copy venv to development stage
COPY --from=poetry-base $PYSETUP_PATH $PYSETUP_PATH

# Set working directory
WORKDIR $PYSETUP_PATH

# Install dev deps (other deps are already installed)
RUN poetry install --no-ansi --no-interaction

# Container will listen this port
EXPOSE 8000

# ---------------------------------------------------------------------------
# Production stage is used for runtime
FROM builder-base AS production

# Copy venv to production stage
COPY --from=poetry-base $PYSETUP_PATH $PYSETUP_PATH

# Set working directory
WORKDIR $PYSETUP_PATH

# Create twitch-parser group and user
RUN                                                                         \
    # Create group named "twitch-parser"
    addgroup -S -g 1001 twitch-parser &&                                    \
    # Create user named "twitch-parser" and add it to group "twitch-parser"
    adduser -S -u 1001 -G twitch-parser twitch-parser &&                    \
    # Change the ownership of the workdir to the user "twitch-parser"
    chown -R twitch-parser:twitch-parser $ROOT_DIR

# Switch to the non-root user "twitch-parser"
USER twitch-parser

# Copy source code and entrypoint of the project
COPY ./src ./src

# Container will listen this port
EXPOSE 8000

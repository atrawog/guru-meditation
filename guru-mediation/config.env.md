# Configuration File Usage in Project Scripts

This document outlines how environment variables from the `config.env` file are utilized across various configuration files and shell scripts within the project.

## Configuring Environment Variables

The `config.env` file contains essential environment variables that are used throughout the project, primarily by build and run commands in the Justfile. The following is a breakdown of each variable:

- **BASE_IMAGE**: Specifies the base image for Docker container builds.
- **BASE_VERSION**: Defines the version of the base image specified by `BASE_IMAGE`.
- **ARCH_BASE, ARCH_AI, ARCH_EXTRA, ARCH_TESTING**: Used to specify different architectural configurations for the Docker image.
- **USER_NAME, USER_UID, USER_GID**: Define the user and its UID and GID within the Docker container.
- **PIXI_VERSION**: Specifies the version of PIXI to be used.
- **DOCKER_USERNAME, DOCKER_IMAGE, CONTAINERFILE**: Variables related to Docker image naming and the Dockerfile location.
- **HOSTNAME**: Sets the hostname for the Docker container.

## Usage in Configuration Files

The `config.env` file is sourced at the beginning of each task defined in the Justfile, specifically within the `build` and `shell` tasks:

```justfile
# justfile

# Load environment variables from config.env
set dotenv-load := true
set dotenv-filename := "config/config.env"
set dotenv-required := true
set export := true

# Define TIMESTAMP variable using backticks
TIMESTAMP := `date '+%Y%m%d.%H%M'`

# Build container image
build:
    # Load environment variables
    set -a; source config/config.env; set +a; \
    # Build Docker image with specified build arguments
    docker build \
        --build-arg BASE_IMAGE="$BASE_IMAGE" \
        --build-arg BASE_VERSION="$BASE_VERSION" \
        --build-arg ARCH_BASE="$ARCH_BASE" \
        --build-arg ARCH_AI="$ARCH_AI" \
        --build-arg ARCH_EXTRA="$ARCH_EXTRA" \
        --build-arg ARCH_TESTING="$ARCH_TESTING" \
        --build-arg USER_NAME=$USER_NAME \
        --build-arg USER_UID=$USER_UID \
        --build-arg USER_GID=$USER_GID \
        --build-arg PIXI_VERSION=$PIXI_VERSION \
        -f $CONTAINERFILE \
        -t $DOCKER_USERNAME/$DOCKER_IMAGE:latest \
        -t $DOCKER_USERNAME/$DOCKER_IMAGE:$TIMESTAMP .
    # Update .devcontainer configuration
    echo  "FROM ${DOCKER_USERNAME}/${DOCKER_IMAGE}:latest" > .devcontainer/${CONTAINERFILE}

# Run a shell in the container
shell:
    # Load environment variables
    set -a; source config/config.env; set +a; \
    # Run Docker container with specified options
    docker run \
        --hostname ${HOSTNAME} \
```
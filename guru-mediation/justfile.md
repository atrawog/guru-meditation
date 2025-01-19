# Justfile Documentation

## Overview

This `justfile` defines a set of tasks using [Just](https://github.com/casey/just), a modern build system that can be run on any machine with just a POSIX shell and a Rust toolchain installed. It is designed to automate the building, running, and configuration of Docker containers based on specified parameters.

## Environment Variables Configuration

The `justfile` includes settings for loading environment variables from a `.env` file named `config/config.env`. This can be configured using the following options:
- **dotenv-load**: Set to `true` to enable dotenv loading.
- **dotenv-filename**: Specifies the filename of the .env file, set here as "config/config.env".
- **dotenv-required**: Ensures that the specified .env file is present and required for task execution. This is set to `true`.
- **export**: When set to `true`, exports environment variables from the .env file.

## Timestamp Variable

The script defines a variable `TIMESTAMP` which captures the current date in the format `YYYYMMDD.HHMM`:
```justfile
# Define TIMESTAMP variable using backticks
TIMESTAMP := `date '+%Y%m%d.%H%M'`
```

## Build Task

The `build` task is responsible for building a Docker image with specified build arguments:
- It sources the environment variables from `config/config.env`.
- Uses Docker commands to build an image, tagging it with both `latest` and a timestamped version.
```justfile
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
```

### Arguments in `docker build` Command:
- **BASE_IMAGE**: Base Docker image for the build.
- **BASE_VERSION**: Version of the base image.
- **ARCH_BASE**, **ARCH_AI**, **ARCH_EXTRA**, **ARCH_TESTING**: Specific architecture flags or arguments.
- **USER_NAME, USER_UID, USER_GID**: User and group identifiers for Docker container user setup.
- **PIXI_VERSION**: Version of PIXI to use in the build.
- **CONTAINERFILE**: Path to the Dockerfile being used for this build.
- **DOCKER_USERNAME**: Username under which the Docker image is registered.
- **DOCKER_IMAGE**: Name of the Docker image being built.

## Shell Task

The `shell` task runs a shell inside a Docker container:
- It also sources environment variables from `config/config.env`.
- Runs Docker container with specified options, including hostname configuration.
```justfile
# Run a shell in the container
shell:
    # Load environment variables
    set -a; source config/config.env; set +a; \
    # Run Docker container with specified options
    docker run \
        --hostname ${HOSTNAME} \
```

## Conclusion

This `justfile` provides a structured way to automate the build and execution of Docker containers, leveraging environment variables and timestamps for reproducibility and versioning. For more detailed information on Just or its usage, refer to the [official documentation](https://github.com/casey/just).
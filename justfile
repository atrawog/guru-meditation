# justfile

# Load environment variables from config.env
set dotenv-load := true
set dotenv-filename := "config/container.env"
set dotenv-required := true
set export := true

# Define TIMESTAMP variable using backticks
TIMESTAMP := `date '+%Y%m%d.%H%M'`

# Build container image
build:
    # Load environment variables
    set -a; source config/container.env; set +a; \
    # Build Docker image with specified build arguments
    docker build \
        --build-arg BASE_IMAGE="$BASE_IMAGE" \
        --build-arg BASE_VERSION="$BASE_VERSION" \
        --build-arg ARCH_BASE="$ARCH_BASE" \
        --build-arg ARCH_AI="$ARCH_AI" \
        --build-arg ARCH_EXTRA="$ARCH_EXTRA" \
        --build-arg ARCH_YAY="$ARCH_YAY" \
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
    set -a; source config/container.env; set +a; \
    # Run Docker container with specified options
    docker run \
        --hostname ${HOSTNAME} \
        --env SSH_AUTH_SOCK=${DEVC_SSH_AUTH_SOCK} \
        --mount type=bind,source="${PWD}",target=/workspace \
        --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
        --mount type=bind,source=/run/user/1000/bus,target=/run/user/1000/bus \
        --mount type=bind,source=${SSH_AUTH_SOCK},target=${DEVC_SSH_AUTH_SOCK} \
        --workdir /workspace \
        --rm \
        --name guru-meditation-pixi \
        -it $DOCKER_USERNAME/$DOCKER_IMAGE:latest

# Clean build and Jupyter directories
clean:
    rm -rf _build/*
    rm -rf _jupyter/*
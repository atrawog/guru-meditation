# justfile

set dotenv-load := true
set dotenv-filename := "container.env"
set dotenv-required := true
set export := true

# Define TIMESTAMP variable using backticks
TIMESTAMP := `date '+%Y%m%d.%H%M'`

# Build container image
build:
    # Load environment variables
    set -a; source ./container.env; set +a; \
    # Build Docker image with specified build arguments
    docker buildx build \
        --build-arg BASE_IMAGE="$BASE_IMAGE" \
        --build-arg BASE_VERSION="$BASE_VERSION" \
        --build-arg ARCH_BASE="$ARCH_BASE" \
        --build-arg ARCH_CUDA="$ARCH_CUDA" \
        --build-arg ARCH_CUDNN="$ARCH_CUDNN" \
        --build-arg ARCH_NVIDIA="$ARCH_NVIDIA" \
        --build-arg ARCH_OLLAMA="$ARCH_OLLAMA" \
        --build-arg ARCH_DEV="$ARCH_DEV" \
        --build-arg ARCH_YAY="$ARCH_YAY" \
        --build-arg USER_NAME=$USER_NAME \
        --build-arg USER_UID=$USER_UID \
        --build-arg USER_GID=$USER_GID \
        --build-arg PIXI_VERSION=$PIXI_VERSION \
        --target devel \
        -f $CONTAINERFILE \
        -t $DOCKER_USERNAME/${DOCKER_IMAGE}-devel:$TIMESTAMP \
        -t $DOCKER_USERNAME/${DOCKER_IMAGE}-devel:latest \
        -t ghcr.io/$DOCKER_USERNAME/${DOCKER_IMAGE}-devel:$TIMESTAMP \
        -t ghcr.io/$DOCKER_USERNAME/${DOCKER_IMAGE}-devel:latest .\
    
    docker buildx build \
        --build-arg BASE_IMAGE="$BASE_IMAGE" \
        --build-arg BASE_VERSION="$BASE_VERSION" \
        --build-arg ARCH_BASE="$ARCH_BASE" \
        --build-arg ARCH_CUDA="$ARCH_CUDA" \
        --build-arg ARCH_CUDNN="$ARCH_CUDNN" \
        --build-arg ARCH_NVIDIA="$ARCH_NVIDIA" \
        --build-arg ARCH_OLLAMA="$ARCH_OLLAMA" \
        --build-arg ARCH_DEV="$ARCH_DEV" \
        --build-arg ARCH_YAY="$ARCH_YAY" \
        --build-arg USER_NAME=$USER_NAME \
        --build-arg USER_UID=$USER_UID \
        --build-arg USER_GID=$USER_GID \
        --build-arg PIXI_VERSION=$PIXI_VERSION \
        -f $CONTAINERFILE \
        -t $DOCKER_USERNAME/${DOCKER_IMAGE}:$TIMESTAMP \
        -t $DOCKER_USERNAME/${DOCKER_IMAGE}:latest \
        -t ghcr.io/$DOCKER_USERNAME/${DOCKER_IMAGE}:$TIMESTAMP \
        -t ghcr.io/$DOCKER_USERNAME/${DOCKER_IMAGE}:latest .

    echo  "FROM ${DOCKER_USERNAME}/${DOCKER_IMAGE}-devel:latest" > .devcontainer/${CONTAINERFILE}

# Run a shell in the container
run:
    docker run \
        --hostname ${HOSTNAME} \
        --env-file ./secrets.env \
        --env-file ./config.env \
        --env-file ./config-prod.env \
        --mount type=bind,source="${PWD}",target=/workspace \
        --workdir /workspace \
        --rm \
        --name guru-meditation-devel \
        -p 3000:3000 -p 8010:8010 \
        -it $DOCKER_USERNAME/$DOCKER_IMAGE:latest

history:
    docker history $DOCKER_USERNAME/$DOCKER_IMAGE:latest

# Push container image to GitHub Container Registry
push:
    set -a; source ./container.env; \
    source ./secrets.env; set +a; \
    mkdir -p .docker-tmp && \
    echo "$GHCR_TOKEN" | docker --config .docker-tmp login ghcr.io -u $DOCKER_USERNAME --password-stdin && \
    docker --config .docker-tmp push ghcr.io/$DOCKER_USERNAME/$DOCKER_IMAGE-devel:latest && \
    docker --config .docker-tmp push ghcr.io/$DOCKER_USERNAME/$DOCKER_IMAGE:latest && \
    docker --config .docker-tmp logout ghcr.io

# Clean build and Jupyter directories
clean:
    rm -rf _build/*
    rm -rf _jupyter/*



#!/bin/bash
# set -euxo pipefail
# set -x

# Load environment variables from config.env file
set -a
if [[ -f /workspace/config/config.env ]]; then
  source /workspace/config/config.env
fi
set +a

USER_NAME=${USER_NAME:-atrawog}
LOCAL_UID=${LOCAL_UID:-1000}
LOCAL_GID=${LOCAL_GID:-1000}
LOCAL_DOCKER_GID=${LOCAL_DOCKER_GID:-957}

# Update UID/GID if necessary
if [ $(id -u $USER_NAME) -ne $LOCAL_UID ] || [ $(id -g $USER_NAME) -ne $LOCAL_GID ]; then
    echo "Updating $USER_NAME's UID to $LOCAL_UID and GID to $LOCAL_GID"
    
    # Modify group ID
    sudo groupmod -g $LOCAL_GID $USER_NAME
    
    # Modify user ID
    sudo usermod -u $LOCAL_UID -g $LOCAL_GID $USER_NAME
    
    # Fix ownership of home directory and workspace folder
    sudo chown -R $LOCAL_UID:$LOCAL_GID /home/$USER_NAME
fi

# Ensure docker group exists, then change its GID if needed
if ! getent group docker > /dev/null; then
    echo "Docker group does not exist. Creating it."
    sudo groupadd -g $LOCAL_DOCKER_GID docker
else
    CURRENT_DOCKER_GID=$(getent group docker | cut -d: -f3)
    if [ $CURRENT_DOCKER_GID -ne $LOCAL_DOCKER_GID ]; then
        echo "Changing docker group GID from $CURRENT_DOCKER_GID to $LOCAL_DOCKER_GID"
        sudo groupmod -g $LOCAL_DOCKER_GID docker
    fi
fi

# Set permissions on /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock

# Add user to docker group
# sudo usermod -aG docker $USER_NAME

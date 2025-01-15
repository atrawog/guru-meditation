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

# Set the password for the user
if [ -n "$PASSWORD" ]; then
    echo "Setting password for $USER_NAME"
    echo "$USER_NAME:$PASSWORD" | sudo chpasswd -e
fi

if [ -n "$GIT_USERNAME" ]; then
  echo "Setting git username to $GIT_USERNAME"
  git config --global user.name "$GIT_USERNAME"
fi

if [ -n "$GIT_EMAIL" ]; then
  echo "Setting git email to $GIT_EMAIL"
  git config --global user.email "$GIT_EMAIL"
fi
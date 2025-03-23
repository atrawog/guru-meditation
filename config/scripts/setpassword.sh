#!/bin/bash
# set -euxo pipefail
# set -x

# Load environment variables from .env file
set -a
if [[ -f /workspace/config.env ]]; then
  source /workspace/config.env
fi
if [[ -f /workspace/secrets.env ]]; then
  source /workspace/secrets.env
fi
set +a

USER_NAME=${USER_NAME:-gm}

# Set the password for the user
if [ -n "$USER_PASSWORD" ]; then
    echo "Setting password for $USER_NAME"
    echo "$USER_NAME:$USER_PASSWORD" | sudo chpasswd -e
fi

if [ -n "$GIT_USERNAME" ]; then
  echo "Setting git username to $GIT_USERNAME"
  git config --global user.name "$GIT_USERNAME"
fi

if [ -n "$GIT_EMAIL" ]; then
  echo "Setting git email to $GIT_EMAIL"
  git config --global user.email "$GIT_EMAIL"
fi
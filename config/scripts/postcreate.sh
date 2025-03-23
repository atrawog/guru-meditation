#!/bin/bash
# set -euxo pipefail
# set -x

# Set Password
/usr/local/bin/setpassword.sh

cd /workspace
mkdir -p /workspace/.jupyter

/usr/local/bin/setpassword.sh
echo "Starting supervisord"
sudo /usr/sbin/supervisord -c /etc/supervisord.conf > /dev/null 2>&1 &

socket_path="/run/supervisor.sock"
echo "Checking for supervisor socket at ${socket_path}..."
    while [ ! -S "${socket_path}" ]; do
        echo "Supervisor socket not found. Retrying in 1 second..."
        sleep 1
    done
    echo "Supervisor socket is available."

if [ "${JUPYTERHUB_ENABLE}" = "true" ]; then
    echo "JUPYTERHUB_ENABLE is set. Proceeding to start jupyterhub."

    # Start jupyterhub using supervisorctl
    supervisorctl start jupyterhub

    # Loop to check the status of jupyterhub
    while true; do
        # Get the status of jupyterhub
        status=$(supervisorctl status jupyterhub | awk '{print $2}')

        # Check if the status is RUNNING
        if [ "$status" == "RUNNING" ]; then
            echo "jupyterhub is running."
            break
        else
            echo "Waiting for jupyterhub to start..."
            sleep 1
        fi
    done
else
    echo "JUPYTERHUB_ENABLE is not set. Skipping jupyterhub startup."
fi


if [ "${OLLAMA_ENABLE}" = "true" ]; then
    echo "OLLAMA_ENABLE is set. Proceeding to start ollama."

    # Start ollama using supervisorctl
    supervisorctl start ollama

    # Loop to check the status of ollama
    while true; do
        # Get the status of ollama
        status=$(supervisorctl status ollama | awk '{print $2}')

        # Check if the status is RUNNING
        if [ "$status" == "RUNNING" ]; then
            echo "ollama is running."
            break
        else
            echo "Waiting for ollama to start..."
            sleep 1
        fi
    done
else
    echo "OLLAMA_ENABLE is not set. Skipping ollama startup."
fi


if [ "${OPENWEBUI_ENABLE}" = "true" ]; then
    echo "OPENWEBUI_ENABLE is set. Proceeding to start ollama."

    # Start openwebui using supervisorctl
    supervisorctl start openwebui

    # Loop to check the status of openwebui
    while true; do
        # Get the status of openwebui
        status=$(supervisorctl status openwebui | awk '{print $2}')

        # Check if the status is RUNNING
        if [ "$status" == "RUNNING" ]; then
            echo "openwebui is running."
            break
        else
            echo "Waiting for openwebui to start..."
            sleep 1
        fi
    done
else
    echo "OPENWEBUI_ENABLE is not set. Skipping openwebui startup."
fi
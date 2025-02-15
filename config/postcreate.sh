#!/bin/bash
# set -euxo pipefail
# set -x

cd /workspace
mkdir -p /workspace/.jupyter

/usr/local/bin/fixpermission.sh
/usr/local/bin/setpassword.sh
echo "Starting supervisord"
sudo /usr/sbin/supervisord -c /etc/supervisord.conf > /dev/null 2>&1 &
# sudo /usr/sbin/supervisord -c /etc/supervisord.conf &

socket_path="/run/supervisor.sock"
echo "Checking for supervisor socket at ${socket_path}..."
    while [ ! -S "${socket_path}" ]; do
        echo "Supervisor socket not found. Retrying in 1 second..."
        sleep 1
    done
    echo "Supervisor socket is available."


if [ "${JUPYTERBOOK}" = "true" ]; then
    echo "JUPYTERBOOK is set. Proceeding to start jupyterbook."

    # Start jupyterbook using supervisorctl
    supervisorctl start jupyterbook

    # Loop to check the status of jupyterbook
    while true; do
        # Get the status of jupyterbook
        status=$(supervisorctl status jupyterbook | awk '{print $2}')

        # Check if the status is RUNNING
        if [ "$status" == "RUNNING" ]; then
            echo "jupyterbook is running."
            break
        else
            echo "Waiting for jupyterbook to start..."
            sleep 1
        fi
    done
else
    echo "JUPYTERBOOK is not set. Skipping jupyterbook startup."
fi


if [ "${JUPYTERSERVER}" = "true" ]; then
    echo "JUPYTERSERVER is set. Proceeding to start jupyterserver."

    # Start jupyterhub using supervisorctl
    supervisorctl start jupyterserver

    # Loop to check the status of jupyterserver
    while true; do
        # Get the status of jupyterserver
        status=$(supervisorctl status jupyterserver | awk '{print $2}')

        # Check if the status is RUNNING
        if [ "$status" == "RUNNING" ]; then
            echo "jupyterserver is running."
            break
        else
            echo "Waiting for jupyterserver to start..."
            sleep 1
        fi
    done
else
    echo "JUPYTERSERVER is not set. Skipping jupyterserver startup."
fi


if [ "${JUPYTERSERVER_DEV}" = "true" ]; then
    echo "JUPYTERSERVER_DEV is set. Proceeding to start jupyterserver-dev."

    # Start jupyterserver-dev using supervisorctl
    supervisorctl start jupyterserver-dev

    # Loop to check the status of jupyterserver
    while true; do
        # Get the status of jupyterserver
        status=$(supervisorctl status jupyterserver-dev | awk '{print $2}')

        # Check if the status is RUNNING
        if [ "$status" == "RUNNING" ]; then
            echo "jupyterserver-dev is running."
            break
        else
            echo "Waiting for jupyterserver-dev to start..."
            sleep 1
        fi
    done
else
    echo "JUPYTERSERVER_DEV is not set. Skipping jupyterserver-dev startup."
fi


if [ "${JUPYTERHUB}" = "true" ]; then
    echo "JUPYTERHUB is set. Proceeding to start jupyterhub."

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
    echo "JUPYTERHUB is not set. Skipping jupyterhub startup."
fi


if [ "${JUPYTERHUB_DEV}" = "true" ]; then
    echo "JUPYTERHUB_DEV is set. Proceeding to start jupyterhub-dev."

    # Start jupyterhub using supervisorctl
    supervisorctl start jupyterhub-dev

    # Loop to check the status of jupyterhub
    while true; do
        # Get the status of jupyterhub
        status=$(supervisorctl status jupyterhub-dev | awk '{print $2}')

        # Check if the status is RUNNING
        if [ "$status" == "RUNNING" ]; then
            echo "jupyterhub-dev is running."
            break
        else
            echo "Waiting for jupyterhub-dev to start..."
            sleep 1
        fi
    done
else
    echo "JUPYTERHUB_DEV is not set. Skipping jupyterhub-dev startup."
fi

if [ "${OLLAMA}" = "true" ]; then
    echo "OLLAMA is set. Proceeding to start ollama."

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
    echo "OLLAMA is not set. Skipping ollama startup."
fi


if [ "${OPENWEBUI}" = "true" ]; then
    echo "OPENWEBUI is set. Proceeding to start openwebui."

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
    echo "OPENWEBUI is not set. Skipping openwebui startup."
fi


if [ "${OPENWEBUI_DEV}" = "true" ]; then
    echo "OPENWEBUI_DEV is set. Proceeding to start openwebui-dev."

    # Start openwebui using supervisorctl
    supervisorctl start openwebui-dev

    # Loop to check the status of openwebui-dev
    while true; do
        # Get the status of openwebui
        status=$(supervisorctl status openwebui-dev | awk '{print $2}')

        # Check if the status is RUNNING
        if [ "$status" == "RUNNING" ]; then
            echo "openwebui-dev is running."
            break
        else
            echo "Waiting for openwebui-dev to start..."
            sleep 1
        fi
    done
else
    echo "OPENWEBUI_DEV is not set. Skipping openwebui-dev startup."
fi
#!/bin/bash
# set -euxo pipefail
# set -x

# Function to start and monitor a service
start_service() {
    local service_name=$1
    local enable_var=$2

    if [ "${enable_var}" = "true" ]; then
        echo "${service_name} is enabled. Proceeding to start ${service_name}."

        # Start service using supervisorctl
        supervisorctl start "${service_name}"

        # Loop to check the status of service
        while true; do
            # Get the status of service
            status=$(supervisorctl status "${service_name}" | awk '{print $2}')

            # Check if the status is RUNNING
            if [ "$status" == "RUNNING" ]; then
                echo "${service_name} is running."
                break
            else
                echo "Waiting for ${service_name} to start..."
                sleep 5
                supervisorctl start "${service_name}"
            fi
        done
    else
        echo "${service_name} is not enabled. Skipping ${service_name} startup."
    fi
}

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
    echo "Supervisor socket not found. Retrying in 5 second..."
    sleep 5
done
echo "Supervisor socket is available."

# Start services using the function
start_service "jupyterhub" "${JH_ENABLE}"
start_service "jupyterserver" "${JS_ENABLE}"
start_service "ollama" "${OLLAMA_ENABLE}"
start_service "openwebui" "${OW_ENABLE}"
start_service "mcpo" "${MCPO_ENABLE}"
start_service "mcp-server-time" "${MCP_SERVER_TIME_ENABLE}"
start_service "mcp-server-fetch" "${MCP_SERVER_FETCH_ENABLE}"
start_service "mcp-brave-search" "${MCP_BRAVE_SEARCH_ENABLE}"
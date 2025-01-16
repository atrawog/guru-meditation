#!/bin/bash
# set -euxo pipefail
# set -x

cd /workspace

# Load environment variables from config.env file
set -a
if [[ -f /workspace/config/config.env ]]; then
  source /workspace/config/config.env
fi
set +a

/usr/local/bin/fixpermission.sh
/usr/local/bin/setpassword.sh
echo "Starting supervisord"
sudo /usr/sbin/supervisord -c /etc/supervisord.conf > /dev/null 2>&1 &
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


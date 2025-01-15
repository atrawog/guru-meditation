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
sudo /usr/sbin/supervisord -c /etc/supervisord.conf > /dev/null 2>&1 &

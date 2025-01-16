#!/bin/bash
#set -euxo pipefail
#export PS4='Line $LINENO: '

cd /workspace

# Load environment variables from config.env file
set -a
if [[ -f /workspace/config/config.env ]]; then
  source /workspace/config/config.env
fi
set +a

/usr/local/bin/postcreate.sh
/usr/sbin/bash

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

/usr/local/bin/postcreate.sh
/usr/sbin/bash
# /usr/sbin/bash -c "cd /workspace && /usr/local/bin/pixi shell --no-install"
# /usr/local/bin/pixi shell --no-install

#!/bin/bash
#set -euxo pipefail
#export PS4='Line $LINENO: '

cd /workspace
/usr/local/bin/postcreate.sh
tail -f /var/log/supervisor/supervisord.log
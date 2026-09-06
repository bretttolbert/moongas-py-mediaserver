#!/bin/bash
set -euo pipefail
rsync -ahvP /data/Covers/ root@$BT_DROPLET_IP:/var/www/html/Covers/ --delete --timeout=10

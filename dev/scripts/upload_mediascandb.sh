#!/bin/bash
set -euo pipefail
rsync -ahvP mediascan/out/mediascan.db root@$BT_DROPLET_IP:/var/www/mediax/mediascan/out/mediascan.db --timeout=10


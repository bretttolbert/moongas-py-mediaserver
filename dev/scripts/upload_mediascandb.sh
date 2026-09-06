#!/bin/bash
set -euo pipefail
rsync -ahvP mediascan.db root@$BT_DROPLET_IP:/var/www/moongas/mediascan.db --timeout=10

#!/bin/bash
set -euo pipefail
rsync -ahvP moongas-py-mediascan/ root@$MEDIASERVER_DROPLET_IP:/var/www/moongas/moongas-py-mediascan/ --delete 


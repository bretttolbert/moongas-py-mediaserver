#!/bin/bash
set -euo pipefail
rsync -ahvP mediascan/out/files.yaml root@$BT_DROPLET_IP:/var/www/mediax/mediascan/out/files.yaml


#!/bin/bash
set -euo pipefail
./update-files-yaml
./update-artists-yaml
./update-mediascandb
./upload-mediascandb
./update-covers
./restart-remote-mediaserver
sudo ./restart-local-mediaserver

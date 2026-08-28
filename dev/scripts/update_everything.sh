#!/bin/bash
set -euo pipefail
./update_files_yaml
./update_artists_yaml
./update_mediascandb
./upload_mediascandb
./update_covers
./restart_remote_mediaserver
sudo ./restart_local_mediaserver

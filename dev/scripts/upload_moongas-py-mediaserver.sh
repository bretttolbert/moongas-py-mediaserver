#!/bin/bash
set -euo pipefail
HOST=$MEDIASERVER_DROPLET_IP
DEST_USER=root
DEST_ROOT=/var/www/moongas
SVC=moongas-py-mediaserver
SOURCE=$SVC/
DEST=$DEST_USER@$HOST:$DEST_ROOT/$SVC/
echo "Uploading $SOURCE to $DEST"
# If first run, remove '--exclude 'app/templates/css.html'
# I added that because I've put my analytics html there
# TODO: Change 'mediaserver-config.yml' to 'mediaserver-config.yml'
rsync -ahvP $SOURCE $DEST --delete --exclude 'app/templates/css.html' --exclude 'dev/' --exclude mediaserver-config.yml --exclude '.git/' --exclude '.gitignore' --exclude '__pycache__/'
echo "Uploaded $SOURCE to $DEST"

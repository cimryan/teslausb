#!/bin/bash -eu

function configure_archive () {
  local archive_server_ip_address="$1"

  echo "Configuring the archive..."
  
  echo "Configuring for Rsync..."
  echo "user=$RSYNC_USER" > /root/.teslaCamRsyncConfig
  echo "server=$RSYNC_SERVER" >> /root/.teslaCamRsyncConfig
  echo "path=$RSYNC_PATH" >> /root/.teslaCamRsyncConfig
}

ARCHIVE_SERVER_IP_ADDRESS="$( /root/bin/get-archiveserver-ip-address.sh )"

configure_archive "$ARCHIVE_SERVER_IP_ADDRESS"
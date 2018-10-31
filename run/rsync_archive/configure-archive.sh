#!/bin/bash -eu

function configure_archive () {
  echo "Configuring the rsync archive..."

  echo "user=$RSYNC_USER" > /root/.teslaCamRsyncConfig
  echo "server=$RSYNC_SERVER" >> /root/.teslaCamRsyncConfig
  echo "path=$RSYNC_PATH" >> /root/.teslaCamRsyncConfig
}

configure_archive
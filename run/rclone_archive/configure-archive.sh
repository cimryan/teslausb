#!/bin/bash -eu

function configure_archive () {
  echo "Configuring the archive for Rclone..."
  
  echo "drive=$RCLONE_DRIVE" > /root/.teslaCamRcloneConfig
  echo "path=$RCLONE_PATH" >> /root/.teslaCamRcloneConfig
}

configure_archive
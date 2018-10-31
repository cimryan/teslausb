#!/bin/bash -eu

function configure_archive () {
  echo "Configuring rclone archive..."
  
  echo "drive=$RCLONE_DRIVE" > /root/.teslaCamRcloneConfig
  echo "path=$RCLONE_PATH" >> /root/.teslaCamRcloneConfig

  if [ ! -L "/root/.config/rclone" ] && [ -e "/root/.config/rclone" ]
  then
    echo "Moving rclone configs in /mutable"
    mv /root/.config/rclone /mutable/configs
    ln -s /mutable/configs/rclone /root/.config/rclone
  fi

  echo "done"
}

configure_archive
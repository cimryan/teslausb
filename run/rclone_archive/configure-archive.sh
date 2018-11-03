#!/bin/bash -eu

function configure_archive () {
  echo "Configuring rclone archive..."
  
  local config_file_path="/root/.teslaCamRcloneConfig"
  /root/bin/write-archive-configs-to.sh "$config_file_path"

  if [ ! -L "/root/.config/rclone" ] && [ -e "/root/.config/rclone" ]
  then
    echo "Moving rclone configs into /mutable"
    mv /root/.config/rclone /mutable/configs
    ln -s /mutable/configs/rclone /root/.config/rclone
  fi

  echo "Done"
}

configure_archive
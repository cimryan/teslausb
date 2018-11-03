#!/bin/bash -eu

function configure_archive () {
  echo "Configuring the rsync archive..."

  local config_file_path="/root/.teslaCamRsyncConfig"
  /root/bin/write-archive-configs-to.sh "$config_file_path"
}

configure_archive
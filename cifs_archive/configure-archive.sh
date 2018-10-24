#!/bin/bash -eu

function configure_archive () {
  local archive_server_ip_address="$1"

  echo "Configuring the archive..."
  
  local archive_path="/mnt/archive"

  if [ ! -e "$archive_path" ]
  then
    mkdir "$archive_path"  
  fi

  local credentials_file_path="/root/.teslaCamArchiveCredentials"

  /root/bin/write-archive-credentials-to.sh "$credentials_file_path"

  echo "//$archive_server_ip_address/$sharename $archive_path cifs vers=${cifs_version},credentials=${credentials_file_path},iocharset=utf8,file_mode=0777,dir_mode=0777 0" >> /etc/fstab

  echo "Configured the archive."
}

ARCHIVE_SERVER_IP_ADDRESS="$( /root/bin/get-archiveserver-ip-address.sh )"

configure_archive "$ARCHIVE_SERVER_IP_ADDRESS"
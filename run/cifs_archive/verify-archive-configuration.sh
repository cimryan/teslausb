#!/bin/bash -eu

function check_archive_server_reachable () {
  echo "Verifying that the archive server $archiveserver is reachable..."
  local serverunreachable=false
  ping -c 1 -w 1 "$archiveserver" 1>/dev/null 2>&1 || serverunreachable=true

  if [ "$serverunreachable" = true ]
  then
    echo "STOP: The archive server $archiveserver is unreachable. Try specifying its IP address instead."
    exit 1
  fi

  echo "The archive server is reachable."
}

function check_archive_mountable () {
  local archive_server_ip_address="$1"
  
  local test_mount_location="/tmp/archivetestmount"
  
  if [ ! -e "$test_mount_location" ]
  then
    mkdir "$test_mount_location"
  fi
  
  local cifs_version="${cifs_version:-3.0}"

  local tmp_credentials_file_path="/tmp/teslaCamArchiveCredentials"
  /root/bin/write-archive-configs-to.sh "$tmp_credentials_file_path"

  local mount_failed=false
  mount -t cifs "//$archive_server_ip_address/$sharename" "$test_mount_location" -o "vers=${cifs_version},credentials=${tmp_credentials_file_path},iocharset=utf8,file_mode=0777,dir_mode=0777" || mount_failed=true

  if [ "$mount_failed" = true ]
  then
    echo "STOP: The archive couldn't be mounted with CIFS version ${cifs_version}. Try specifying a lower number for the CIFS version like this:"
    echo "  export cifs_version=2.1"
    echo "Other versions you can try are 2.0 and 1.0"
    exit 1
  fi
  
  umount "$test_mount_location"
}

ARCHIVE_SERVER_IP_ADDRESS="$( $INSTALL_DIR/lookup-ip-address.sh "$archiveserver" )"

check_archive_server_reachable
check_archive_mountable "$ARCHIVE_SERVER_IP_ADDRESS"

#!/bin/bash -eu

SPACE_TO_USE="$1"
CAM_PERCENT="$2"
BACKINGFILES_MOUNTPOINT="$3"

G_MASS_STORAGE_CONF_FILE_NAME=/etc/modprobe.d/g_mass_storage.conf

function add_drive () {
  local name="$1"
  local label="$2"
  local size="$3"

  local filename="$4"
  fallocate -l "$size"K "$filename"
  mkfs.vfat "$filename" -F 32 -n "$label"

  local mountpoint=/mnt/"$name"

  mkdir "$mountpoint"
  echo "$filename $mountpoint vfat noauto,users,umask=000 0 0" >> /etc/fstab
}

CAM_DISK_SIZE="$(( $SPACE_TO_USE * $CAM_PERCENT / 100 ))"
CAM_DISK_FILE_NAME="$BACKINGFILES_MOUNTPOINT/cam_disk.bin"
add_drive "cam" "CAM" "$CAM_DISK_SIZE" "$CAM_DISK_FILE_NAME"

if [ "$CAM_PERCENT" -lt 100 ]
then
  MUSIC_PERCENT="$(( 100 - $CAM_PERCENT ))"
  MUSIC_DISK_SIZE="$(( $SPACE_TO_USE * $MUSIC_PERCENT / 100 ))"
  MUSIC_DISK_FILE_NAME="$BACKINGFILES_MOUNTPOINT/music_disk.bin"
  add_drive "music" "MUSIC" "$MUSIC_DISK_SIZE" "$MUSIC_DISK_FILE_NAME"
  echo "options g_mass_storage file=$CAM_DISK_FILE_NAME,$MUSIC_DISK_FILE_NAME removable=1,1 ro=0,0 stall=0 iSerialNumber=123456" > G_MASS_STORAGE_CONF_FILE_NAME
else
  echo "options g_mass_storage file=$CAM_DISK_FILE_NAME removable=1 ro=0 stall=0 iSerialNumber=123456" > G_MASS_STORAGE_CONF_FILE_NAME
fi

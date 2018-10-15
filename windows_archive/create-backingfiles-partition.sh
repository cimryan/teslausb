#!/bin/bash -eu

BACKINGFILES_MOUNTPOINT="$1"
  
PARTITION_TABLE=$(parted -m /dev/mmcblk0 unit s print)
ROOT_PARTITION_LINE=$(echo "$PARTITION_TABLE" | grep -e "^2:")
LAST_ROOT_PARTITION_SECTOR=$(echo "$ROOT_PARTITION_LINE" | sed 's/s//g' | cut -d ":" -f 3)

FIRST_BACKINGFILES_PARTITION_SECTOR=$(( $LAST_ROOT_PARTITION_SECTOR + 1 ))

parted -m /dev/mmcblk0 u s mkpart primary ext4 "$FIRST_BACKINGFILES_PARTITION_SECTOR" 100%

mkfs.ext4 /dev/mmcblk0p3

echo "/dev/mmcblk0p3 $BACKINGFILES_MOUNTPOINT ext4 auto,rw,noatime 0 2" >> /etc/fstab
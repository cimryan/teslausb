#!/bin/bash

# Adapted from https://github.com/adafruit/Raspberry-Pi-Installer-Scripts/blob/master/read-only-fs.sh

function append_cmdline_txt_param() {
  local toAppend="$1"
  sed -i "s/\'/ ${toAppend}/g" /boot/cmdline.txt >/dev/null
}

echo "Configuring system..."
  
# Add fastboot, noswap and/or ro to end of /boot/cmdline.txt
append_cmdline_txt_param fastboot
append_cmdline_txt_param noswap
append_cmdline_txt_param ro

# Move fake-hwclock.data to /mutable directory so it can be updated
if ! findmnt --mountpoint /mutable
then
    echo "Mounting the mutable partition..."
    mount /mutable
    echo "Mounted."
fi
if [ ! -e "/mutable/etc" ]
then
    mkdir -p /mutable/etc
fi

if [ ! -L "/etc/fake-hwclock.data" ] && [ -e "/etc/fake-hwclock.data" ]
then
    echo "Moving fake-hwclock data"
    mv /etc/fake-hwclock.data /mutable/etc/fake-hwclock.data
    ln -s /mutable/etc/fake-hwclock.data /etc/fake-hwclock.data
fi

# Create a configs directory for others to use
if [ ! -e "/mutable/configs" ]
then
    mkdir -p /mutable/configs
fi

# Move /var/spool to /tmp
rm -rf /var/spool
ln -s /tmp /var/spool

# Change spool permissions in var.conf (rondie/Margaret fix)
sed -i "s/spool\s*0755/spool 1777/g" /usr/lib/tmpfiles.d/var.conf >/dev/null

# Move dhcpd.resolv.conf to tmpfs
mv /etc/resolv.conf /tmp/dhcpcd.resolv.conf
ln -s /tmp/dhcpcd.resolv.conf /etc/resolv.conf

# Update /etc/fstab
# make /boot read-only
# make / read-only
# tmpfs /var/log tmpfs nodev,nosuid 0 0
# tmpfs /var/tmp tmpfs nodev,nosuid 0 0
# tmpfs /tmp     tmpfs nodev,nosuid 0 0
sed -i -r "s@(/boot\s+vfat\s+\S+)@\1,ro@" /etc/fstab
sed -i -r "s@(/\s+ext4\s+\S+)@\1,ro@" /etc/fstab
echo "" >> /etc/fstab
echo "tmpfs /var/log tmpfs nodev,nosuid 0 0" >> /etc/fstab
echo "tmpfs /var/tmp tmpfs nodev,nosuid 0 0" >> /etc/fstab
echo "tmpfs /tmp    tmpfs nodev,nosuid 0 0" >> /etc/fstab


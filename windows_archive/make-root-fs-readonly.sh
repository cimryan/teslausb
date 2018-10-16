#!/bin/bash

# Adapted from https://github.com/adafruit/Raspberry-Pi-Installer-Scripts/blob/master/read-only-fs.sh

function append_cmdline_txt_param() {
  local toAppend="$1"
  sed -i "s/\'/ ${toAppend}/g" /boot/cmdline.txt >/dev/null
}

echo "Updating package index files..."
apt-get update
echo "Removing unwanted packages..."
apt-get remove -y --force-yes --purge triggerhappy logrotate dphys-swapfile fake-hwclock
apt-get -y --force-yes autoremove --purge
# Replace log management with busybox (use logread if needed)
echo "Installing ntp and busybox-syslogd..."
apt-get -y --force-yes install ntp busybox-syslogd; dpkg --purge rsyslog
echo "Configuring system..."
  
# Add fastboot, noswap and/or ro to end of /boot/cmdline.txt
append_cmdline_txt_param fastboot
append_cmdline_txt_param noswap
append_cmdline_txt_param ro

# Move /var/spool to /tmp
rm -rf /var/spool
ln -s /tmp /var/spool

# Change spool permissions in var.conf (rondie/Margaret fix)
sed -i "s/spool\s*0755/spool 1777/g" /usr/lib/tmpfiles.d/var.conf >/dev/null

# Move dhcpd.resolv.conf to tmpfs
touch /tmp/dhcpcd.resolv.conf
rm /etc/resolv.conf
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


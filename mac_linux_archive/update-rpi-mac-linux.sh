#!/bin/bash
#|| @license
#|| | This program is free software; you can redistribute it and/or
#|| | modify it under the terms of the GNU Lesser General Public
#|| | License as published by the Free Software Foundation; version
#|| | 2.1 of the License.
#|| |
#|| | This program is distributed in the hope that it will be useful,
#|| | but WITHOUT ANY WARRANTY; without even the implied warranty of
#|| | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#|| | Lesser General Public License for more details.
#|| |
#|| | You should have received a copy of the GNU Lesser General Public
#|| | License along with this library; if not, write to the Free Software
#|| | Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#|| #

# Script repurposed fromhttps://github.com/BigNate1234/rpi-USBSSH
#
# This script will modify the cmdline.txt file on a freshly flashed Raspbian Stretch/Lite
# It readies it for SSH, USB OTG, USB networking, and Wifi
#
# Run it in a terminal in the "boot" directory of the flashed MicroSD card
# Ex:
# cd /Volumes/boot (or wherever the boot folder is mounted)
# chmod+x update-rpi-mac-linux.sh  (if not executable already)
# ./update-rpi-mac-linux.sh
#
# Put the card in your Pi, and reboot!

# Creates the ssh file if needed, since Raspbian now disables 
# ssh by default if the file isn't present

if [ ! -r "cmdline.txt" ]; then
  echo 'STOP: Run this script in the "boot" directory where cmdline.txt is located.'
  exit 1
fi

if [ ! -n "${SSID+x}" ] || [ ! -n "${WIFIPASS+x}"  ]
then
  echo 'STOP: You need to specify your wifi name and password first. Run: '
  echo " "
  echo '      export SSID=your_ssid'
  echo '      export WIFIPASS=your_wifi_password'
  echo " "
  echo "Be sure to replace the values with your SSID (network name) and password."
  exit 1
fi

if [ ! -f ssh ]; then
  touch ssh
fi

# Append the dwc2 module if not set (USB OTG)

dt=$(cat config.txt | grep "dtoverlay=dwc2")
if [ "$dt" != "dtoverlay=dwc2" ]; then
  echo "dtoverlay=dwc2" >> config.txt
fi

# Append the g_ether module if not set (USB networking)

mod=$(cat cmdline.txt | grep -o "modules-load=dwc2,g_ether")
if [ "$mod" != "modules-load=dwc2,g_ether" ]; then
  sed -i '' '$ s/$/ modules-load=dwc2,g_ether/' cmdline.txt
  # Only appends to end of line, not newline
fi

# Remove the automatic filesystem expansion action
# This is specific to the teslausb project; normally the 
# Raspbian image will automatically expand the filesystem to include the 
# entire SD card. 

mod=$(cat cmdline.txt | grep -o "init=/usr/lib/raspi-config/init_resize.sh")
if [ "$mod" = "init=/usr/lib/raspi-config/init_resize.sh" ]; then
  sed -i'.bak' -e 's/ init=\/usr\/lib\/raspi-config\/init_resize.sh//g' cmdline.txt
fi

# Sets up wifi credentials so wifi will be 
# auto configured on first boot


cat << EOF >> wpa_supplicant.conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid=$SSID
  psk=$WIFIPASS
  key_mgmt=WPA-PSK
}
EOF

cd
echo ""
echo '-- Files updated and ready for Wifi and SSH over USB --'
echo ""

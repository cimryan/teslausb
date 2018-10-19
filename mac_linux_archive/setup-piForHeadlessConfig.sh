#/bin/bash -eu

# This script will modify the cmdline.txt file on a freshly flashed Raspbian Stretch/Lite
# It readies it for SSH, USB OTG, USB networking, and Wifi
#
# Pass it the path to the location at which the "boot" filesystem is mounted.
# E.g. on a Mac:
#   ./setup-piForHeadlessConfig.sh /Volumes/boot
# or on Ubuntu:
#   ./setup-piForHeadlessConfig.sh /media/$USER/boot
# cd /Volumes/boot (or wherever the boot folder is mounted)
# chmod +x setup-piForHeadlessConfig.sh
# ./setup-piForHeadlessConfig.sh
#
# Put the card in your Pi, and reboot!

# Creates the ssh file if needed, since Raspbian now disables 
# ssh by default if the file isn't present

BOOT_DIR="$1"

function verify_file_exists () {
  local file_name="$1"
  local expected_path="$2"
  
  if [ ! -e "$expected_path/$file_name" ]
    then
      echo "STOP: Didn't find $file_name at $expected_path."
      exit 1
  fi  
}

function verify_wifi_variables () {
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
}

verify_file_exists "cmdline.txt" "$BOOT_DIR"
verify_file_exists "config.txt" "$BOOT_DIR"

verify_wifi_variables

CMDLINE_TXT_PATH="$BOOT_DIR/cmdline.txt"
CONFIG_TXT_PATH="$BOOT_DIR/config.txt"

if ! grep -q "dtoverlay=dwc2" $CONFIG_TXT_PATH
then
   echo "Updating $CONFIG_TXT_PATH ..."
   echo "" >> "$CONFIG_TXT_PATH"
   echo "dtoverlay=dwc2" >> "$CONFIG_TXT_PATH"
else
   echo "$CONFIG_TXT_PATH already contains the required dwc2 module"
fi

if ! grep -q "dwc2,g_ether" $CMDLINE_TXT_PATH
then
  echo "Updating $CMDLINE_TXT_PATH ..."
  sed -i'.bak' -e "s/rootwait/rootwait modules-load=dwc2,g_ether/" -e "s@ init=/usr/lib/raspi-config/init_resize.sh@@" "$CMDLINE_TXT_PATH"
else
  echo "$CMDLINE_TXT_PATH already updated with modules and removed initial resize script."
fi

echo "Enabling SSH ..."
touch "$BOOT_DIR/ssh"

# Sets up wifi credentials so wifi will be 
# auto configured on first boot

WPA_SUPPLICANT_CONF_PATH="$BOOT_DIR/wpa_supplicant.conf"

echo "Adding Wifi setup file (wpa_supplicant.conf)."
if [ -r "$WPA_SUPPLICANT_CONF_PATH" ]
then
  rm "$WPA_SUPPLICANT_CONF_PATH"
fi

cat << EOF >> "$WPA_SUPPLICANT_CONF_PATH"
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="$SSID"
  psk="$WIFIPASS"
  key_mgmt=WPA-PSK
}
EOF

echo ""
echo '-- Files updated and ready for Wifi and SSH over USB --'
echo ""

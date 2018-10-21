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
RED='\033[0;31m' # Red for warning
NC='\033[0m' # No Color
GREEN='\033[0;32m'
scripts_downloaded=false
REPO=rtgoodwin
BRANCH=headless-patch

function stop_message () {
  echo -e "${RED}${1} ${NC}"
}

function good_message () {
  echo -e "${GREEN}${1} ${NC}"
}

function show_setup_var_instructions () {

    stop_message 'STOP: You need to specify your setup variables first. Create the file "teslausb_setup_variables.conf" with: '
    echo ""
    echo '       export archiveserver=Nautilus'
    echo '       export sharename=SailfishCam'
    echo '       export shareuser=sailfish'
    echo '       export sharepassword=pa$$w0rd'
    echo '       export campercent=100'
    echo ""
    echo "Be sure to replace the values with your relevant choices."
    exit 1

}

function verify_file_exists () {
  local file_name="$1"
  local expected_path="$2"

  if [ ! -e "$expected_path/$file_name" ]
    then
      stop_message "STOP: Didn't find $file_name at $expected_path."
      exit 1
  fi
}

function verify_setup_file_exists () {
  local file_name="$1"
  local expected_path="$2"

  if [ ! -e "$expected_path/$file_name" ]
    then
      stop_message "STOP: Didn't find setup script $file_name at $expected_path. Try running the setup script again."
      exit 1
  fi
}

function verify_wifi_variables () {
  if [ ! -n "${SSID+x}" ] || [ ! -n "${WIFIPASS+x}"  ]
  then
    stop_message 'STOP: You need to specify your wifi name and password first. Run: '
    echo ""
    echo '      export SSID=your_ssid'
    echo '      export WIFIPASS=your_wifi_password'
    echo ""
    echo "Be sure to replace the values with your SSID (network name) and password."
    exit 1
  fi
}

function verify_setup_variables_file_exists () {
  local file_name="$1"
  local expected_path="$2"

  if [ ! -e "$expected_path/$file_name" ]
    then
      show_setup_var_instructions
      exit 1
  fi
}

function verify_setup_variables () {
  if [ ! -n "${archiveserver+x}" ]
  then
    show_setup_var_instructions
  fi
}

function verify_pushover_variables () {
  if [ ! -z "${pushover_enabled+x}" ]
  then
    if [ ! -n "${pushover_user_key+x}" ] || [ ! -n "${pushover_app_key+x}"  ]
    then
      stop_message "STOP: You're trying to setup Pushover but didn't provide your User and/or App key."
      echo 'Define the variables in "teslausb_setup_variables.conf" like this:'
      echo ""
      echo "       export pushover_user_key=put_your_userkey_here"
      echo "       export pushover_app_key=put_your_appkey_here"
      exit 1
    elif [ "${pushover_user_key}" = "put_your_userkey_here" ] || [  "${pushover_app_key}" = "put_your_appkey_here" ]
    then
      stop_message "STOP: You're trying to setup Pushover, but didn't replace the default User and App key values."
      echo 'Replace the default values in "teslausb_setup_variables.conf".'
      exit 1
    else
      user_enabled_pushover=true
      echo "export pushover_enabled=true" > $BOOT_DIR/.teslaCamPushoverCredentials
      echo "export pushover_user_key=$pushover_user_key" >> $BOOT_DIR/.teslaCamPushoverCredentials
      echo "export pushover_app_key=$pushover_app_key" >> $BOOT_DIR/.teslaCamPushoverCredentials
    fi
  fi
}

function download_scripts () {
  
  if [ ! -d "${BOOT_DIR}/teslausb_setup_scripts" ]
  then
    mkdir "${BOOT_DIR}/teslausb_setup_scripts"
    # stop_message "ERROR: Failed to make teslausb_setup_scripts and download setup scripts. Ensure you have internet access and run this script again."
  else
    pushd "${BOOT_DIR}/teslausb_setup_scripts"
    
    wget https://raw.githubusercontent.com/"$REPO"/teslausb/"$BRANCH"/headless-scripts/setup-teslausb-headless -O setup-teslausb-headless
    verify_setup_file_exists "setup-teslausb-headless" "${BOOT_DIR}/teslausb_setup_scripts"
    chmod +x setup-teslausb-headless
    good_message "Downloaded main setup script."
    
    wget https://raw.githubusercontent.com/"$REPO"/teslausb/"$BRANCH"/windows_archive/archiveloop -O archiveloop
    # sed s/ARCHIVE_HOST_NAME=archiveserver/ARCHIVE_HOST_NAME=$archiveserver/ ~/archiveloop > /root/bin/archiveloop
    sed -i'.bak' -e "s/ARCHIVE_HOST_NAME=archiveserver/ARCHIVE_HOST_NAME=$archiveserver/" archiveloop
    verify_setup_file_exists "archiveloop" "${BOOT_DIR}/teslausb_setup_scripts"
    chmod +x archiveloop

    wget https://raw.githubusercontent.com/"$REPO"/teslausb/"$BRANCH"/windows_archive/archive-teslacam-clips -O archive-teslacam-clips
    verify_setup_file_exists "archive-teslacam-clips" "${BOOT_DIR}/teslausb_setup_scripts"
    chmod +x archive-teslacam-clips
    good_message "Configured the archive scripts."

    wget https://raw.githubusercontent.com/"$REPO"/teslausb/"$BRANCH"/windows_archive/remountfs_rw -O remountfs_rw
    verify_setup_file_exists "remountfs_rw" "${BOOT_DIR}/teslausb_setup_scripts"
    chmod +x remountfs_rw
    good_message "Downloaded script to remount filesystems read/write if needed (/root/bin/remountfs_rw)."

    if [ ${user_enabled_pushover} = "true" ]
    then
      wget https://raw.githubusercontent.com/"$REPO"/teslausb/"$BRANCH"/windows_archive/send-pushover
      verify_setup_file_exists "remountfs_rw" "${BOOT_DIR}/teslausb_setup_scripts"
      chmod +x send-pushover
      good_message "Downloaded Pushover notification script."
    fi

    good_message "Downloading ancillary setup scripts."
    wget https://raw.githubusercontent.com/"$REPO"/teslausb/"$BRANCH"/windows_archive/create-backingfiles-partition.sh -O create-backingfiles-partition.sh
    verify_setup_file_exists "create-backingfiles-partition.sh" "${BOOT_DIR}/teslausb_setup_scripts"
    chmod +x create-backingfiles-partition.sh
    wget https://raw.githubusercontent.com/"$REPO"/teslausb/"$BRANCH"/windows_archive/create-backingfiles.sh -O create-backingfiles.sh
    verify_setup_file_exists "create-backingfiles.sh" "${BOOT_DIR}/teslausb_setup_scripts"
    chmod +x create-backingfiles.sh
    wget https://raw.githubusercontent.com/"$REPO"/teslausb/"$BRANCH"/windows_archive/make-root-fs-readonly.sh -O make-root-fs-readonly.sh
    verify_setup_file_exists "make-root-fs-readonly.sh" "${BOOT_DIR}/teslausb_setup_scripts"
    chmod +x make-root-fs-readonly.sh
    popd
    good_message "All scripts downloaded and configured."
  fi

}

verify_file_exists "cmdline.txt" "$BOOT_DIR"
verify_file_exists "config.txt" "$BOOT_DIR"
verify_setup_variables_file_exists "teslausb_setup_variables.conf" "$BOOT_DIR"

source "$BOOT_DIR"/teslausb_setup_variables.conf

verify_wifi_variables
verify_setup_variables
verify_pushover_variables

CMDLINE_TXT_PATH="$BOOT_DIR/cmdline.txt"
CONFIG_TXT_PATH="$BOOT_DIR/config.txt"

if ! grep -q "dtoverlay=dwc2" $CONFIG_TXT_PATH
then
   good_message "Updating $CONFIG_TXT_PATH ..."
   echo "" >> "$CONFIG_TXT_PATH"
   echo "dtoverlay=dwc2" >> "$CONFIG_TXT_PATH"
else
   good_message "config.txt already contains the required dwc2 module"
fi

if ! grep -q "dwc2,g_ether" $CMDLINE_TXT_PATH
then
  echo "Updating $CMDLINE_TXT_PATH ..."
  sed -i'.bak' -e "s/rootwait/rootwait modules-load=dwc2,g_ether/" -e "s@ init=/usr/lib/raspi-config/init_resize.sh@@" "$CMDLINE_TXT_PATH"
else
  good_message "cmdline.txt already updated with modules and removed initial resize script."
fi

if [ ! -e "$BOOT_DIR/ssh" ]
then 
  good_message "Ensuring SSH is setup..."
  touch "$BOOT_DIR/ssh"
fi

# Sets up wifi credentials so wifi will be
# auto configured on first boot

WPA_SUPPLICANT_CONF_PATH="$BOOT_DIR/wpa_supplicant.conf"

good_message "Adding Wifi setup file (wpa_supplicant.conf)."
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

good_message "Downloading setup scripts. They will be downloaded to ${BOOT_DIR}/teslausb_setup_scripts,"
good_message "and moved to /root/teslausb_setup_scripts during first boot and install."

download_scripts

echo ""
good_message '-- Files updated and ready for headless setup --'
echo ''
echo 'You can now insert your SD card into the Pi for headless setup. Plug in power to the Pi and it will boot and run.'
echo "When done (this may take a vew minutes), the Pi should be available over SSH as pi@teslausb.local."
echo "It's recommended you have your Pi plugged into a PC USB port for power, and connected to the port labeled USB on the Pi."
echo "That way, when setup is complete, you should see your CAM and/or MUSIC drives appear as confirmation."
echo ""

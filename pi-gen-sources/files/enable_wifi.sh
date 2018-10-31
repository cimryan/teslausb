#! /bin/bash -eu 
# This is a standalone script to just manually trigger
# the steps to enable wifi so you don't have to run rc.local
#
# This is probably a model to follow, similar to some of the 
# reorganization work going on with the main scripts.

HEADLESS_SETUP=false

if [ -e "/boot/teslausb-headless-setup.log" ]
then
    HEADLESS_SETUP=true
fi


function setup_progress () {
  if [ $HEADLESS_SETUP = "true" ]
  then
    SETUP_LOGFILE=/boot/teslausb-headless-setup.log
    echo "$( date ) : $1" >> "$SETUP_LOGFILE"
  fi
    echo $1
}

function enable_wifi () {
  setup_progress "Detecting whether to update wpa_supplicant.conf"
  if [ ! -z ${SSID+x} ] && [ ! -z ${WIFIPASS+x} ]
  then
      if [ ! -e /boot/WIFI_ENABLED ]
      then
        if [ -e /root/bin/remountfs_rw ]
        then
          /root/bin/remountfs_rw
        fi
        setup_progress "Wifi variables specified, and no /boot/WIFI_ENABLED. Building wpa_supplicant.conf."
        cp /boot/wpa_supplicant.conf.sample /boot/wpa_supplicant.conf
        sed -i'.bak' -e "s/TEMPSSID/${SSID}/g" /boot/wpa_supplicant.conf
        sed -i'.bak' -e "s/TEMPPASS/${WIFIPASS}/g" /boot/wpa_supplicant.conf
        cp /boot/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
        touch /boot/WIFI_ENABLED
        setup_progress "Rebooting..."
        reboot 
      fi
  else 
    echo "You need to export your desired SSID and WIFI pass like:"
    echo "  export SSID=your_ssid"
    echo "  export WIFIPASS=your_wifi_pass"
    echo ""
    echo "Then re-run enable_wifi.sh"

  fi
}

enable_wifi
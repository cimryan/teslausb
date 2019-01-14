# One-step setup

This is a streamlined process for setting up the Pi. You'll flash a preconfigured version of Raspbian Stretch Lite and then fill out a config file. 

## Notes 

* Assumes your Pi has access to Wifi, with internet access (during setup). (But all setup methods do currently.) USB networking is still enabled for troubleshooting or manual setup
* This image will work for either _headless_ (tested) or _manual_ (tested less) setup.
* Currently not tested with the RSYNC/SFTP method when using headless setup. 

## Configure the SD card before first boot of the Pi

1. Flash the [latest image release](https://github.com/rtgoodwin/teslausb/releases) using Etcher or similar. 

### For headless (automatic) setup

1. Mount the card again, and in the `boot` directory create a `teslausb_setup_variables.conf` file to export the same environment varibles normally needed for manual setup (including archive info, Wifi, and push notifications (if desired). 
A sample conf file is located in the `boot` folder on the SD card. 

    The file should contain the entries below at a minimum, but **replace with your own values**. Be sure that your WiFi password is enclosed in single quotes, and that if it contains one or more single quote characters you replace each single quote character with a backslash followed by a single quote character.

    For example, if your password were
    ```
    a'b
    ```
    you would have

    ```
    export sharepassword='a\'b'
    ```

    Example file:

    ```
    export archiveserver=Nautilus
    export sharename=SailfishCam
    export shareuser=sailfish
    export sharepassword='pa$$w0rd'
    export campercent=100
    export SSID=your_ssid
    export WIFIPASS=your_wifi_password
    export HEADLESS_SETUP=true
    # export REPO=rtgoodwin
    # export BRANCH=headless-patch
    # By default will use the main repo, but if you've been asked to test the image, 
    # these variables should be uncommunted and updated to point to the right repo/branch 

    # export pushover_enabled=false
    # export pushover_user_key=user_key
    # export pushover_app_key=app_key
    ```

1. Boot it in your Pi, give it a bit, watching for a series of flashes (2, 3, 4, 5) and then a reboot and/or the CAM/music drives to become available on your PC/Mac. The LED flash stages are:

| Stage (number of flashes)  |  Activity |
|---|---|
| 2 | Verify the requested configuration is creatable |
| 3 | Grab scripts to start/continue setup |
| 4 | Create partition and files to store camera clips/music) |
| 5 | Setup completed; remounting filesystems as read-only and rebooting |

The Pi should be available for `ssh` at `pi@teslausb.local`, over Wifi (if automatic setup works) or USB networking (if it doesn't). It takes about 5 minutes, or more depending on network speed, etc. 

If plugged into just a power source, or your car, give it a few minutes until the LED starts pulsing steadily which means the archive loop is running and you're good to go. 

You should see in `/boot` the `TESLAUSB_SETUP_FINISHED` and `WIFI_ENABLED` files as markers of headless setup success as well.

### For manual setup

1. After flashing the image, boot it in your Pi and:
    *  connect via USB networking at `ssh pi@teslausb.local`. (The Pi must be connected to your PC and plugged into the port labeled USB on the Pi. Or...
    * You can also just automate the Wifi portion of setup by creating the `boot/teslausb_setup_variables.conf` file and populating it with the `SSID` and `WIFIPASS` variables:
    ```
    export SSID=your_ssid
    export WIFIPASS=your_wifi_pass
    ```

1. Once you have an `ssh` session, follow the steps starting at [Set up the USB storage functionality](https://github.com/cimryan/teslausb#set-up-the-usb-storage-functionality) in the main guide. 

### Troubleshooting

#### Headless (full or Wifi) setup 
* `ssh` to `pi@teslausb.local` (assuming Wifi came up, or your Pi is connected to your computer via USB) and look at the `/boot/teslausb-headless-setup.log`. 
* Try `sudo -i` and then run `/etc/rc.local`. The scripts are  fairly resilient to restarting and not re-running previous steps, and will tell you about progress/failure.
* If Wifi didn't come up:
    * Double-check the SSID and WIFIPASS variables in `teslausb_setup_variables.conf`, and remove `/boot/WIFI_ENABLED`, then booting the SD in your Pi to retry automatic Wifi setup. 
  * If still no go, re-run `/etc/rc.local`
  * If all else fails, copy `/boot/wpa_supplicant.conf.sample` to `/boot/wpa_supplicant.conf` and edit out the `TEMP` variables to your desired settings. 
* (Note: if you get an error about `read-only filesystem`, you may have to `sudo -i` and run `/root/bin/remountfs_rw`.


# Background information
## What happens under the covers

When the Pi boots the first time: 
* A `/boot/teslausb-headless-setup.log` file will be created and stages logged. 
* Marker files will be created in `boot` like `TESLA_USB_SETUP_STARTED` and `TESLA_USB_SETUP_FINISHED` to track progress. 
* Wifi is detected by looking for `/boot/WIFI_ENABLED` and if not, creates the `wpa_supplicant.conf` file in place, using `SSID` and `WIFIPASS` from `teslausb_setup_varibles.conf` and reboots. 
* The Pi LED will flash patterns (2, 3, 4, 5) as it gets to each stage (labeled in the setup-teslausb-headless script). 
  * ~~10 flashes means setup failed!~~ (not currently working)
* After the final stage and reboot the LED will go back to normal. Remember, the step to remount the filesystem takes a few minutes.

At this point the next boot should start the Dashcam/music drives like normal. If you're watching the LED it will start flashing every 1 second, which is the archive loop running. 

> NOTE: Don't delete the `TESLAUSB_SETUP_FINISHED` or `WIFI_ENABLED` files. This is how the system knows setup is complete. 

# Image modification sources

The sources for the image modifications, and details, are in the [pi-gen-sources folder](https://github.com/cimryan/teslausb/pi-gen-sources). 

# Flashable image to get started more quickly

# This is a WORK IN PROGRESS, SHOULD CURRENTLY BE WORKING. 


## Notes 

* Assumes your Pi has access to Wifi, with internet access (during setup). (But all setup methods do currently.) USB networking is still enabled for troubleshooting or manual setup
* This image will work for either _headless_ (tested) or _manual_ (tested less) setup.
* Currently not tested with the RSYNC/SFTP method when using headless setup. 

## Configure the SD card before first boot of the Pi

1. Flash the [latest image release](https://github.com/rtgoodwin/teslausb/releases) using Etcher or similar. 

### For headless (automatic) setup

1. Mount the card again, and in the `boot` directory create a `teslausb_setup_variables.conf` file to export the same environment varibles normally needed for manual setup (including archive info, Wifi, and push notifications (if desired). 
A sample conf file is located in the `boot` folder on the SD card. 


    The file should contain the entries below at a minimum, but **replace with your own values**:
    ```
    export archiveserver=Nautilus
    export sharename=SailfishCam
    export shareuser=sailfish
    export sharepassword=pa$$w0rd
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

* Boot it in your Pi, give it a bit, watching for a series of flashes (2, 3, 4, 5) and then a reboot and/or the CAM/music drives to become available on your PC/Mac. The LED flash stages are:

| Stage (number of flashes)  |  Activity |
|---|---|
| 2 | Verify setup variables  |
| 3 | Grab scripts to start/continue setup |
| 4 | Create partition and files to store camera clips/music) |
| 5 | Setup completed; remounting filesystems as read-only and rebooting |



* The Pi should be available for `ssh` at `pi@teslausb.local`, over Wifi (if automatic setup works) or USB networking (if it doesn't). It takes about 5 minutes, or more depending on network speed, etc. 
* If plugged into just a power source, or your car, give it a few minutes until the LED starts pulsing steadily which means the archive loop is running and you're good to go. 
* You should see in `/boot` the `TESLAUSB_SETUP_FINISHED` and `WIFI_ENABLED` files as markers of headless setup success as well.

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

### Image builder source and patches

For now the image creation work is at:
* Modified pi-gen [rtgoodwin's fork of pi-gen](https://github.com/rtgoodwin/pi-gen) in (whatever current branch I'm working at the time). 
* `headless-patch` branch of rtgoodwin fork [https://github.com/rtgoodwin/teslausb/tree/headless-patch/headless-scripts](https://github.com/rtgoodwin/teslausb/tree/headless-patch/headless-scripts)


### Image refinement TODOs
1. ~~Patch the hostname to teslausb~~
1. Make it so if someone deletes the `TESLAUSB_SETUP_FINISHED` file it's handled gracefully. (Right now it will try to re-run setup which should be fine.) 
1. Cache the remount packages? Might mess with first boot like `rsyslog`
1. Aspirational TODO: Remove more packages and set services to stopped to make the boot process faster? 
1. At this point, it's designed to pull the setup scripts _dynamically_, since development is still ongoing. If/when we reach a good frozen state, we can generate an image that is essentially ready to run. I think it'll also be pretty tricky to do some of the remounting and creating the backing files etc. on the image creation side. Open to suggestions/contributions there though! 


#### Modifications to pi-gen builder from master

The image is built on a Raspberry Pi 3B running Stretch, for maximum Pi-ception. 

This is the basic configuration, but it's helpful to just [look at the code itself](https://github.com/rtgoodwin/pi-gen/tree/teslausb-headless-image) and the Readme for Pi-gen which explains this all in much greater detail:

1. Added SKIP and SKIP_IMAGES files to stage3, 4, and 5 (if present). We want to build the default image up to stage2, then add our own stage for tweaks we want. 
1. Added a `stage6` (or 7, just something beyond stage5). (There are stages 0-4 in the main Raspbian pi-gen repo by default, but may be a stage5 in some cases. This will help keep a clean merge later.)
1. Copy the prerun.sh from `stage2`. Be SURE to `chmod +x` it. 
1. Remove or rename the EXPORT_NOOBS files in all stages. We don't need a NOOBS image built. 
1. In `stage6`, create a `00-tweaks` folder, with a `00-patches` folder and patches inside. Currently patched:

    | File  | Change  |
    |---|---|
    | `cmdline.txt`| Add the dwc2,g_ether modules  |
    | `config.txt`| Add the dwc2 module  |
    | `hosts` | Change hostname to `teslausb` |
    | `hostname` | Change hostname to `teslausb` |
    
    * The build process uses `quilt` for patching
    * The path for any patching you do at this stage is `stage6/rootfs/FILEPATH` where `rootfs` represents the Pi's `/`. So, `cmdline.txt` is `stage6/rootfs/boot/cmdline.txt`.

1. Added a file called `series` in the patches directory with the name of each `.diff` file in the order you want them applied.
1. Added a `files` folder in stage6 with modified `rc.local`, and whatever else you want copied into the image. The modified `rc.local` will handle pulling down the `setup-teslausb-headless` file the first time and doing Wifi setup.
1. Added a script to flash the Pi LED  
1. Files are moved into final locations using the  `00-run.sh` script using the `install` command. See the script for details. I also `touch /boot/ssh` here so SSH is ready out of the box.
1. Run `sudo ./build.sh` from the `pi-gen` directory.
1. If you get a failure, it's almost certainly after stage2, so you can add SKIP files in all successful stages and rerun `sudo CLEAN=1 ./build.sh`
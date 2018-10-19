# Setting up the Pi without a monitor using a Mac or Linux

You can setup the Pi to connect to your Wifi network, and also provide the option to connect over USB networking (Rasberry Pi Zero W or other recent Pi's).


**What is USB networking?** 
Basically what you're doing is using the Pi's capability to emulate a network connection over USB. So you need to get the Pi (the guest) set up to load the proper modules to do so, and then connect from your machine (the host) using a shell (like iTerm+SSH on macOS). It's an alternative to Wifi if needed. 

## Use the update script to setup Wifi and USB networking 

A [script](https://raw.githubusercontent.com/cimryan/teslausb/master/mac_linux_archive/setup-piForHeadlessConfig.sh is provided to automatically update your SD card so the first time you boot it on your Pi, USB networking and Wifi will automatically be configured. 

If you prefer not to run the script, it's also a useful reference for the steps you'll need to take. 

> It's important you do these steps **before you boot the Pi the first time with the SD card inserted**. 

1. Ensure you've flashed your Raspbian image to your SD card. 
1. If the `boot` folder isn't showing on your computer, eject and re-insert the SD card into your computer, **not the Raspberry Pi**. 
1. Change to the directory where the SD card's `boot` folder (containing `cmdline.txt`) is located. On a Mac, this will be `/Volumes/boot`. On Linux the location may vary. 
1. Run the following commands:
    ```
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/mac_linux_archive/setup-piForHeadlessConfig.sh
    chmod +x update-rpi-mac-linux.sh
    ```
1. Set your SSID (Wifi network name) and WIFIPASS environment variables. The script will insert them into the `wpa_supplicant.conf` when creating it:

    ```
    export SSID=your_ssid_here
    export WIFIPASS=your_wifi_password_here
    ```
1. Run the script: 
    `./update-rpi-mac-linux.sh`
1. If all goes well, the script will report: 
    `-- Files updated and ready for Wifi and SSH over USB --`
1. Eject the SD card safely, insert into your Pi, and reboot. If the Pi is connected over USB to your host, and/or if the Wifi setup went correctly, you should be able to `ssh pi@raspberrypi.local`. The default password is `raspberry`. 

    > Note: If you receive an error indicating that the host id has changed, edit your computer's `~/.ssh/known_hosts` file. Find the line with the IP address of your Pi, or labeled "raspberrypi.local" and delete the entire line. You're especially likely to encounter this error if you're following these instructions for a second time.

## Manual/other resources

* [Gist (text file) showing example steps to setup USB networking](https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a)

If manually configuring the Pi vs using the update script, be sure to delete the `init=/usr/lib/raspi-config/init_resize.sh` parameter from cmdline.txt to prevent the os partition from being expanded to fill the drive.

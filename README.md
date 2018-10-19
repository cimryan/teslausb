# teslausb

## Meta
This repo contains steps and scripts originally from [this thread on Reddit]( https://www.reddit.com/r/teslamotors/comments/9m9gyk/build_a_smart_usb_drive_for_your_tesla_dash_cam/)

Many people in that thread suggested that the scripts be hosted on Github but the author didn't seem interested in making that happen. I've hosted the scripts here with his/her permission.

The original post on Reddit assumed that the archive would be hosted on Windows and that the Pi would be set up using a Windows machine but this Git repo welcomes the contribution of instructions for other platforms.

## Intro

You can configure a Raspberry Pi Zero W so that your Tesla thinks it's a USB drive and will write dashcam footage to it. Since it's a computer, you can run scripts on the Pi to automatically copy the clips to an archive server when you get home. The Pi is going to continually:
1. Wait until it can connect to the archive server
1. Archive the clips
1. Wait until it can't connect to the archive server
1. GOTO 1.

The scripts in this repo will also allow you to use the Pi to store music that the Tesla can read through the USB interface.

## Prerequisites

### Assumptions
* You park in range of your wireless network.
* Your wireless network is configured with WPA2 PSK access.
* You'll be archiving your dashcam clips to a Windows machine, and the Windows machine has a stable IP address on your home network. 
* You'll be setting up the Raspberry Pi using a Windows machine.

### Hardware

Required:
* [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/):  [Adafruit](https://www.adafruit.com/product/3400) or [Amazon](https://www.amazon.com/Raspberry-Pi-Zero-Wireless-model/dp/B06XFZC3BX/)
  > Note: Of the many varieties of Raspberry Pi only the Raspberry Pi Zero and Raspberry Pi Zero W can be used as simulated USB drives. It may be possible to use a Pi Zero with a USB Wifi adapter to achieve the same result as the Pi Zero W, but this hasn't been confirmed.

* A Micro SD card, at least 8 GB in size, and an adapter (if necessary) to connect the card to your computer.
* A USB A/Micro B cable: [Adafruit](https://www.adafruit.com/product/898) or [Amazon](https://www.amazon.com/gp/product/B013G4EAEI/)

Recommended: These will allow you to set up the Raspberry Pi without following the steps for a "headless" setup, which are a little more complicated.
* Mini HDMI to HDMI cable [Adafruit](https://www.adafruit.com/product/2775) or [Amazon](https://www.amazon.com/AmazonBasics-High-Speed-Mini-HDMI-HDMI-Cable/dp/B014I8UEGY)
* A USB keyboard.
* A micro USB power cable.

Optional:
* USB A Add-on Board if you want to plug your Pi into your Tesla like a USB drive instead of using a cable. [Amazon](https://www.amazon.com/gp/product/B07BK2BR6C/)
* A case. Don't want unprotected circuits hanging about! Official case at [Adafruit](https://www.adafruit.com/product/2885) or [Amazon](https://www.amazon.com/gp/product/B06Y593MHV). There are many others to choose from. Note that the official case won't work with the USB A Add on board.
* USB Splitter if you don't want to lose a front USB port. [The Onvian Splitter](https://www.amazon.com/gp/product/B01KX4TKH6) has been reported working by multiple people on reddit. 

### Software
Download [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/)
* Note: Bittorrent is dramatically faster than direct download.
* Note: Raspbian Stretch Lite was tested by the original poster on Reddit, other varieties may work, too.

Download and install:
* [Etcher](http://etcher.io)
 
## Create your archive
### Hosting on Windows
Set up a share on a Windows (or macOS using Sharing, or Linux using Samba) machine to host the archive. These instructions assume that you created a share named "SailfishCam" on the server "Nautilus". It is recommended that you create a new user. Grant the user you'll be using read/write access to the share. These instructions will assume that the user you've created is named "sailfish" and that the password for this user is "pa$$w0rd".

Get the IP address of the archive machine. You'll need this later, so write it down, somewhere. You can do this by opening a command prompt on the archive machine and typing ipconfig. Get the IP address from the line labeled "IPv4 Address". These instructions will assume that the IP address of the archive server is 192.168.0.41.

### TODO Other hosting solutions

## Set up the Raspberry Pi
There are four phases to setting up the Pi:
1. Get the OS onto the micro sd card.
1. Get a shell on the Pi.
1. Get the scripts onto the Pi.
1. Get the Pi set up for your Tesla.

### Get the OS onto the micro SD card

[These instructions](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) tell you how to get Raspbian onto your MicroSD card. Basically:
1. Connect your SD card to your computer.
2. Use Etcher to write the zip file you downloaded to the SD card. Etcher works well and is multi-platform.
   > Note: you don't need to uncompress the zip file you downloaded.

### Get a shell on the Pi
> Regardless of which way you use to access the Pi (Keyboard+HDMI or USB networking), **before you boot the Pi for for the first time with the MicroSD inserted**, verify that the /boot/cmdline.txt file on the MicroSD does not contain the parameter "init=/usr/lib/raspi-config/init_resize.sh". Delete that entire string if present.

#### Use a monitor/keyboard/mouse 
If you have a monitor with an HDMI input, a Mini HDMI to HDMI cable, a USB keyboard and a Micro USB power cable you can hook up the devices to the Pi and configure it directly. 
1. Insert the MicroSD card into the Pi.
1. Connect the keyboard, and monitor to the Pi.
1. Connect the power supply to the Pi using the port labeld "PWR" on the circuitboard.
1. When you're prompted for the password for the user "pi" use "raspberry" without the quotes.
1. Now skip to section below titled "Get the scripts onto the Pi".

#### Windows (Setup USB Networking)

If you don't have a keyboard/HDMI setup to boot the Pi and edit/transfer files directly, you'll probably want to connect to the Pi over Wifi or USB networking. 
* Follow [these instructions](GetShellWithoutMonitorOnWindows.md), then skip down to the section titled **Set up Set up Wifi on the Pi (manually)y**. 

#### macOS or Linux (Setup Wifi or USB Networking)
* Follow [these instructions](GetShellWithoutMonitorOnLinux.md), then proceed to the section **Set up the USB Storage Functionality**.


### Set up Wifi on the Pi (manually)

If you don't yet have Wifi running from the previous section, use these instructions to get it set up. Otherwise, skip to **Set up the USB Storage Functionality**.

Now that you have an `ssh` shell on the Pi over USB networking, you can set up Wifi and continue with setup. 

1. Enter the following commands:
    ```
    sudo -i
    nano /etc/wpa_supplicant/wpa_supplicant.conf
    ```
1. Add this block to the bottom of the file specifying the actual SSID of your network and your actual PSK, keeping the quotes around both values. Note that the SSID may be case-sensitive on your network.
    ```
    network={
      ssid="SSID"
      psk="PASSWORD"
    }
    ```
1. Press Control-O, Enter to save the file.
1. Press Control-X to return to the command line.
1. Configure the wifi to ensure that your Pi has access to your network.
    ```
    wpa_cli -i wlan0 reconfigure
    ```
1. Run this command
    ```
    ifconfig wlan0
    ```
1. Verify that there's an IP address on your subnet assigned. If you don't see the IP address wait for a couple of seconds and re-run the command.

### Set up the USB Storage Functionality

Now that you have Wifi up and running, it's time to set up the USB Storage and scripts that will manage the dashcam and (optionally) music storage. 

1. SSH to the Pi and run `sudo -i`
1. Try to ping your archive server from the Pi. In this example the server is named `nautilus`.
    ```
    ping -c 3 nautilus
    ```
1. If the server can't be reached, ping its IP address:
    ```
    ping 192.168.0.41
    ```
1. If you can't ping the archive server by IP address from the Pi, you should go do whatever you need to on your network to fix that. If you can't reach the archive server by name, from the Pi but you can by IP address, then use its IP address, below, in place of its name.
1. Run these commands, subsituting your values. The last line is the percent of the drive you want to allocate for dashcam storage. The remaining percentage will be allocated for music.
    ```
    export archiveserver=Nautilus
    export sharename=SailfishCam
    export shareuser=sailfish
    export sharepassword=pa$$w0rd
    export campercent=100
    ```
1. OPTIONAL: You can choose to integrate with [Pushover](https://pushover.net) to get a push notification to your phone when the copy process is done. Depending on your wireless network speed/connection, copying files may take some time, so a push notification can help confirm that the process finished. If no files were copied (i.e. all manually saved dashcam files were already copied, no notification will be sent.). The Pushover service is free for up to 7,500 messages per month, but the [iOS](https://pushover.net/clients/ios)/[Android](https://pushover.net/clients/android) apps do have a one time cost, after a free trial period. *This also assumes your Pi is connected to a network with internet access.*

    * Create a free account at Pushover.net, and install and log into the mobile Pushover app. 
    * On the Pushover dashboard on the web, copy your **User key**. 
    * [Create a new Application](https://pushover.net/apps/build) at Pushover.net. The description and icon don't matter, choose what you prefer. 
    * Copy the **Application Key** for the application you just created. The User key + Application Key are basically a username/password combination to needed to send the push. 
    * Run these commands, substituting your user key and app key in the appropriate places. No `"` are needed. 
    ```
    export pushover_enabled=true
    export pushover_user_key=put_your_userkey_here
    export pushover_app_key=put_your_appkey_here
    ```
1. Run these commands:
    ```
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/windows_archive/setup-teslausb
    chmod +x setup-teslausb
    ./setup-teslausb
    ```
1. Run this command:
    ```
    reboot
    ```

After reboot, the Pi hostname will become `teslausb`, so future `ssh` sessions will be `ssh pi@teslausb.local`. 

### Get the Pi set up for your Tesla.
If you set up the Pi with a keyboard and a monitor disconnect it and connect it to a PC. If you're using a cable be sure to use the port labeled "USB" on the circuitboard. 
1. Wait for the Pi to show up on the PC as a USB drive.
1. Create a directory named TeslaCam at the root of the drive labeled CAM.
1. Copy any music you'd like to the drive labeled MUSIC.
1. Eject the drives.
1. Unplug the Pi from the PC.
1. Plug the Pi into your Tesla.

## Making changes to the system after setup
The setup process configures the Pi with read-only file systems for the operating system but with read-write access through the USB
 interface. This means that you'll be able to record dashcam video and add and remove music files but you won't be able to make changes 
 to files on / or on /boot. This is to protect against corruption of the operating system when the Tesla cuts power to the Pi.

To make changes to the system partitions:
```
ssh pi@teslausb.
sudo -i
mount / -o remount,rw
mount /boot -o remount,rw
```
A script has been provided as `/root/remountfs_rw` to run the mount commands for you more easily. 

Then make whatever changes you need to. The next time the system boots the partitions will once again be read-only.

# teslausb

## Meta
This repo contains steps and scripts originally from [this thread on Reddit]( https://www.reddit.com/r/teslamotors/comments/9m9gyk/build_a_smart_usb_drive_for_your_tesla_dash_cam/)

Many people in that thread suggested that the scripts be hosted on Github but the author didn't seem interested in making that happen. I've hosted the scripts here with his/her permission.

## Intro

You can configure a Raspberry Pi Zero W so that your Tesla thinks it's a USB drive and will write dashcam footage to it. Since it's a computer:
* Scripts running on the Pi can automatically copy the clips to an archive server when you get home. 
* The Pi can hold both dashcam clips and music files.
* The Pi can automatically repair filesystem corruption produced by the Tesla's current failure to properly dismount the USB drives before cutting power to the USB ports.

Archiving the clips can take from seconds to hours depending on how many clips you've saved and how strong the WiFi signal is in your Tesla. If you find that the clips aren't getting completely transferred before the car powers down after you park or before you leave you can use the Tesla app to turn on the Climate control. This will send power to the Raspberry Pi, allowing it to complete the archival operation.

## Prerequisites

### Assumptions
* You park in range of your wireless network.
* Your wireless network is configured with WPA2 PSK access.

### Hardware

Required:
* [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/):  [Adafruit](https://www.adafruit.com/product/3400) or [Amazon](https://www.amazon.com/Raspberry-Pi-Zero-Wireless-model/dp/B06XFZC3BX/)
  > Note: Of the many varieties of Raspberry Pi avaiable only the Raspberry Pi Zero and Raspberry Pi Zero W can be used as simulated USB drives. It may be possible to use a Pi Zero with a USB Wifi adapter to achieve the same result as the Pi Zero W but this hasn't been confirmed.

* A Micro SD card, at least 8 GB in size, and an adapter (if necessary) to connect the card to your computer.
* A mechanism to connect the Pi to the Tesla. Either:
  * A USB A/Micro B cable: [Adafruit](https://www.adafruit.com/product/898) or [Amazon](https://www.amazon.com/gp/product/B013G4EAEI/), or 
  * A USB A Add-on Board if you want to plug your Pi into your Tesla like a USB drive instead of using a cable. [Amazon](https://www.amazon.com/gp/product/B07BK2BR6C/), or
  * A PCB kit if you want the lowest profile possible and you're able to solder. [Sparkfun](https://www.sparkfun.com/products/14526)

Optional:
* A case. The "Official" case: [Adafruit](https://www.adafruit.com/product/3446) or [Amazon](https://www.amazon.com/gp/product/B06Y593MHV). There are many others to choose from. Note that the official case won't work with the USB A Add-on board or the PCB kit.
* USB Splitter if you don't want to lose a front USB port. [The Onvian Splitter](https://www.amazon.com/gp/product/B01KX4TKH6) has been reported working by multiple people on reddit.

### Software
Download: [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/)

Download and install: [Etcher](http://etcher.io)
 
## Set up the Raspberry Pi
There are four phases to setting up the Pi:
1. Get the OS onto the micro sd card.
1. Get a shell on the Pi.
1. Set up the archive for dashcam clips.
1. Set up the USB storage functionality.

There is a streamlined process for setting up the Pi which can currently be used if you plan to use Windows file shares, MacOS Sharing, or Samba on Linux for your video archive. [Instructions](doc/OneStepSetup.md).

If you'd like to host the archive using another technology or would like to set the Pi up, yourself, continue these instructions. 

### Get the OS onto the MicroSD card
[These instructions](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) tell you how to get Raspbian onto your MicroSD card. Basically:
1. Connect your SD card to your computer.
2. Use Etcher to write the zip file you downloaded to the SD card.
   > Note: you don't need to uncompress the zip file you downloaded.

### Get a shell on the Pi
Follow the instructions corresponding to the OS you used to flash the OS onto the MicroSD card:
* Windows: [Instructions](doc/GetShellWithoutMonitorOnWindows.md).
* MacOS or Linux: [Instructions](doc/GetShellWithoutMonitorOnLinux.md).

Whichever instructions you followed above will leave you in a command shell on the Pi. Use this shell for the rest of the steps in these instructions.

### Set up the archive for dashcam clips
Follow the instructions corresponding to the technology you'd like to use to host the archive for your dashcam clips. You must choose just one of these technologies; don't follow more than one of these sets of instructions:
* Windows file share, MacOS Sharing, or Samba on Linux: [Instructions](doc/SetupShare.md).
* SFTP/rsync: [Instructions](doc/SetupRSync.md)
* **Experimental:** Google Drive, Amazon S3, DropBox, Microsoft OneDrive: [Instructions](doc/SetupRClone.md)

### Set up the USB storage functionality
1. Indicate how much, as a percentage, of the drive you want to allocate to recording dashcam footage by running this command:
    ```
    export campercent=<number>
    ```
    For example, using `export campercent=100` would allocate 100% of the space to recording footage from your car, and would not create a separate music partition. `export campercent=50` would allocate half of the space for a dashcam footage drive and allocates the other half to for a music storage drive.
1. If you'd like to receive a text message when your Pi finishes archiving clips follow these [Instructions](doc/ConfigureNotificationsForArchive.md).
1. Run these commands:
    ```
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/setup/pi/setup-teslausb
    chmod +x setup-teslausb
    ./setup-teslausb
    ```
1. Run this command:
    ```
    halt
    ```
1. Disconnect the Pi from the computer.

On the next boot, the Pi hostname will become `teslausb`, so future `ssh` sessions will be `ssh pi@teslausb.local`. 

Your Pi is now ready to be plugged into your Tesla. If you want to add music to the Pi, follow the instructions in the next section.

## Optional: Add music to the Pi
> Note: If you set `campercent` to `100` then skip this step.

Connect the Pi to a computer. If you're using a cable be sure to use the port labeled "USB" on the circuitboard. 
1. Wait for the Pi to show up on the computer as a USB drive.
1. Copy any music you'd like to the drive labeled MUSIC.
1. Eject the drives.
1. Unplug the Pi from the computer.
1. Plug the Pi into your Tesla.

## Optional: Making changes to the system after setup
The setup process configures the Pi with read-only file systems for the operating system but with read-write
access through the USB interface. This means that you'll be able to record dashcam video and add and remove
music files but you won't be able to make changes to files on / or on /boot. This is to protect against
corruption of the operating system when the Tesla cuts power to the Pi.

To make changes to the system partitions:
```
ssh pi@teslausb.
sudo -i
/root/bin/remountfs_rw
```
Then make whatever changes you need to. The next time the system boots the partitions will once again be read-only.

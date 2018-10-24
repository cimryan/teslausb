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

Archiving the clips can take from seconds to hours depending on how many clips you've saved and how strong the WiFi signal is in your Tesla. If you find that the clips aren't getting completely transferred before the car powers down after you park or before you leave you can use the Tesla app to turn on the Climate control. This will send power to the Raspberry Pi, allowing it to complete the archival operation.

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
* A mechanism to connect the Pi to the Tesla. Either:
  * A USB A/Micro B cable: [Adafruit](https://www.adafruit.com/product/898) or [Amazon](https://www.amazon.com/gp/product/B013G4EAEI/), or 
  * A USB A Add-on Board if you want to plug your Pi into your Tesla like a USB drive instead of using a cable. [Amazon](https://www.amazon.com/gp/product/B07BK2BR6C/)

Optional:
* A case. Don't want unprotected circuits hanging about! Official case at [Adafruit](https://www.adafruit.com/product/2885) or [Amazon](https://www.amazon.com/gp/product/B06Y593MHV). There are many others to choose from. Note that the official case won't work with the USB A Add on board.
* USB Splitter if you don't want to lose a front USB port. [The Onvian Splitter](https://www.amazon.com/gp/product/B01KX4TKH6) has been reported working by multiple people on reddit.

### Software
Download [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/)
* Note: Bittorrent is dramatically faster than direct download.

Download and install:
* [Etcher](http://etcher.io)
 
## Create your archive
### Hosting on Windows
Set up a share on a Windows (or macOS using Sharing, or Linux using Samba) machine to host the archive. These instructions assume that you created a share named "SailfishCam" on the server "Nautilus". It is recommended that you create a new user. Grant the user you'll be using read/write access to the share. These instructions will assume that the user you've created is named "sailfish" and that the password for this user is "pa$$w0rd".

Get the IP address of the archive machine. You'll need this later, so write it down, somewhere. You can do this by opening a command prompt on the archive machine and typing ipconfig. Get the IP address from the line labeled "IPv4 Address". These instructions will assume that the IP address of the archive server is 192.168.0.41.

### Hosting via SFTP/rsync
Since sftp/rsync is accessing a computer through SSH, the only requirement for hosting an SFTP/rsync server is to have a box running Linux. An example can be another Raspberry Pi connected to your local network with a USB storage drive plugged in. The official Raspberry Pi site has a good example on [how to mount an external drive](https://www.raspberrypi.org/documentation/configuration/external-storage.md). You will need the username and host/IP of the storage server, as well as the path for the files to go in, and the storage server will need to allow SSH.

### ***TODO: Other hosting solutions***

## Set up the Raspberry Pi
There are three phases to setting up the Pi:
1. Get the OS onto the micro sd card.
1. Get a shell on the Pi.
1. Set up the USB storage functionality.

### Get the OS onto the micro SD card

[These instructions](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) tell you how to get Raspbian onto your MicroSD card. Basically:
1. Connect your SD card to your computer.
2. Use Etcher to write the zip file you downloaded to the SD card. Etcher works well and is multi-platform.
   > Note: you don't need to uncompress the zip file you downloaded.

### Get a shell on the Pi
If you used a Windows computer to flash the OS onto the MicroSD card, follow these [Instructions](GetShellWithoutMonitorOnWindows.md).

If you used a Mac or a Linux computer, follow these [Instructions](GetShellWithoutMonitorOnLinux.md).

### Set up the USB storage functionality

Now that you have Wifi up and running, it's time to set up the USB storage and scripts that will manage the dashcam and (optionally) music storage.

1. SSH to the Pi and run
    ```
    sudo -i
    ```
1. Try to ping your archive server from the Pi. In this example the server is named `nautilus`.
    ```
    ping -c 3 nautilus
    ```
1. If the server can't be reached, ping its IP address:
    ```
    ping 192.168.0.41
    ```
1. If you can't ping the archive server by IP address from the Pi, you should go do whatever you need to on your network to fix that. If you can't reach the archive server by name, from the Pi but you can by IP address, then use its IP address, below, in place of its name.
1. Determine how much, as a percentage, of the drive you want to allocate to recording dashcam footage by using:
    ```
    export campercent=<number>
    ```
    For example, using `export campercent=100` would allocate 100% of the space to recording footage from your car, and would not create a separate music partition. `export campercent=50` would be only allocate half of the space for a dashcam footage drive, and allocates the other half to be a music storage drive.
1. If you are trying to archive on an SFTP/rsync server, then follow these [instructions](SetupRSync.md) and skip step 7. Otherwise, skip this step.
1. If you are trying to archive on a shared drive, run these commands, subsituting your values for your shared drive:
    ```
    export archiveserver=Nautilus
    export sharename=SailfishCam
    export shareuser=sailfish
    export sharepassword=pa$$w0rd
    ```
1. If you'd like to receive a text message when your Pi finishes archiving clips follow these [Instructions](ConfigureNotificationsForArchive.md).
1. Run these commands:
    ```
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/windows_archive/setup-teslausb
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

## (Optional) Add music to the Pi
Connect the Pi to a computer. If you're using a cable be sure to use the port labeled "USB" on the circuitboard. 
1. Wait for the Pi to show up on the computer as a USB drive.
1. Copy any music you'd like to the drive labeled MUSIC.
1. Eject the drives.
1. Unplug the Pi from the PC.
1. Plug the Pi into your Tesla.

## Making changes to the system after setup
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

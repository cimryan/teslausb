# teslausb

## Meta
This repo contains steps and scripts originally from [this thread on Reddit]( https://www.reddit.com/r/teslamotors/comments/9m9gyk/build_a_smart_usb_drive_for_your_tesla_dash_cam/)

 Many people in that thread suggested that the scripts be hosted on Github but the author didn't seem interested in making that happen. I've hosted the scripts here with his/her permission.

The original post on Reddit assumed that the archive would be hosted on Windows and that the Pi would be set up using a Windows machine but this Git repo welcomes the contribution of instructions for other platforms.

TODO/Asks

* Script to make this easy to get going. Ideally supports multiple targets (see further TODO/Asks)
* Copy to AWS S3 / Google Drive / Etc
* Copy to SSH/SFTP

## Intro

You can configure a Raspberry Pi Zero W so that your Tesla thinks it's a USB drive and will write dashcam footage to it. Since it's a computer, you can run scripts on the Pi to automatically copy the clips to an archive server when you get home. The Pi is going to continually:
1. Wait until it can connect to the archive server
1. Archive the clips
1. Wait until it can't connect to the archive server
1. GOTO 1.

Disclaimer: It hasn't been confirmed that this solution will work with v9 of the Tesla software. It has been verified that when files are present in the TeslaCam directory they are archived to a server when the car gets back on the wireless network.

## Prerequisites

### Assumptions
* You park in range of your wireless network.
* Your wireless network is configured with WPA2 PSK access.
* You'll be archiving your dashcam clips to a Windows machine, and the Windows machine has a stable IP address on your home network. 
* You'll be setting up the Raspberry Pi using a Windows machine.

### Hardware

Required:
* [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/):  [Adafruit](https://www.adafruit.com/product/3400) or [Amazon](https://www.amazon.com/Raspberry-Pi-Zero-Wireless-model/dp/B06XFZC3BX/)
* A Micro SD card, at least 8 GB in size, and an adapter (if necessary) to connect the card to your computer.
* A USB A/Micro B cable: [Adafruit](https://www.adafruit.com/product/898) or [Amazon](https://www.amazon.com/gp/product/B013G4EAEI/)

  > Note: Of the many varieties of Raspberry Pi only the Raspberry Pi Zero and Raspberry Pi Zero W can be used as simulated USB drives. It may be possible to use a Pi Zero with a USB Wifi adapter to achieve the same result as the Pi Zero W, but this hasn't been confirmed.

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
Set up a share on a Windows machine to host the archive. These instructions assume that you created a share named "SailfishCam". It is recommended that you create a new user. Grant the user you'll be using read/write access to the share. These instructions will assume that the user you've created is named "sailfish" and that the password for this user is "pa$$w0rd".

Get the IP address of the archive machine. You'll need this later, so write it down, somewhere. You can do this by opening a command prompt on the archive machine and typing ipconfig. Get the IP address from the line labeled "IPv4 Address".
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
3. Plug the micro sd card into the Pi.

### Get a shell on the Pi
If you have a monitor with an hdmi input, a mini hdmi to hdmi cable, a usb keyboard and a micro usb power cable you can hook up the devices to the Pi and configure it directly. Plug it in and turn it on. When you're prompted for the password for the user "pi" use "raspberry" without the quotes. Now skip to section below titled "Get the scripts onto the Pi".

If you don't have a keyboard/HDMI setup to boot the Pi and edit/transfer files directly, you'll probably want to connect to it over USB. See the sections below for instructions.

#### Seting up the Pi without a monitor using Windows
1. Download and install:
   * [Notepad++](https://notepad-plus-plus.org/) Alternatively, any other text editor which is capable of editing files with Unix-style line endings.
   * [Putty]( https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) Note: You can paste into Putty by right-clicking. No matter where you right-click, the content will be inserted at the position of the cursor, as if you had typed it in.
1. Watch [this video](https://www.youtube.com/watch?v=xj3MPmJhAPU) The instructions from the video are recreated below, with some changes.
1. Open the config.txt file on the sd card with Notepad++
1. Add this line to the end of the file
    ``` 
    dtoverlay=dwc2
    ```
1. Add a blank line to the end of the file.
1. Open cmdline.txt with Notepad++
1. Find the word "rootwait", add this text, separated by spaces, between rootwait and the word following it:
    ```
    modules-load=dwc2,g_ether
    ```
1. Create a file named ssh (with no extension) at the root
1. Eject the sd card
1. Move the sd card to the Pi.
1. Connect a micro usb cable to the port labeled "USB" on the Raspberry Pi, and to the PC.
1. On the PC, press your Windows key, type Control Panel.
1. Open "Network and Sharing Center"
1. Click "Change adapter settings"
1. Wait for something labeled "USB Ethernet/RNDIS Gadget" to appear.
1. Launch Putty
1. In the Host Name box enter
    ```
    pi@raspberrypi.local
    ```
1. If you get an "unknown host" error message install Bonjour: https://support.apple.com/kb/DL999 and go back to step 17.
1. Password is raspberry
1. Skip down to the section titled "Get the scripts onto the Pi"

#### Seting up the Pi without a monitor using a Mac or Linux
Basically what you're doing is using the Pi's capability to emulate a network connection over USB. So you need to get the Pi (the guest) set up to load the proper modules to do so, and then connect from your machine (the host) using a shell (like iTerm+SSH on macOS). 

Here are a few ways to accomplish this
* [Gist (text file) showing example steps and discussion thread about issues, etc](https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a)
* [Script to setup the Pi for connecting over USB](https://github.com/BigNate1234/rpi-USBSSH)
   * (I.e. First write the OS image to the SD card, then this script will make the changes to the card so you can boot it and access it over the USB cable. 
   * **Assumes the SD card for the Pi is mounted at /Volumes/boot , and that you can use `sh`/`bash`**. This _should_ be the default for a Mac; if using something else, modify the script accordingly.  

### Get the scripts onto the Pi
Now that you have a shell on the Pi you can turn the Pi into a smart USB drive.
1. Enter the following command.
    ```
    sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
    ```
1. Add this block to the bottom of the file specifying the actual SSID of your network and your actual PSK, keeping the quotes around both values.
    ```
    network={
    ssid="NETWORK"
    psk="PASSWORD"
    }
    ```
1. Configure the wifi to ensure that your Pi has access to your network. Note that this command differs from what's described in the video above.
    ```
    sudo wpa_cli -i wlan0 reconfigure
    ```
1. Run this command
    ```
    ifconfig wlan0
    ```
1. Verify that there's an IP address on your subnet assigned.
1. Run:
   ```
   sudo nano /boot/cmdline.txt
   ```
1. Remove the g_ether parameter and the comma preceding it, so you have
    ```
    modules-load=dwc2
    ```
1. Figure out how much space to allocate for your usb drive. First run these command:
    ```
    size="$(($(df --output=avail / | tail -1) - 1000000))"
    echo $size
    ```
1. If the number is negative, stop; you're using a MicroSD card that's too small. Otherwise:
    ```
    sudo fallocate -l "$size"K /piusb.bin
    ```
1. Create a filesystem for the drive:
    ```
    sudo mkdosfs /piusb.bin -F 32 -I
    ```
1. Create the mount point from which the scripts will copy the clips:
    ```
    sudo mkdir /mnt/usb_share
    ```
1. Create the mount point for the network share to which the clips will be copied:
    ```
    sudo mkdir /mnt/cam_archive
    ```
1. Tell the system how to connect the mount points to actual data:
    ```
    sudo nano /etc/fstab
    ```
1. Add this line to the end of the file.
    ```
    /piusb.bin /mnt/usb_share vfat noauto,users,umask=000 0 0
    ```
1. Add this line to the end of the file. Change the IP address here (192.168.0.41) to the actual IP address of the machine hosting your archive. Change the name of the share "SailfishCam" to the actual name of the share you created. Note: This is a single line.
    ```
    //192.168.0.41/SailfishCam /mnt/cam_archive cifs vers=3,credentials=/root/.teslaCamArchiveCredentials,iocharset=utf8,file_mode=0777,dir_mode=0777 0 0
    ```
1. Create the credential file:
    ```
    sudo nano /root/.teslaCamArchiveCredentials
    ```
1. Enter this content, specifying the actual user name and password for the user you created on the archive machine:
    ```
    username=sailfish
    password=pa$$w0rd
    ```
1. Get the script which will archive the clips.
    ```
    sudo mkdir /root/bin
    sudo -i
    cd /root/bin
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/windows_archive/archive-teslacam-clips
    chmod +x archive-teslacam-clips
    exit
    ```
1. Verify that the archive server is reachable by name. Replace "archiveserver" with the actual name of your archive server.
    ```
    ping archiveserver
    ```
1. If the name isn't resolvable, try its IP address.
    ```
    ping 192.168.0.41
    ```
1. Get the script which will continually check for access to the archive server and trigger the archival:
    ```
    sudo -i
    cd /root/bin
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/windows_archive/archiveloop
    chmod +x archiveloop
    exit
    ```
1. Edit the script and replace archiveserver on line 4 with the name or IP address of your archive server.
1. Make the scripts run at startup:
    ```
    sudo nano /etc/rc.local
    ```
1. Change the very first line in the file to
    ```
    #!/bin/bash -eu
    ```
1. Add this content before the last line (exit 0):
    ```
    LOGFILE=/tmp/rc.local.log
    
    function log () {
      echo "$( date )" >> "$LOGFILE"
      echo "$1" >> "$LOGFILE"
    }

    log "Running fsck..."
    /sbin/fsck /mnt/usb_share -- -a >> "$LOGFILE" 2>&1 || echo ""
    log "Running modprobe..."
    /sbin/modprobe g_mass_storage >> "$LOGFILE" 2>&1
    log "Launching archival script..."
    /root/bin/archiveloop &
    log "All done"
1. Set the configuration for the g_mass_storage module:
    ```
    sudo -i
    cd /etc/modprobe.d
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/g_mass_storage.conf

    exit
    ```
1. Reboot the Pi:
    ```
    sudo reboot
    ```

### Get the Pi set up for your Tesla.
If you set up the Pi with a keyboard and a monitor disconnect it and connect it to a PC. If you're using a cable be sure to use the cable labeled "usb" on the circuitboard. 
1. Wait for the Pi to show up on the PC as a USB drive.
1. Create a directory named TeslaCam at the root of the drive.
1. Eject the drive.
1. Plug the Drive into your Tesla.  


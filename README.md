# teslausb
Steps and scripts for turning a Raspberry Pi into a useful USB drive for a Tesla. The original intent is to auto-copy Dashcam files to a Windows (SMB/CIFS compatible) share. 

This repo contains scripts originally from [this thread on Reddit]( https://www.reddit.com/r/teslamotors/comments/9m9gyk/build_a_smart_usb_drive_for_your_tesla_dash_cam/)

Many people in that thread suggested that the scripts be hosted on Github but the author didn't seem interested in making that happen.

I've hosted the scripts here with his/her permission.

## Hardware Suggested in Thread

> Note only the Pi Zero W and recent Pi's support the USB protocol for connecting to them as network devices. Not needed for normal operation, but it's very helpful during the setup process. 

* Raspberry Pi Zero W (low power, small, Wifi built in). 
  * [Amazon](https://www.amazon.com/Raspberry-Pi-Zero-Wireless-model/dp/B06XFZC3BX/ref=sr_1_10?s=electronics&ie=UTF8&qid=1539090493&sr=1-10&keywords=raspi+zero+w)
  * [Adafruit](https://www.adafruit.com/product/3400)
  
 * USB A to USB Micro (for power and optionally connecting to Pi Zero over USB to configure)
   * [Adafruit](https://www.adafruit.com/product/898)
   * [Example from Amazon](https://www.amazon.com/gp/product/B013G4EAEI/ref=oh_aui_detailpage_o00_s01?ie=UTF8&psc=1)
  
 * USB Splitter if you don't want to lose a front USB port
   * Onvian Splitter: [Amazon](https://www.amazon.com/gp/product/B01KX4TKH6/ref=oh_aui_detailpage_o05_s00?ie=UTF8&psc=1) - Reported working by multiple people. 

## Basic Steps

This is captured in the original Reddit post, but starting to recreate this here so the community can contribute to the scripts and setup instructions. 

1. Obtain the necessary hardware (Pi, USB cable, USB splitter if needed, SD card)
2. [Download Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/) (tested by original poster, others may work). 
3. Write the Raspbian image to the SD card. [Etcher (etcher.io)](https://etcher.io/) works well and is multi-platform.
4. If you don't have a keyboard/HDMI setup to boot the Pi and edit/transfer files directly, you'll probably want to connect to it over USB. See the section below for instructions there. 
5. Create the network destination for your Dashcam files. The original post uses a Windows share, but hopefully this repo will get updated to support other destinations.
6. Continue to follow the instructions in the Reddit post; this readme will be updated with full instructions over time. 

## Connecting to Raspberry Pi Zero W (or similar) over USB (no HDMI needed)

Basically what you're doing is using the Pi's capability to emulate a network connection over USB. So you need to get the Pi (the guest) set up to load the proper modules to do so, and then connect from your machine (the host) using a shell (like iTerm+SSH on macOS, or PuTTY on Windows). 

Here are a few ways to accomplish this
* [Gist (text file) showing example steps and discussion thread about issues, etc](https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a)
* [Script to setup the Pi for connecting over USB](https://github.com/BigNate1234/rpi-USBSSH)
   * (I.e. First write the OS image to the SD card, then this script will make the changes to the card so you can boot it and access it over the USB cable. 
   * **Assumes the SD card for the Pi is mounted at /Volumes/boot , and that you can use `sh`/`bash`**. This _should_ be the default for a Mac; if using something else, modify the script accordingly.  
* [YouTube video showing connecting using a Windows machine](https://www.youtube.com/watch?v=xj3MPmJhAPU)

## TODO/Asks

* Script to make this easy to get going. Ideally supports multiple targets (see further TODO/Asks)
* Copy to AWS S3 / Google Drive / Etc
* Copy to SSH/SFTP
* Official license? 


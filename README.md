# teslausb
Steps and scripts for turning a Raspberry Pi into a useful USB drive for a Tesla. The original intent is to auto-copy Dashcam files to a Windows (SMB/CIFS compatible) share. 

This repo contains scripts originally from [this thread on Reddit]( https://www.reddit.com/r/teslamotors/comments/9m9gyk/build_a_smart_usb_drive_for_your_tesla_dash_cam/)

Many people in that thread suggested that the scripts be hosted on Github but the author didn't seem interested in making that happen.

I've hosted the scripts here with his/her permission.

## Hardware Suggested in Thread

* Raspberry Pi Zero W (low power, small, Wifi built in)
  * [Amazon](https://www.amazon.com/Raspberry-Pi-Zero-Wireless-model/dp/B06XFZC3BX/ref=sr_1_10?s=electronics&ie=UTF8&qid=1539090493&sr=1-10&keywords=raspi+zero+w)
  * [Adafruit](https://www.adafruit.com/product/3400)
  
 * USB A to USB Micro (for power and optionally connecting to Pi Zero over USB to configure)
   * [Adafruit](https://www.adafruit.com/product/898)
   * Or similar from Amazon
  
 * USB Splitter if you don't want to lose a front USB port
   * Still some debate here on the best/working splitters 
 

## Short Instructions for connecting to Raspberry Pi Zero W (or similar) over USB (no HDMI needed)

* [Gist showing example steps](https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a)

## TODO/Asks

* Script to make this easy to get going. Ideally supports multiple targets (see further TODO/Asks)
* Copy to AWS S3 / Google Drive / Etc
* Copy to SSH/SFTP
* Official license? 


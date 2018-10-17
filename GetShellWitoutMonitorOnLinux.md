# Seting up the Pi without a monitor using a Mac or Linux
Basically what you're doing is using the Pi's capability to emulate a network connection over USB. So you need to get the Pi (the guest) set up to load the proper modules to do so, and then connect from your machine (the host) using a shell (like iTerm+SSH on macOS). 

Here are a few ways to accomplish this
* [Gist (text file) showing example steps and discussion thread about issues, etc](https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a)
* [Script to setup the Pi for connecting over USB](https://github.com/BigNate1234/rpi-USBSSH)
   * (I.e. First write the OS image to the SD card, then this script will make the changes to the card so you can boot it and access it over the USB cable. 
   * **Assumes the SD card for the Pi is mounted at /Volumes/boot , and that you can use `sh`/`bash`**. This _should_ be the default for a Mac; if using something else, modify the script accordingly.  

Be sure to delete the "init=/usr/lib/raspi-config/init_resize.sh" parameter from cmdline.txt to prevent the os partition from being expanded to fill the drive.

# Getting a shell on the Pi without a monitor using a Mac or Linux

These instructions will configure a Raspberry Pi so that you can proceed with the next step of setting it up as a smart USB drive for your Tesla. Specifically, these intructions will configure your Pi to join your wireless network and also enable you to ssh to the Pi, either over your wireless network or through a USB connection.

**Important:** Do these steps before you boot the Pi for the first time. 

1. Ensure you've flashed your Raspbian image to your SD card. 
1. If the `boot` folder isn't showing on your computer, eject and re-insert the SD card into your computer, **not the Raspberry Pi**. 
1. Change to the directory where the SD card's `boot` folder (containing `cmdline.txt`) is located. On a Mac, this will be `/Volumes/boot`. On Linux the location may vary; on recent Ubuntu installations it will be /media/$USER/boot
1. Run the following commands:
    ```
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/setup/macos_linux/setup-piForHeadlessConfig.sh
    chmod +x setup-piForHeadlessConfig.sh
    ```
1. Set your SSID (Wifi network name) and WIFIPASS environment variables. The script will insert them into the `wpa_supplicant.conf` when creating it:
    ```
    export SSID=your_ssid_here
    export WIFIPASS=your_wifi_password_here
    ```
1. If you're using a Mac, run this command
    ```
    ./setup-piForHeadlessConfig.sh /Volumes/boot
    ```
1. If you're using Ubuntu, run this command:
    ```
    ./setup-piForHeadlessConfig.sh /media/$USER/boot
    ```
    > If you're using another Linux distribution figure out the path to where the boot partitio of the SD card is mounted and specify that path, instead.
1. If all goes well, the script will report: 
    ```
    -- Files updated and ready for Wifi and SSH over USB --
    ```
1. Eject the SD card safely, insert into your Pi, and reboot. If the Pi is connected over USB to your host, and/or if the Wifi setup went correctly, you should be able to `ssh pi@raspberrypi.local`. The default password is `raspberry`. 

    > Note: If you receive an error indicating that the host id has changed, edit your computer's `~/.ssh/known_hosts` file. Find the line with the IP address of your Pi, or labeled "raspberrypi.local" and delete the entire line. You're especially likely to encounter this error if you're following these instructions for a second time.

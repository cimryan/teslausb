# Seting up the Pi without a monitor using Windows
1. Download and install: [Notepad++](https://notepad-plus-plus.org/) Alternatively, any other text editor which is capable of editing files with Unix-style line endings.
1. Optional: Watch [this video](https://www.youtube.com/watch?v=xj3MPmJhAPU) to get an idea of the process. The steps from the video are partially automated, below.
1. Remove the MicroSD card from your computer and reinsert it. Do not at any point during the setup of the USB drive allow Windows to format any partition on any drive.
1. Note that a new drive labeled "boot" has appeared on your computer. Note the drive letter of that drive.
1. Right-click on your Start menu icon and select "Windows PowerShell (Admin)".
1. Right-click the title bar of the window and select "Properties". Ensure that the "Use legacy console" checkbox is unchecked and activate the OK button. If it was checked before you unchecked it, close te PowerShell window and go back to step 3. If it wasn't, proceed onto the next step.
1. Run the following command:
    > Note: You can paste into the PowerShell window by right-clicking. The text will appear at the position of the cursor, not necessarily at the position where you click.
    ```
    Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    ```
1. Enter Y when prompted, and press Enter.
1. Run the following commands:
    ```
    cd ~
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/setup/windows/setup-piForHeadlessConfig.ps1 -OutFile setup-piForHeadlessConfig.ps1
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/setup/windows/WpaSupplicantConf.psm1 -OutFile WpaSupplicantConf.psm1
    ./setup-piForHeadlessConfig.ps1 -Verbose
    ```
1. Enter the single letter of the "boot" drive and press Enter.
1. Enter the SSID of your WiFi network and press Enter.
1. Enter the Pre-Shared Key of your WiFi network and press Enter.
1. If you want to add additional WiFi networks, execute:
    ```
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/setup/windows/add-wifi.ps1 -OutFile add-wifi.ps1
    ./add-wifi.ps1 -Verbose
    ```
1. If you will use any public or insecure networks, be sure to update your password using the instructions at the end of this document.
1. Enter the additional SSID and Pre-Shared Key of the WiFi network and repeat as necessary.
1. Eject the sd card.
1. Move the sd card to the Pi.
1. Connect a micro usb cable to the port labeled "USB" on the Raspberry Pi, and to the PC.
1. On the PC, press your Windows key, type Control Panel.
1. Open "Network and Sharing Center"
1. Click "Change adapter settings"
1. Wait for something labeled "USB Ethernet/RNDIS Gadget" to appear.
1. Enter this command in your PowerShell window:
    ```
    ssh pi@raspberrypi.local
    ```
    > Note: If you receive an error indicating that the host id has changed and you can't work around it you'll need to delete the ~\\.ssh\known_hosts file. You're especially likely to encounter this error if you're following these instructions for a second time.
1. If you get an "unknown host" error message install Bonjour: https://support.apple.com/kb/DL999 and go back to step 15.
1. You should be prompted for the password for the user "pi". Enter
    ```
    raspberry
    ```
1. Change your password! While not required, it is recommended, especially if you may be using any public or insecure WiFi connections.  To do so Enter
    ```
    passwod
    ```
1. Then enter your new password and press Enter
1. Confirm your new password and press Enter
1. If you want to change your password later, you must set the system partition to writeable with either
    ```
    /root/bin/remountfs_rw
    ```
1. or
    ```
    mount / -o remount,rw
    ```

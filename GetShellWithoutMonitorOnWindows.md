# Seting up the Pi without a monitor using Windows
1. Download and install:
   * [Notepad++](https://notepad-plus-plus.org/) Alternatively, any other text editor which is capable of editing files with Unix-style line endings.
   * [Putty]( https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) Note: You can paste into Putty by right-clicking. No matter where you right-click, the content will be inserted at the position of the cursor, as if you had typed it in.

Optional: Watch [this video](https://www.youtube.com/watch?v=xj3MPmJhAPU) to get an idea of the process. The steps from the video are partially automated, below.
1. Remove the MicroSD card from your computer and reinsert it. Do not at any point during the setup of the USB drive allow Windows to format any partition on any drive.
1. Note that a new drive labeled "boot" has appeared on your computer. Note the drive letter of that drive.
1. Right-click on your Start menu icon and select "Windows PowerShell (Admin)".
1. Run the following command:
    ```
    Set-ExecutionPolicy -Scope CurrentUser Unrestricted
    ```
1. Enter Y when prompted, and press Enter.
1. Run the following commands:
    ```
    cd ~
    wget https://raw.githubusercontent.com/cimryan/teslausb/master/windows_archive/setup-piForHeadlessConfig.ps1 -OutFile setup-piForHeadlessConfig.ps1
    ./setup-piForHeadlessConfig.ps1 -Verbose
    ```
1. Enter the single letter of the "boot" drive and press Enter.
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
1. If you get an "unknown host" error message install Bonjour: https://support.apple.com/kb/DL999 and go back to step 15.
1. You should be prompted for the password for the user "pi". Enter
    ```
    raspberry
    ```

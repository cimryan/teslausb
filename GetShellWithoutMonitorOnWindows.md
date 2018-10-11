# Seting up the Pi without a monitor using Windows
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

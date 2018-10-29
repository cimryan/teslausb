# Hosting the archive on Windows File Shares, MacOS Sharing, or Samba on Linux
Set up a share to host the archive on a computer on your home network. These instructions assume that you created a share named "SailfishCam" on the server "Nautilus".

It is recommended that you create a new user. Grant the user you'll be using read/write access to the share. These instructions will assume that the user you've created is named "sailfish" and that the password for this user is "pa$$w0rd".

Now, on the Pi:
1. Try to ping your archive server from the Pi. In this example the server is named `nautilus`.
    ```
    ping -c 3 nautilus
    ```
1. If the server can't be reached, ping its IP address (These instructions will assume that the IP address of the archive server is `192.168.0.41`.):
    ```
    ping 192.168.0.41
    ```
    To get the IP address of the archive machine:
    * On Windows: Open a PowerShell session and type `ipconfig`. Get the IP address from the line labeled "IPv4 Address". 
    * On MacOS or Linux open a terminal and type ifconfig.

    If you can't ping the archive server by IP address from the Pi, go do whatever you need to on your network to fix that.
    
    If you can't reach the archive server by name but you can by IP address then use its IP address, below, for the `archiveserver` variable.

1. Run these commands, subsituting your values:
    ```
    sudo -i
    export archiveserver="Nautilus"
    export sharename="SailfishCam"
    export shareuser="sailfish"
    export sharepassword="pa$$w0rd"
    ```

Now return to the section "Set up the USB storage functionality" in the [main instructions](/README.md).
# Introduction
This guide will show you how to use [rsync](https://rsync.samba.org/) to archive your saved TeslaCam footage on a remote storage server.

Since sftp/rsync accesses a computer through SSH the only requirement for hosting an SFTP/rsync server is to have a box running SSH. For example, you could use another Raspberry Pi connected to your local network with a USB storage drive plugged in. The official Raspberry Pi site has a good example on [how to mount an external drive](https://www.raspberrypi.org/documentation/configuration/external-storage.md).

You will need the username and host/IP of the storage server, as well as the path for the files to go in, and the storage server will need to allow SSH.

This guide makes the following assumptions:
* You are running your own ftp/rsync server that you have admin rights to, or can at least add a public key to its `~/.ssh/authorized_keys` file.
* The ftp/rsync server has rsync installed (raspbian automatically does)

# Step 1: Authentication
Similar to sftp, rsync by default uses ssh to connect to a remote server and transfer files. This guide will use a generated ssh keypair, hence the first assumption above.

1. Run these commands to to generate an ssh key for the `root` user:
   ```
   sudo -i
   ssh-keygen
   ```

1. Add the contents of the newly generated `/root/.ssh/id_rsa.pub` file from your teslausb pi to the storage server's `~/.ssh/authorized_keys` file. You can do this by connectin via ssh to the archive server from the computer you're using to set up the Pi, editing the `~/.ssh/authorized_keys` in nano, and pasting in the content of the `/root/.ssh/id_rsa.pub` file from the teslausb Pi.

1. Lastly, you will need to authorize the connection to the FTP/Rsync server and test that the key works, so try connecting to the server (through ssh), and **when you are asked if you wish to continue connecting type `yes`** 
   ```
   ssh user@archiveserver
   ```
   If you do not do this then rsync will fail to connect and thus fail to archive your clips.

# Step 2: Exports
Run this command to cause the setup processes which you'll resume in the main instructions to use rsync:

```
export ARCHIVE_SYSTEM=rsync
export RSYNC_USER=<ftp username>
export RSYNC_SERVER=<ftp IP/host>
export RSYNC_PATH=<destination path to save in>
```
Explanations for each:  
* `ARCHIVE_SYSTEM`: `rsync` for enabling rsync
* `RSYNC_USER`: The user on the FTP server
* `RSYNC_SERVER`: The IP address/hostname of the destination machine
* `RSYNC_PATH`: The path on the destination machine where the files will be saved

An example config is below:
```
export ARCHIVE_SYSTEM=rsync
export RSYNC_USER=pi
export RSYNC_SERVER=192.168.1.254
export RSYNC_PATH=/mnt/PIHDD/TeslaCam/
```
Now return to the section "Set up the USB storage functionality" in the [main instructions](../README.md).
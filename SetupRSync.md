# Introduction
This guide will show you how to utilize [rsync](https://rsync.samba.org/) to archive your saved TeslaCam footage on a remote storage server. In my case, I use this for a networked pi storage server.

This guide makes the following assumptions:
1. You are running your own ftp/rsync server that you have admin rights to, or can at least add a public key to its `~/.ssh/authorized_keys` file
2. You have **NOT** run the `setup-teslacam` script yet
# Step 1: Authentication
Similar to sftp, rsync by default utilizes ssh to connect to a remote server and transfer files. This guide will use a generated ssh keypair, hence the first assumption above.

On your teslausb pi, run `ssh-keygen` to generate an ssh key. Add the contents of the newly generated `~/.ssh/id_rsa.pub` file from your teslausb pi to the storage server's `~/.ssh/authorized_keys` file. This will allow a nice and easy connection through rsync, no passwords needed!

# Step 2: Exports
To be able to configure the teslausb pi use rsync, you'll need to export a few things. On your teslausb pi, run:

```
export RSYNC_ENABLE=true
export RSYNC_USER=<ftp username>
export RSYNC_SERVER=<ftp IP/host>
export RSYNC_PATH=<destination path to save in>
```

Explanations for each:  
* `RSYNC_ENABLE`: `true` for enabling rsync
* `RSYNC_USER`: The user on the FTP server
* `RSYNC_SERVER`: The IP address/hostname of the destination machine
* `RSYNC_PATH`: The path on the destination machine where the files will be saved

An example (of my) config is listed below:

```
export RSYNC_ENABLE=true
export RSYNC_USER=pi
export RSYNC_SERVER=192.168.1.254
export RSYNC_PATH=/mnt/PIHDD/TeslaCam/
```
***Note: RSYNC_ENABLE=true is going to disable the default archive server. Perhaps future releases will allow both to be defined and function at the same time, for redundancy, but for now just pick one that you'll want the most.***
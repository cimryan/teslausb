# Introduction

This guide will show you how to install and configure [rclone4pi](https://github.com/pageauc/rclone4pi/wiki) (based off [rclone](https://rclone.org/)) to archive your saved TeslaCam footage on a number of different remote storage services including (Google Drive, S3 and Dropbox). 

This guide assumes you have **NOT** run the `setup-teslacam` script yet

# Step 1: Install rclone4pi

The first step is to get the [rclone4pi](https://github.com/pageauc/rclone4pi/wiki) binary installed on the raspberry pi. You can do this by executing the following command:


```
curl -L https://raw.github.com/pageauc/rclone4pi/master/rclone-install.sh | bash
```

You can also install the script manually by following these [instructions](https://github.com/pageauc/rclone4pi/wiki#manual-install).


Once installed, the script will install rclone-install.sh, rclone-sync.sh and create a subfolder rpi-sync in users home eg. /home/pi

# Step 2: Configure rclone storage system

Next, run this command as root to configure a storage system.

```
rclone config
```

**Important:** Run this as root since archiveloop runs as root and the rclone config is bound to the user running the config.

This will launch an interactive setup with a series of questions. I highly recommend you look at the documents for your storage system by going to [rclone](https://rclone.org/) and selecting your storage system from the pull down menu at the stop.

I've only personally tested this with Google Drive using these [instructions](https://rclone.org/drive/). One thing to note is the importance of setting the correct [scope](https://rclone.org/drive/#scopes) you are providing access to. Carefully read the documentation on [scopes on rclone](https://rclone.org/drive/#scopes) as well as [Google Drive](https://developers.google.com/drive/api/v3/about-auth). I recommend going with drive.file scope.

**Important:** Take note of the name you used for this config. You will need it later. The rest of the document will use `gdrive` as the name since that's what I used.

# Step 3: Verify and create storage directory

Run the following command (again, as root) to see the name of the remote drive you just created.

```
rclone listremotes
```

If you don't see the name there, something went wrong and you'll likely have to go back through the config process. If all went well, use


```
rclone lsd gdrive:
```

At this point, you should not see anything if you set your scope correctly. Now we need to create a folder to put all our archives in. You can do this by running this command. I used TeslaCam but you can name it whatever you want as long as you set it in the next step below.

```
rclone mkdir gdrive:TeslaCam
```

Run this one last command again

```
rclone lsd gdrive:
```

Once you confirm that the directoy you just created is there, we're all set to move on!

# Step 4: Exports

To be able to configure the teslausb pi to use rclone, you'll need to export a few things. On your teslausb pi, run:

```
export RCLONE_ENABLE=true
export RCLONE_DRIVE=<name of drive>
export RCLONE_PATH=<path to folder>
```

An example of my config is listed below:

```
export RCLONE_ENABLE=true
export RCLONE_DRIVE=gdrive
export RCLONE_PATH=TeslaCam
```
**Note:** `RCLONE_ENABLE=true` is going to disable the default archive server. It also will **not** play nicely with `RSYNC_ENABLE=true` Perhaps future releases will allow both to be defined and function at the same time, for redundancy, but for now just pick one that you'll want the most.

You should be ready to run the setup script now, so return back to step 8 of the [Main Instructions](/README.md).
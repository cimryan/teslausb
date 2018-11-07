# Introduction

This guide will show you how to install and configure [rclone4pi](https://github.com/pageauc/rclone4pi/wiki) (based off [rclone](https://rclone.org/)) to archive your saved TeslaCam footage on one of a number of different remote storage services including Google Drive, S3 and Dropbox. 

You must perform these steps **after** getting a shell on the Pi and **before** running the `setup-teslacam` script on the Pi.

**Make sure to run  all commands in these instructions in a single command shell as root. When you return to the [Main Instructions](/README.md) continue running the commands there in this same shell.** This is necessary because:
* The `archiveloop` script runs as root and the rclone config is bound to the user running the config.
* These commands define environment variables that the main setup scripts need.

# Quick guide
These instructions will speed you through the process with good defaults. If you encounter an error, or you want to use a different config name than `gdrive` or a different folder name than `TeslaCam`, follow the detailed instuctions, below.  

1. Enter the root session if you haven't already:
   ```
   sudo -i
   ```
1. Run these commands. Specify the config name `gdrive` when prompted for the config name.
   ```
   curl -L https://raw.github.com/pageauc/rclone4pi/master/rclone-install.sh | bash
   rclone config
   ```
1. Run these commands:
   ```
   export ARCHIVE_SYSTEM=rclone
   export RCLONE_DRIVE=gdrive
   export RCLONE_PATH=TeslaCam
    
   rclone mkdir "$RCLONE_DRIVE:$RCLONE_PATH"
   rclone lsd "$RCLONE_DRIVE":
   ```
1. If you didn't encounter any error messages and you see the `TeslaCam` directory listed, stay in your `sudo -i` session  and return to the [Main Instructions](../README.md).

# Detailed instructions
## Step 1: Install rclone4pi
2. Run the following command to install rclone4pi:
    ```
    curl -L https://raw.github.com/pageauc/rclone4pi/master/rclone-install.sh | bash
    ```
    Alternatively, you can install rclone4pi manually by following these [instructions]    (https://github.com/pageauc/rclone4pi/wiki#manual-install).

# Step 2: Configure the archive
1. Run this command to configure an archive:
    ```
    rclone config
    ```
    This will launch an interactive setup with a series of questions. It is recommended that you look at the documentation for your storage system by going to [rclone](https://rclone.org/) and selecting your storage system from the pull down menu at the stop.
    
    It has been confirmed that this process works with Google Drive using these [instructions](https://rclone.org/drive/). If you are using another storage system, please feel encouraged to create an     "Issue" describing your challenges and/or your success.
    
    If you are using Google Drive it is important to set the correct [scope](https://rclone.org/drive/#scopes). Carefully read the documentation on [scopes on rclone](https://rclone.org/drive/#scopes) as well as [Google Drive](https://developers.google.com/drive/api/v3/about-auth). The `drive.file` scope is recommended.
    
    **Important:** During the `rclone config` process you will sepcify a name for the configuration. The rest of the document will assume the use of the name `gdrive`; replace this with your chosen configuration name.

1. Run this command:
   ```
   export RCLONE_DRIVE="gdrive"
   ```
# Step 3: Verify and create storage directory

1. Run the following command to see the name of the remote drive you just created.
    ```
    rclone listremotes
    ```
    If you don't see the name there, something went wrong. Go back through the `rclone config` process.
1. Run this command:
    ```
    rclone lsd "$RCLONE_DRIVE":
    ```
    You should not see any files listed. If you do then you did not set your scope correctly during the `rclone config` process.
1. Choose the name of a folder to hold the archived clips. These instructions will assume you chose the name `TeslaCam`. Substitute the name you chose for this name. Run this command:
    ```
    export RCLONE_PATH="TeslaCam"
    ```
1. Run the following command to create a folder which will hold the archived clips.
    ```
    rclone mkdir "$RCLONE_DRIVE:TeslaCam"
    ```
1. Run this command again:
    ```
    rclone lsd "$RCLONE_DRIVE":
    ```
Confirm that the directory `TeslaCam` is present. If not, start over.

# Step 4: Exports
Run this command to cause the setup processes which you'll resume in the main instructions to use rclone4pi:
```
export ARCHIVE_SYSTEM=rclone
```
Now stay in your `sudo -i` session and return to the section "Set up the USB storage functionality" in the [main instructions](../README.md).

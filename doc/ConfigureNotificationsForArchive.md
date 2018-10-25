OPTIONAL: You can choose to integrate with [Pushover](https://pushover.net) to get a push notification to your phone when the copy process is done. Depending on your wireless network speed/connection, copying files may take some time, so a push notification can help confirm that the process finished. If no files were copied (i.e. all manually saved dashcam files were already copied, no notification will be sent.). The Pushover service is free for up to 7,500 messages per month, but the [iOS](https://pushover.net/clients/ios)/[Android](https://pushover.net/clients/android) apps do have a one time cost, after a free trial period. *This also assumes your Pi is connected to a network with internet access.*

1. Create a free account at Pushover.net, and install and log into the mobile Pushover app. 
1. On the Pushover dashboard on the web, copy your **User key**. 
1. [Create a new Application](https://pushover.net/apps/build) at Pushover.net. The description and icon don't matter, choose what you prefer. 
1. Copy the **Application Key** for the application you just created. The User key + Application Key are basically a username/password combination to needed to send the push. 
1. Run these commands, substituting your user key and app key in the appropriate places. No `"` are needed. 
    ```
    export pushover_enabled=true
    export pushover_user_key=put_your_userkey_here
    export pushover_app_key=put_your_appkey_here
    ```
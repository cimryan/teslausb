#!/bin/bash -eu

function verify_configuration () {
    echo "Verifying rlcone configuration..."
    if ! [ -e "/root/.config/rclone/rclone.conf" ]
    then
        echo "STOP: rclone config was not found. did you configure rclone correctly?"
        exit 1
    fi

    if ! rclone lsd "$RCLONE_DRIVE": | grep -q "$RCLONE_PATH"
    then
        echo "STOP: Could not find the $RCLONE_DRIVE:$RCLONE_PATH"
        exit 1
    fi
}

verify_configuration
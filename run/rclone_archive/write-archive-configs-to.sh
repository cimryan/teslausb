#!/bin/bash -eu

FILE_PATH="$1"

echo "drive=$RCLONE_DRIVE" > "$FILE_PATH"
echo "path=$RCLONE_PATH" >> "$FILE_PATH"
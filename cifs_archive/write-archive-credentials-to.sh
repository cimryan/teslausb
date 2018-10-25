#!/bin/bash -eu

FILE_PATH="$1"

echo "username=$shareuser" > "$FILE_PATH"
echo "password=$sharepassword" >> "$FILE_PATH"

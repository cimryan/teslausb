#!/bin/bash -eu

local file_path="$1"

echo "username=$shareuser" > "$file_path"
echo "password=$sharepassword" >> "$file_path"

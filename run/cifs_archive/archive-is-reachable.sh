#!/bin/bash -eu

ARCHIVE_HOST_NAME="$1"

hping3 -c 1 -S -p 445 "$ARCHIVE_HOST_NAME" > /dev/null 2>&1

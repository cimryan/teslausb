#!/bin/bash -eu

ARCHIVE_HOST_NAME="$1"

ping -q -w 1 -c 1 "$ARCHIVE_HOST_NAME" > /dev/null 2>&1

#!/bin/bash -eu

echo "$(ping -c 1 -w 1 $archiveserver 2>/dev/null | head -n 1 | grep -o -e "(\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\})" | tr -d '()')"
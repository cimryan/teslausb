#!/bin/bash -eu

echo "$(hping3 -c 1 -S -p 445 -n $1 2>/dev/null | head -n 1 | grep -o -e "\W\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\})" | tr -d ' )')"
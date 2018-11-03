#!/bin/bash -eu

function check_variable () {
  local var_name="$1"
  if [ -z "${!var_name+x}" ]
  then
    setup_progress "STOP: Define the variable $var_name like this: export $var_name=value"
    exit 1
  fi
}

function check_available_space () {
  setup_progress "Verifying that there is sufficient space available on the MicroSD card..."

  local available_space="$( parted -m /dev/mmcblk0 u b print free | tail -1 | cut -d ":" -f 4 | sed 's/B//g' )"

  if [ "$available_space" -lt  4294967296 ]
  then
    setup_progress "STOP: The MicroSD card is too small."
    exit 1
  fi

  setup_progress "There is sufficient space available."
}

check_variable "campercent"

check_available_space

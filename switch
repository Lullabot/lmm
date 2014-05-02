#!/bin/bash

. config.sh
. functions.sh

if [ -z "$1" ]
then
  echo "Usage: switch-db <snapshot name>"
  exit 1
fi

check_user
snapshot_exists "$VG_PATH/$1"

if [ active == "$VG_PATH/$1" ]
then
  echo "$1 is already the currently active database."
  exit 1
fi

switch $1

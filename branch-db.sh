#!/bin/bash

. config.sh
. functions.sh

if [ -z "$1" ]
then
  echo "Usage: branch-db <snapshot name>"
  exit 1
fi

snapshot_available "$VG_PATH/$1"
check_user
branch $1

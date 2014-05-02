#!/bin/bash

branch() {
  lvcreate -s -n $1 -L2G mysql/master
  mkdir -p $VG_PATH/$1
  mount /dev/mysql/$1 $VG_PATH/$1
  ./switch-db.sh $1
}

check_user() {
  if [ $EUID -gt 0 ]
  then
    echo "This script must be run as root."
    exit 1
  fi
}

snapshot_exists() {
  if [[ ! -a "$1" ]]
  then
    echo "Snapshot $1 does not appear to exist."
    exit 1
  fi
}

snapshot_available() {
  if [[ -a "$1" ]]
  then
    echo "Snapshot $1 already exists."
    exit 1
  fi
}

snapshot_active() {
  LINK=`readlink /var/lib/mysql`
  if [ "$LINK" == "$VG_PATH/master" ]
  then
    return 0
  fi

  return 1
}

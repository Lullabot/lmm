#!/bin/bash

. config.sh

if [ -z "$1" ]
then
  echo "Usage: branch-db <snapshot name>"
  exit 1
fi

if [[ -a "$VG_PATH/$1" ]]
then
  echo "Snapshot $1 already exists."
  exit 1
fi

if [ $UID -gt 0 ]
then
  echo "This script must be run as root."
  exit 1
fi

LINK=`readlink /var/lib/mysql`
if [ "$LINK" == "$VG_PATH/master" ]
then
  service mysql stop
fi

lvcreate -s -n $1 -L2G mysql/master
mkdir -p $VG_PATH/$1
mount /dev/mysql/$1 $VG_PATH/$1
./switch-db.sh $1

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

LINK=`readlink /var/lib/mysql`
if [ "$LINK" == "$VG_PATH/master" ]
then
  service mysql stop
fi

lvcreate -s -n $1 -L2G mysql/master
mkdir -p $VG_PATH/$1
mount /dev/mysql/$1 $VG_PATH/$1
./switch-db.sh $1

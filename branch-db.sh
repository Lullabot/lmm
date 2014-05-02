#!/bin/bash

if [ -z "$1" ]
then
  echo "Usage: branch-db <snapshot name>"
  exit 1
fi

if [[ -a "/mysql/$1" ]]
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
if [ "$LINK" == "/mysql/master" ]
then
  service mysql stop
fi

lvcreate -s -n $1 -L2G mysql/master
mkdir -p /mysql/$1
mount /dev/mysql/$1 /mysql/$1
./switch-db.sh $1

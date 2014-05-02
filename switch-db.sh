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

LINK=`readlink /var/lib/mysql`
if [ "$LINK" == "$VG_PATH/$1" ]
then
  echo "$1 is already the currently active database."
  exit 1
fi

echo $LINK "is the currently active database."
service mysql stop
echo "Setting $VG_PATH/$1 as the active database."
rm /var/lib/mysql
ln -s $VG_PATH/$1 /var/lib/mysql
service mysql start

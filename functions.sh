#!/bin/bash

# Return the active LVM snapshot.
active() {
  echo `readlink /var/lib/mysql`
}

# Make sure we're running as root.
check_user() {
  if [ $EUID -gt 0 ]
  then
    echo "Linux MySQL Manager must be run as root."
    exit 1
  fi
}

# Branch a new database from the master database.
branch() {
  service mysql stop
  lvcreate -s -n $1 "/dev/$VG/master"
  mkdir -p "$VG_PATH/$1"
  fstab_add $1
  mount -a
  service mysql start
}

# Destroy a database snapshot.
destroy() {
  umount "$VG_PATH/$1"
  rmdir "$VG_PATH/$1"
  fstab_rm $1
  lvremove -f "$VG/$1"
}

fstab_definition() {
  echo -e "/dev/$VG/$1\t/$VG/$1\text4\tdefaults\t0\t0" "# MySQL database added by LMM"
}

fstab_add() {
  echo "$(fstab_definition $1)" >> /etc/fstab
}

fstab_rm() {
  grep -v "$(fstab_definition $1)" /etc/fstab > /tmp/lmm_fstab
  mv /tmp/lmm_fstab /etc/fstab
}

# Determine if a database snapshot exists.
snapshot_exists() {
  if [[ ! -a "$1" ]]
  then
    echo "Snapshot $1 does not appear to exist."
    exit 1
  fi
}

# Determine if a database snapshot can be made.
snapshot_available() {
  if [[ -a "$1" ]]
  then
    echo "Snapshot $1 already exists."
    exit 1
  fi
}

# Determine if a snapshot is active.
snapshot_active() {
  if [[ "$(active)" == "$VG_PATH/$1" ]]
  then
    return 0
  fi

  return 1
}

# Change the currently active database.
checkout() {
  echo `active` "is the currently active database."
  service mysql stop
  echo "Setting $VG_PATH/$1 as the active database."
  rm /var/lib/mysql
  ln -s $VG_PATH/$1 /var/lib/mysql
  service mysql start
}

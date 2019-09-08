#!/bin/bash

# Return the active LVM snapshot.
active() {
  echo `readlink /var/lib/mysql`
}

# Return the device node that is mounted on a given path.
device() {
  df "$1" | tail -1 | awk '{ print $1 }'
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
  DEVICE=`device "$(active)"`
  systemctl stop mysql
  lvcreate --setactivationskip n -s -K -n mysql-$1 "$DEVICE"
  mkdir -p "$VG_PATH/$1"
  fstab_add $1
  mount -a
  systemctl start mysql
}

# Destroy a database snapshot.
delete() {
  umount "$VG_PATH/$1"
  rmdir "$VG_PATH/$1"
  fstab_rm $1
  lvremove -f "$VG/mysql-$1"
}

# Display the amount of free space in the thin pool.
free() {
  PCT=`lvs $1/thinpool -odata_percent --noheadings --rows | cut -c 3-`
  echo ""
  echo "$PCT% used by MySQL databases."

  WARN=`echo "$PCT > 80" | bc`
  if [ $WARN -eq 1 ]
  then
    echo ""
    echo "WARNING: If all free space is used, the system may hang."
    echo "Delete snapshots or run fstrim-all to free space."
    echo ""
  fi
}

fstab_definition() {
  echo -e "/dev/$VG/mysql-$1\t/$VG/$1\text4\tdefaults\t0\t0" "# MySQL database added by LMM"
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

# Merge a snapshot into the currently active snapshot.
merge() {
  echo "Merging $1 into $(active)"
  systemctl stop mysql
  rsync -a --progress --delete-after "$1/" $(active)
  systemctl start mysql
  fstrim $(active)
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
  systemctl stop mysql
  echo "Setting $VG_PATH/$1 as the active database."
  rm /var/lib/mysql
  ln -s $VG_PATH/$1 /var/lib/mysql
  if [[ -x "/etc/lmm/post-checkout" ]]
  then
    /etc/lmm/post-checkout
  fi
  systemctl start mysql
}

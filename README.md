Logical MySQL Manager
=====================

A set of scripts for branching and switching active MySQL databases using LVM.

Primary Features
----------------

* Instant cloning of MySQL databases.
* Instant switching of the active MySQL database.
* Automatic handling of LVM snapshot management.

Quick start
-----------

Run ```lmm``` to see the available commands.

Setup
-----

The easiest way to get going is to use Lullabot/trusty32-lamp which includes
these commands. Otherwise, these scripts expect a thinly-provisioned LVM
volume named "master" in a "mysql" volume group.

Examples
--------

```bash
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm list
Active snapshot: /mysql/master

Database snapshots:
  master
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm branch fancy-feature
  Logical volume "fancy-feature" created
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm list
Active snapshot: /mysql/master

Database snapshots:
  fancy-feature
  master
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm switch fancy-feature
/mysql/master is the currently active database.
 * Stopping MariaDB database server mysqld                                       [ OK ]
Setting /mysql/fancy-feature as the active database.
 * Starting MariaDB database server mysqld                                       [ OK ]
 * Checking for corrupt, not cleanly closed and upgrade needing tables.
vagrant@vagrant-ubuntu-trusty-32:~$ echo 'CREATE DATABASE feature;' | mysql -u root
vagrant@vagrant-ubuntu-trusty-32:~$ echo 'SHOW DATABASES;' | mysql -u root
Database
information_schema
feature
lost+found
mysql
performance_schema
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm switch master
/mysql/fancy-feature is the currently active database.
 * Stopping MariaDB database server mysqld                                       [ OK ]
Setting /mysql/master as the active database.
 * Starting MariaDB database server mysqld                                       [ OK ]
 * Checking for corrupt, not cleanly closed and upgrade needing tables.
vagrant@vagrant-ubuntu-trusty-32:~$ echo 'SHOW DATABASES;' | mysql -u root
Database
information_schema
lost+found
mysql
performance_schema
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm list
Active snapshot: /mysql/master

Database snapshots:
  fancy-feature
  master
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm destroy fancy-feature
Are you sure you want to DESTROY fancy-feature (y/n)? y
  Logical volume "fancy-feature" successfully removed
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm list
Active snapshot: /mysql/master

Database snapshots:
  master
* branch
* list
* switch
* destroy
vagrant@vagrant-ubuntu-trusty-32:~$

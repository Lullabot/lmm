Logical MySQL Manager
=====================

A set of scripts for branching and checking out active MySQL databases using
LVM.

Primary Features
----------------

* Instant cloning of MySQL databases.
* Instant checking out of a branched MySQL database.
* Very quick merging of snapshots, using minimal disk space.
  * Note that this doesn't merge snapshot content, but replaces the content of
    the current snapshot with another.
* Automatic handling of LVM snapshot management.

Quick start
-----------

Run ```lmm``` to see the available commands.

Setup
-----

The easiest way to get going is to use https://github.com/Lullabot/trusty32-lamp
which includes these commands. Otherwise, these scripts expect a
thinly-provisioned LVM volume named "master" in a "mysql" volume group.

Examples
--------

```bash
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm status
Active snapshot: /mysql/master

Database snapshots:
  master
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm branch fancy-feature
  Logical volume "fancy-feature" created
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm status
Active snapshot: /mysql/master

Database snapshots:
  fancy-feature
  master
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm checkout fancy-feature
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
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm checkout master
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
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm merge fancy-feature
Merging /mysql/fancy-feature into /mysql/master
 * Stopping MariaDB database server mysqld                                       [ OK ]
building file list ...
103 files to consider
./
aria_log.00000001
         16,384 100%    0.00kB/s    0:00:00 (xfr#1, to-chk=101/103)
aria_log_control
             52 100%   50.78kB/s    0:00:00 (xfr#2, to-chk=100/103)
ib_logfile0
    134,217,728 100%  149.88MB/s    0:00:00 (xfr#3, to-chk=98/103)
ibdata1
     18,874,368 100%   17.91MB/s    0:00:01 (xfr#4, to-chk=96/103)
mysql/
mysql/columns_priv.MYD
              0 100%    0.00kB/s    0:00:00 (xfr#5, to-chk=90/103)
mysql/columns_priv.MYI
          4,096 100%  571.43kB/s    0:00:00 (xfr#6, to-chk=89/103)
mysql/columns_priv.frm
          8,820 100%    1.20MB/s    0:00:00 (xfr#7, to-chk=88/103)
mysql/db.MYD
              0 100%    0.00kB/s    0:00:00 (xfr#8, to-chk=87/103)
mysql/db.MYI
          2,048 100%  285.71kB/s    0:00:00 (xfr#9, to-chk=86/103)
mysql/db.frm
          9,582 100%    1.31MB/s    0:00:00 (xfr#10, to-chk=85/103)
mysql/event.MYD
              0 100%    0.00kB/s    0:00:00 (xfr#11, to-chk=84/103)
mysql/event.MYI
          2,048 100%  250.00kB/s    0:00:00 (xfr#12, to-chk=83/103)
mysql/event.frm
         10,239 100%    1.08MB/s    0:00:00 (xfr#13, to-chk=82/103)
mysql/func.MYD
              0 100%    0.00kB/s    0:00:00 (xfr#14, to-chk=81/103)
mysql/func.MYI
          1,024 100%  111.11kB/s    0:00:00 (xfr#15, to-chk=80/103)
mysql/func.frm
          8,665 100%  940.21kB/s    0:00:00 (xfr#16, to-chk=79/103)
mysql/general_log.CSM
             35 100%    3.80kB/s    0:00:00 (xfr#17, to-chk=78/103)
mysql/general_log.frm
          8,776 100%  952.26kB/s    0:00:00 (xfr#18, to-chk=76/103)
mysql/host.MYD
              0 100%    0.00kB/s    0:00:00 (xfr#19, to-chk=63/103)
mysql/host.MYI
          2,048 100%  200.00kB/s    0:00:00 (xfr#20, to-chk=62/103)
mysql/host.frm
          9,510 100%  928.71kB/s    0:00:00 (xfr#21, to-chk=61/103)
mysql/plugin.MYD
              0 100%    0.00kB/s    0:00:00 (xfr#22, to-chk=57/103)
mysql/plugin.MYI
          1,024 100%  100.00kB/s    0:00:00 (xfr#23, to-chk=56/103)
mysql/plugin.frm
          8,586 100%  838.48kB/s    0:00:00 (xfr#24, to-chk=55/103)
mysql/proc.MYD
            320 100%   28.41kB/s    0:00:00 (xfr#25, to-chk=54/103)
mysql/proc.MYI
          4,096 100%  363.64kB/s    0:00:00 (xfr#26, to-chk=53/103)
mysql/proc.frm
         10,012 100%  888.85kB/s    0:00:00 (xfr#27, to-chk=52/103)
mysql/procs_priv.MYD
              0 100%    0.00kB/s    0:00:00 (xfr#28, to-chk=51/103)
mysql/procs_priv.MYI
          4,096 100%  363.64kB/s    0:00:00 (xfr#29, to-chk=50/103)
mysql/procs_priv.frm
          8,875 100%  787.91kB/s    0:00:00 (xfr#30, to-chk=49/103)
mysql/slow_log.CSM
             35 100%    2.85kB/s    0:00:00 (xfr#31, to-chk=42/103)
mysql/slow_log.frm
          8,976 100%  674.28kB/s    0:00:00 (xfr#32, to-chk=40/103)
mysql/tables_priv.MYD
              0 100%    0.00kB/s    0:00:00 (xfr#33, to-chk=39/103)
mysql/tables_priv.MYI
          4,096 100%  307.69kB/s    0:00:00 (xfr#34, to-chk=38/103)
mysql/tables_priv.frm
          8,955 100%  672.70kB/s    0:00:00 (xfr#35, to-chk=37/103)
mysql/user.MYD
            324 100%   24.34kB/s    0:00:00 (xfr#36, to-chk=21/103)
mysql/user.MYI
          2,048 100%  153.85kB/s    0:00:00 (xfr#37, to-chk=20/103)
mysql/user.frm
         10,630 100%  798.53kB/s    0:00:00 (xfr#38, to-chk=19/103)
performance_schema/
performance_schema/cond_instances.frm
          8,624 100%  601.56kB/s    0:00:00 (xfr#39, to-chk=17/103)
performance_schema/db.opt
             61 100%    4.26kB/s    0:00:00 (xfr#40, to-chk=16/103)
performance_schema/events_waits_current.frm
          9,220 100%  409.27kB/s    0:00:00 (xfr#41, to-chk=15/103)
performance_schema/events_waits_history.frm
          9,220 100%  409.27kB/s    0:00:00 (xfr#42, to-chk=14/103)
performance_schema/events_waits_history_long.frm
          9,220 100%  409.27kB/s    0:00:00 (xfr#43, to-chk=13/103)
performance_schema/events_waits_summary_by_instance.frm
          8,878 100%  394.09kB/s    0:00:00 (xfr#44, to-chk=12/103)
performance_schema/events_waits_summary_by_thread_by_event_name.frm
          8,854 100%  393.02kB/s    0:00:00 (xfr#45, to-chk=11/103)
performance_schema/events_waits_summary_global_by_event_name.frm
          8,814 100%  391.25kB/s    0:00:00 (xfr#46, to-chk=10/103)
performance_schema/file_instances.frm
          8,654 100%  384.14kB/s    0:00:00 (xfr#47, to-chk=9/103)
performance_schema/file_summary_by_event_name.frm
          8,800 100%  343.75kB/s    0:00:00 (xfr#48, to-chk=8/103)
performance_schema/file_summary_by_instance.frm
          8,840 100%  332.03kB/s    0:00:00 (xfr#49, to-chk=7/103)
performance_schema/mutex_instances.frm
          8,684 100%  326.17kB/s    0:00:00 (xfr#50, to-chk=6/103)
performance_schema/performance_timers.frm
          8,776 100%  329.63kB/s    0:00:00 (xfr#51, to-chk=5/103)
performance_schema/rwlock_instances.frm
          8,758 100%  328.95kB/s    0:00:00 (xfr#52, to-chk=4/103)
performance_schema/setup_consumers.frm
          8,605 100%  323.20kB/s    0:00:00 (xfr#53, to-chk=3/103)
performance_schema/setup_instruments.frm
          8,637 100%  324.41kB/s    0:00:00 (xfr#54, to-chk=2/103)
performance_schema/setup_timers.frm
          8,650 100%  291.29kB/s    0:00:00 (xfr#55, to-chk=1/103)
performance_schema/threads.frm
          8,650 100%  291.29kB/s    0:00:00 (xfr#56, to-chk=0/103)
 * Starting MariaDB database server mysqld                                       [ OK ]
 * Checking for corrupt, not cleanly closed and upgrade needing tables.
vagrant@vagrant-ubuntu-trusty-32:~$ echo 'SHOW DATABASES;' | mysql -u root
Database
information_schema
feature
lost+found
mysql
performance_schema
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm status
Active snapshot: /mysql/master

Database snapshots:
  fancy-feature
  master
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm branch -d fancy-feature
Are you sure you want to DESTROY fancy-feature (y/n)? y
  Logical volume "fancy-feature" successfully removed
vagrant@vagrant-ubuntu-trusty-32:~$ sudo lmm status
Active snapshot: /mysql/master

Database snapshots:
  master
vagrant@vagrant-ubuntu-trusty-32:~$

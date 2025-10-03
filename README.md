# SELinux policy for MongoDB

This is the official SELinux policy for the MongoDB server.

Security-Enhanced Linux (SELinux) is an implementation of mandatory access controls (MAC)
in the Linux kernel, checking for allowed operations after standard discretionary access
controls (DAC) are checked.

## Scope

* policies apply to computers running RHEL7, RHEL8, and RHEL9 only.
* covers standard mongodb-server systemd based installations only.
* both community and enterprise versions are supported.

Supplied policies do not cover any daemons or tools other than mongod, such as: mongos,
mongocryptd, or mongo shell

## Installation

You will need to install following packages in order to apply this policy:

* git
* make
* checkpolicy
* policycoreutils
* selinux-policy-devel

### to apply policy:

```
git clone https://github.com/mongodb/mongodb-selinux
cd mongodb-selinux
make
sudo make install
```

### to uninstall policy:

```
sudo make uninstall
```

## Standard installation

Present SELinux policies are automatically applied when mongodb-server package is installed
on a supported system.

In order for mongod service to run, following assumptions are made:

- daemon binary is installed in `/usr/bin/mongod`
- database is located in `/var/lib/mongo`
- log file must be located in `/var/log/mongodb/`
- runtime data (PID) should be in `/var/run/mongodb/` or `/run/mongodb/`. On RHEL systems
`/var/run` is a symbolic link to `/run`. This should not be changed
- default unix socket file goes to `/tmp`, which must stay a default location provided by
operating system. It can not be a symbolic link to another location
- default user created and configured by installer is used to run service
- systemd unit file `/usr/lib/systemd/system/mongod.service` created by installer is used
to run service
- daemon should use ports provided by operating system in `mongod_port_t`, which by default
are: tcp/27017-27019,28017-28019
- when used with snmp, standard snmp ports should be used provided in `snmp_port_t`,
defaults are: tcp/199,1161,161-162 and udp/161-162. When using ports with number under 1024,
standard unix considerations are in place.


## Special Cases

There are following selinux booleans provided for use with enterprise features:

mongod_can_connect_snmp
mongod_can_connect_ldap
mongod_can_use_kerberos

These booleans are disabled by default. They can be turned on using `setsebool` command:

```
setsebool -P mongod_can_connect_snmp on
```

using `-P` switch would persist setting across reboots and re-installations

## Admin interface

SELinux "mongodb_admin" macro from reference package is not provided. Mongo daemon could
be managed by a standard superuser running in `unconfined_t` domain

# SELinux policy for MongoDB

This is an official SELinux policy for MongoDB server

## Installation

You will need to install following packages in order to apply this policy:

* git
* make
* checkpolicy
* policycoreutils

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


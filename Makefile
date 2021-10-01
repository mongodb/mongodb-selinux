# MongoDB SELinux policy
# Copyright (C) 2021  MongoDB Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

selinuxvariant = targeted
datadir = /usr/share

.PHONY: default
default: build/$(selinuxvariant)/mongodb.pp

build/$(selinuxvariant)/mongodb.pp: selinux/mongodb.te selinux/mongodb.fc
	(cd selinux; make -f /usr/share/selinux/devel/Makefile)
	mkdir -p build/$(selinuxvariant)
	mv selinux/mongodb.pp build/$(selinuxvariant)/

.PHONY: clean
clean:
	rm -rf build
	(cd selinux; make -f /usr/share/selinux/devel/Makefile clean)

.PHONY: install
install: build/$(selinuxvariant)/mongodb.pp
	cp build/$(selinuxvariant)/mongodb.pp $(datadir)/selinux/$(selinuxvariant)/mongodb.pp
	/usr/sbin/semodule --priority 200 --store $(selinuxvariant) --install $(datadir)/selinux/$(selinuxvariant)/mongodb.pp
	/sbin/fixfiles -R mongodb-enterprise-server restore || true
	/sbin/fixfiles -R mongodb-server restore || true
	/sbin/restorecon -R /var/lib/mongo || true
	/sbin/restorecon -R /run/mongodb || true

.PHONY: uninstall
uninstall:
	/usr/sbin/semodule --store $(selinuxvariant) --priority 200 --remove mongodb
	/sbin/fixfiles -R mongodb-enterprise-server restore || true
	/sbin/fixfiles -R mongodb-server restore || true
	test -d /var/lib/mongo && /sbin/restorecon -R /var/lib/mongo || true
	test -d /run/mongo && /sbin/restorecon -R /run/mongodb || true



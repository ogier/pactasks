#!/bin/bash
# Utility to generate a list of all files that are not part of a package
# Author: Spider.007 / Sjon

TMPDIR=`mktemp -d`
FILTER=$(sed '1,/^## FILTER/d' $0 | tr '\n' '|')
FILTER=${FILTER%|}

cd $TMPDIR
find /bin /boot /etc /lib /opt /sbin /usr /var | sort -u > full
pacman -Ql | tee owned_full | cut -d' ' -f2- | sed 's/\/$//' | sort -u > owned

grep -Ev "^($FILTER)" owned > owned- && mv owned- owned

echo "--- Owned, but not found:"
comm -13 full owned | while read entry
do
	echo [`grep --max-count=1 $entry owned_full|cut -d' ' -f1`] $entry
done | sort

grep -Ev "^($FILTER)" full > full- && mv full- full

echo "--- Found, but not owned:"
comm -23 full owned

rm $TMPDIR/{full,owned,owned_full} && rmdir $TMPDIR
exit $?

## FILTERED FILES / PATHS ##
/dev
/etc/ssl/certs
/etc/X11/xdm/authdir
/home
/media
/mnt
/proc
/root
/srv
/sys
/tmp
/usr/share/mime
/var/abs
/var/cache
/var/games
/var/log
/var/lib/pacman
/var/lib/mysql
/var/lib/postgres
/var/run
/var/tmp

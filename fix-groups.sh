#!/bin/bash
# Prints packages that are in groups but not on pacman, and vice versa
# Author: Alex Ogier, adapted from code by Spider.007 / Sjon

FILTER=$(sed '1,/^## FILTER/d' $0 | tr '\n' '|')
FILTER=${FILTER%|}

TMPDIR=`mktemp -d`
cd $TMPDIR

pacman -Qg | sort > installed
cut -d' ' -f1 installed | sort -u | xargs pacman -Sg  | sort > remote

echo "--- Installed packages no longer in their group on pacman:"
comm -23 installed remote

grep -Ev "^($FILTER) " installed > installed- && mv installed- installed
grep -Ev "^($FILTER) " remote > remote- && mv remote- remote

echo "--- Non-installed packages in a group that has installed packages:"
comm -13 installed remote

rm $TMPDIR/{installed,remote} && rmdir $TMPDIR
exit $?

## FILTERED GROUPS ##
gnome
gnome-extra
xorg
xorg-apps
xorg-drivers

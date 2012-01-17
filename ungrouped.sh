#!/bin/bash
# Filters grouped packages from standard in
# Author: Alex Ogier, adapted from code by Spider.007 / Sjon

FILTER=$(pacman -Qg | cut -d' ' -f2 | sort -u | tr '\n' '|')
FILTER=${FILTER%|}

grep -Ev "^($FILTER) "

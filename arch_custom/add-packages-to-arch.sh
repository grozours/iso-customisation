#!/bin/bash
pacman -Sy
pacman -S --noconfirm dialog \
gpart \
iftop \
htop \
sysstat \
tree \
zip \
unzip

# create package list
LANG=C pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > /pkglist.txt

# clean cache
pacman -Scc



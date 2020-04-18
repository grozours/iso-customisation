#!/bin/bash

iso="ubuntu-18.04.4-live-server-amd64.iso"
origin="http://ftp.belnet.be/ubuntu-releases/18.04.4/"

project="$HOME/iso-customisation/ubuntu_custom"

# create directory structure et iso file
[[ ! -d $project ]] && mkdir -p $project
[[ -d $project/work ]] && sudo rm -rf $project/work
[[ ! -d $project/work ]] && mkdir $project/work
[[ -d $project/squashfs ]] && sudo rm -rf $project/squashfs
[[ ! -d $project/squashfs ]] && mkdir $project/squashfs
[[ ! -e $project/iso/$iso ]] && wget $origin/$iso -o $project/iso/$iso

[[ ! -d /tmp/iso ]] && mkdir /tmp/iso
[[ ! -d /tmp/squashfs ]] && mkdir /tmp/squashfs

# install tools for iso manipulation
sudo apt-get install squashfs-tools schroot genisoimage

# extract from iso the content
sudo mount -o loop $project/iso/$iso /tmp/iso
sudo cp -av /tmp/iso/. $project/work
sudo umount /tmp/iso

# extract squashfs
sudo mount -t squashfs -o loop $project/work/casper/filesystem.squashfs /tmp/squashfs
sudo cp -av /tmp/squashfs/. $project/squashfs
sudo umount /tmp/squashfs

cd $project

# mount need directory for chrooted system modifications
sudo mount --bind /proc squashfs/proc
sudo mount --bind /sys squashfs/sys
sudo mount -t devpts none squashfs/dev/pts
sudo mount --bind /dev squashfs/dev
sudo mount --bind /dev/pts squashfs/dev/pts
sudo mount --bind /var/run/dbus/ squashfs/var/run/dbus/

# prepare network temporary access for chrooted system
sudo cp /etc/resolv.conf squashfs/etc/resolv.conf

# chroot into the system
sudo chroot squashfs

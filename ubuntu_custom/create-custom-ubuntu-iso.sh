#!/bin/bash

iso="ubuntu-18.04.4-live-server-amd64.iso"
origin="http://ftp.belnet.be/ubuntu-releases/18.04.4/"

# create directory structure et iso file
[[ ! -d $HOME/livecd ]] && mkdir $HOME/livecd
[[ ! -d $HOME/livecd/iso ]] && mkdir $HOME/livecd/iso
[[ ! -d $HOME/livecd/squashfs ]] && mkdir $HOME/livecd/squashfs
[[ ! -e $HOME/livecd/$iso ]] && wget $origin/$iso

[[ ! -d /tmp/iso ]] && mkdir /tmp/iso
[[ ! -d /tmp/squashfs ]] && mkdir /tmp/squashfs

# install tools for iso manipulation
sudo apt-get install squashfs-tools schroot genisoimage

# extract from iso the content
sudo mount -o loop $HOME/livecd/$iso /tmp/iso
sudo cp -av /tmp/iso/. $HOME/livecd/iso
sudo umount /tmp/iso

# extract squashfs
sudo mount -t squashfs -o loop $HOME/livecd/iso/casper/filesystem.squashfs /tmp/squashfs
sudo cp -av /tmp/squashfs/. $HOME/livecd/squashfs
sudo umount /tmp/squashfs

cd $HOME/livecd

# mount need directory for chrooted system modifications
#sudo mount --bind /proc squashfs/proc
#sudo mount --bind /sys squashfs/sys
#sudo mount -t devpts none squashfs/dev/pts
#sudo mount --bind /dev squashfs/dev
#sudo mount --bind /dev/pts squashfs/dev/pts
#sudo mount --bind /var/run/dbus/ squashfs/var/run/dbus/

# prepare network temporary access for chrooted system
sudo cp /etc/resolv.conf squashfs/etc/resolv.conf

# chroot into the system
sudo chroot squashfs

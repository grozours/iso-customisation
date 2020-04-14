#!/bin/bash

# extract squashfs
cd $HOME/arch_custom/customiso/arch/x86_64
sudo cp /etc/resolv.conf squashfs-root/etc/

montages=$(sudo mount | grep arch_custom | awk '{print $3}' | wc -l)
if [ "$montages" -ne "2" ];
then	
    sudo mount --bind /proc squashfs-root/proc
    sudo mount --bind /dev squashfs-root/dev
fi

# chroot into extracted squashfs
sudo chroot squashfs-root

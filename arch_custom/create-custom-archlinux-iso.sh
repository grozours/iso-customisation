#!/bin/bash

iso="archlinux-2020.04.01-x86_64.iso"
origin="http://archlinux.de-labrusse.fr/iso/2020.04.01/"

for montage in $(sudo mount | grep arch_custom | awk '{print $3}')
do
   sudo umount -l "$montage"
done

[[ -d $HOME/arch_custom/customiso ]] && sudo rm -rf $HOME/arch_custom/customiso
[[ ! -d /tmp/archiso ]] && mkdir /tmp/archiso
[[ ! -d $HOME/arch_custom/customiso ]] && mkdir -p $HOME/arch_custom/customiso
[[ ! -d $HOME/arch_custom/iso ]] && mkdir $HOME/arch_custom/iso
[[ ! -e $HOME/arch_custom/iso/$iso ]] && wget $origin/$iso -o $HOME/arch_custom/iso/$iso

# grab iso content to local directory
sudo mount -t iso9660 -o loop $HOME/arch_custom/iso/$iso /tmp/archiso
sudo cp -a /tmp/archiso/. $HOME/arch_custom/customiso
sudo umount /tmp/archiso

# extract squashfs
cd $HOME/arch_custom/customiso/arch/x86_64
sudo unsquashfs airootfs.sfs
sudo cp ../boot/x86_64/vmlinuz squashfs-root/boot/vmlinuz-linux
sudo cp /etc/resolv.conf squashfs-root/etc/
sudo cp $HOME/arch_custom/update-chroot-arch.sh squashfs-root/root/
sudo cp $HOME/arch_custom/add-packages-to-arch.sh squashfs-root/root/

sudo mount --bind /proc squashfs-root/proc
sudo mount --bind /dev squashfs-root/dev

# chroot into extracted squashfs
sudo chroot squashfs-root /root/update-chroot-arch.sh
sudo chroot squashfs-root /root/add-packages-to-arch.sh

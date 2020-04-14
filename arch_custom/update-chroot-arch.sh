#!/bin/bash

# populate pacman
pacman-key --init
pacman-key --populate archlinux

#pid_gpg_to_kill=$(ps -eaf | grep [gpg]-agent | awk '{print $2}')
#kill -9 $pid_gpg_to_kill

# upgrade kernel and archiso
#pacman -Syu archiso linux

# update necessary hooks for ide et usb booting
#sed -i 's/.*HOOKS=.*/HOOKS="base udev memdisk archiso_shutdown archiso archiso_loop_mnt archiso_pxe_common archiso_pxe_nbd archiso_pxe_http archiso_pxe_nfs archiso_kms block filesystems keyboard"/' /etc/mkinitcpio.conf

# rebuild kernel with new hooks
#mkinitcpio -p linux


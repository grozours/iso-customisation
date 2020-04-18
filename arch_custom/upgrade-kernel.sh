#!/bin/bash

# update necessary hooks for ide et usb booting
sed -i 's/.*HOOKS=.*/HOOKS="base udev memdisk archiso_shutdown archiso archiso_loop_mnt archiso_pxe_common archiso_pxe_nbd archiso_pxe_http archiso_pxe_nfs archiso_kms block filesystems keyboard"/' /etc/mkinitcpio.conf

# upgrade kernel and archiso
# https://bbs.archlinux.org/viewtopic.php?pid=1897394#p1897394
pacman -Syu --noconfirm archiso linux --overwrite /usr/lib\*/p11-kit-trust.so

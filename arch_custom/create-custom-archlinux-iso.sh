#!/bin/bash

iso="archlinux-2020.04.01-x86_64.iso"
origin="http://archlinux.de-labrusse.fr/iso/2020.04.01/"

project="$HOME/iso-customisation/arch_custom"

function create_CustomISO() 
{
   # create iso file
   iso_label="mycustom_iso"

   sudo xorriso -as mkisofs \
       -iso-level 3 \
       -full-iso9660-filenames \
       -volid "${iso_label}" \
       -eltorito-boot isolinux/isolinux.bin \
       -eltorito-catalog isolinux/boot.cat \
       -no-emul-boot -boot-load-size 4 -boot-info-table \
       -isohybrid-mbr $project/customiso/isolinux/isohdpfx.bin \
       -output $project/output/arch-custom.iso \
       $project/customiso
}

for montage in $(sudo mount | grep arch_custom | awk '{print $3}')
do
   sudo umount -l "$montage"
done



[[ -d $project/customiso ]] && sudo rm -rf $project/customiso
[[ ! -d /tmp/archiso ]] && mkdir /tmp/archiso
[[ ! -d $project/customiso ]] && mkdir -p $project/customiso
[[ ! -d $project/output ]] && mkdir -p $project/output
[[ ! -d $project/src ]] && mkdir $project/src
[[ ! -f $project/src/$iso ]] && wget $origin/$iso -o $project/src/$iso

# grab iso content to local directory
sudo mount -t iso9660 -o loop $project/src/$iso /tmp/archiso
sudo cp -a /tmp/archiso/. $project/customiso
sudo umount /tmp/archiso

# extract squashfs
cd $project/customiso/arch/x86_64
sudo unsquashfs airootfs.sfs
sudo cp ../boot/x86_64/vmlinuz squashfs-root/boot/vmlinuz-linux
sudo cp /etc/resolv.conf squashfs-root/etc/
sudo cp $project/update-pacman-database.sh squashfs-root/root/
sudo cp $project/upgrade-kernel.sh squashfs-root/root/
sudo cp $project/add-packages-to-arch.sh squashfs-root/root/
sudo cp $project/add-aurutils-package-for-aur.sh squashfs-root/etc/skel/
sudo cp $project/install-teamviewer.sh squashfs-root/etc/skel/
sudo cp $project/useradd.sh squashfs-root/root/

# add support service
cp $project/systemd/secure-tunnel@.service squashfs-root/etc/systemd/system/
# add config for support service
cp $project/systemd/service-tunnel@grozours.fr squashfs-root/etc/default/

sudo mount --bind /proc squashfs-root/proc
sudo mount --bind /dev squashfs-root/dev

# chroot into extracted squashfs
sudo chroot squashfs-root /root/update-pacman-database.sh
sudo chroot squashfs-root /root/add-packages-to-arch.sh
sudo chroot squashfs-root /root/useradd.sh

# install aur utils pour aur package and teamviewer install
sudo chroot squashfs-root su - archlinux /home/archlinux/add-aurutils-package-for-aur.sh
sudo chroot squashfs-root su - archlinux /home/archlinux/install-teamviewer.sh

# create update kernel and move new kernel from squashfs to new iso directory
sudo chroot squashfs-root /root/upgrade-kernel.sh
sudo mv squashfs-root/boot/vmlinuz-linux $project/customiso/arch/boot/x86_64/vmlinuz
sudo mv squashfs-root/boot/initramfs-linux.img $project/customiso/arch/boot/x86_64/archiso.img
sudo rm squashfs-root/boot/initramfs-linux-fallback.img

# mv package list from squashfs to new iso directory
sudo mv squashfs-root/pkglist.txt $project/customiso/arch/pkglist.x86_64.txt

# umount dev proc chroot before make new squashfs
cd $project/customiso/arch/x86_64
sudo umount -l squashfs-root/proc
sudo umount -l squashfs-root/dev

# recreate squashfs file
sudo rm airootfs.sfs
sudo mksquashfs squashfs-root airootfs.sfs

# create new iso file
cd $project/customiso
sudo rm -rf arch/x86_64/squashfs-root
sudo rm -f arch-custom.iso

create_CustomISO

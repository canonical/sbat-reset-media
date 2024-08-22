#!/bin/sh
ARCH=$1
set -e
rm -rf ubuntu-mini-iso/$ARCH
mkdir -p ubuntu-mini-iso/$ARCH/
cp -a /usr/share/cd-boot-images-$ARCH/tree ubuntu-mini-iso/$ARCH/tree
cp -a /usr/share/cd-boot-images-$ARCH/images ubuntu-mini-iso/$ARCH/images
mkdir ubuntu-mini-iso/$ARCH/tree/images
cp -a /usr/share/cd-boot-images-$ARCH/images/boot/grub ubuntu-mini-iso/$ARCH/tree/images/grub || continue
cat > ubuntu-mini-iso/$ARCH/tree/boot/grub/grub.cfg <<EOF
if [ "\$shim_lock" = "y" ]; then
    echo "This image verified correctly. Disable secure boot and boot it again to reset SBAT level"
else
    echo "The SBAT level has been reset."
    echo "Please remove the media and re-enable secure boot before booting Ubuntu"
fi
echo
echo "Entering the firmware menu in 5 seconds."
sleep 1
echo "Entering the firmware menu in 4 seconds."
sleep 1
echo "Entering the firmware menu in 3 seconds."
sleep 1
echo "Entering the firmware menu in 2 seconds."
sleep 1
echo "Entering the firmware menu in 1 seconds."
sleep 1
fwsetup
EOF
mkdir ubuntu-mini-iso/$ARCH/tree/.disk
cat > ubuntu-mini-iso/$ARCH/tree/.disk/info <<EOF
Ubuntu SBAT reset media
EOF

dest=../../sbat-reset-media-$ARCH.iso
xorriso="$(cat /usr/share/cd-boot-images-$ARCH/xorriso-cmd.txt)"

cd ubuntu-mini-iso/$ARCH
$xorriso -o $dest
cd ../..

rm -rf ubuntu-mini-iso


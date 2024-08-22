#!/bin/sh
ARCH=$1
set -e
rm -rf ubuntu-mini-iso/$ARCH
mkdir -p ubuntu-mini-iso/$ARCH/

# Log and assert (we are set -e, so if the grep fails the shell fails) that we have the right level
echo "SBAT Levels of binaries that will be used:"
objcopy  /usr/share/cd-boot-images-amd64/tree/EFI/boot/bootx64.efi unused.efi --dump-section .sbat=/dev/stdout | grep -a ^shim,4
objcopy  /usr/share/cd-boot-images-amd64/tree/EFI/boot/grubx64.efi unused.efi --dump-section .sbat=/dev/stdout | grep -a ^grub,4

# Prepare the tree
cp -a /usr/share/cd-boot-images-$ARCH/tree ubuntu-mini-iso/$ARCH/tree
cp -a /usr/share/cd-boot-images-$ARCH/images ubuntu-mini-iso/$ARCH/images
mkdir ubuntu-mini-iso/$ARCH/tree/images
cp -a /usr/share/cd-boot-images-$ARCH/images/boot/grub ubuntu-mini-iso/$ARCH/tree/images/grub || continue
cat > ubuntu-mini-iso/$ARCH/tree/boot/grub/grub.cfg <<EOF
clear
echo "Ubuntu SBAT reset media."
echo
if [ "\$shim_lock" = "y" ]; then
    echo "This image verified correctly. Disable secure boot and boot it again to reset SBAT level"
else
    echo "The SBAT level has been reset."
    echo "Please remove the media and re-enable secure boot before booting Ubuntu"
fi
echo
for i in 10 9 8 7 6 5 4 3 2 1; do
    echo "Entering the firmware menu in \$i seconds..."
    sleep 1
done
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


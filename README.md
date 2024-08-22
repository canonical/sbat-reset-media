# Ubuntu SBAT reset media

Images to reset the SBAT level on a system to be able to boot older install media.
This contains the latest Ubuntu shim and grub, and on boot guides users towards
revoking the SBAT:

1. When booted in secure boot mode, it will state that it was verified correctly,
   that the user should disable secure boot and reboot, and then launch the firmware
   setup to allow the user to disable secure boot.

2. When booted in insecure boot, it will clear the SbatLevel (as shim does on its
   own) and the grub will then print a message stating that they have been cleaned
   and to remove the media and re-enable secure boot before dropping the user into
   the firmware setup.

These images are currently in the process of being validated, check the latest
run of [the workfor main](https://github.com/canonical/sbat-reset-media/actions?query=main)
for ISO downloads.

# Ubuntu SBAT reset media

Images to reset the SBAT level on a system to be able to boot older install media.
This contains the latest Ubuntu shim and grub, and on boot guides users towards
revoking the SBAT:

1. When booted in secure boot mode, it will state that it was verified correctly,
   that the user should disable secure boot and reboot, and then launch the firmware
   setup to allow the user to disable secure boot.

   If the SBAT level was older than the so-called "previous" level, or not set
   it will also upgrade or set it. Hence you can boot it three times:

    secure -> insecure -> secure

   To revert back from the so-called "latest" level to the "previous" one, which
   is the default revocation levels of Linux distributions.

2. When booted in insecure boot, it will clear the SbatLevel (as shim does on its
   own) and the grub will then print a message stating that they have been cleaned
   and to remove the media and re-enable secure boot before dropping the user into
   the firmware setup.

These images are currently in the process of being validated, check the latest
run of [the workfor main](https://github.com/canonical/sbat-reset-media/actions?query=main)
for ISO downloads.


## How does it work?

The whole behavior is handled by shim; in fact, this is exactly the same as if you
booted an install media to grub, just that it tells you the steps by printing them
in the grub output before entering the firmware setup menu for you.

Both Windows and shim 15.8 and future versions clear the SBAT level (and the Windows
SkuSiPolicy) when booted in insecure mode to enable that easy mechanism for accidental
"over-revocation" of Windows and shims.

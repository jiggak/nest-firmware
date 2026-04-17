#!/bin/bash

# exit when any command fails
set -o errexit

BUILDROOT_DIR=$PWD/buildroot-2026.02
MODULE_INSTALL=$PWD/buildroot/board/nest/j49/rootfs_overlay

(cd linux

   # Old!!!
   # export PATH=~/Toolchains/arm-2008q3/bin:$PATH
   # PREFIX=arm-none-linux-gnueabi-

   # Less old, but still old
   # export PATH=~/x-tools/arm-unknown-linux-gnueabi/bin:$PATH
   # PREFIX=arm-unknown-linux-gnueabi-

   # Pretty old, built with crosstool-ng
   export PATH=~/x-tools/arm-cortexa8-linux-gnueabihf/bin:$PATH
   PREFIX=arm-cortexa8-linux-gnueabihf-

   if [ ! -f .config ]; then
      make ARCH=arm distclean gtvhacker_defconfig
   fi

   # Kernel panics early when built with GCC 4.9, lying robot said:
   #   Alignment fault caused by GCC 4.9 generating unaligned memory accesses
   #   incompatible with Linux 2.6.37
   # KCFLAGS="-mno-unaligned-access -fno-strict-aliasing"
   #
   # Modules failed to load with error:
   #   cfg80211: relocation out of range, section 3 reloc 0 sym 'rtnl_lock'
   # Lying robot says:
   #   Forces GCC to generate indirect calls via registers
   #   Avoid R_ARM_CALL range limits
   # KCFLAGS="-mlong-calls"
   KCFLAGS="-mlong-calls -mno-unaligned-access -fno-strict-aliasing"

   # Build kernel, modules, and install modules to buildroot rootfs_overlay
   make -j16 ARCH=arm CROSS_COMPILE=$PREFIX KCFLAGS="$KCFLAGS" modules uImage
   make ARCH=arm CROSS_COMPILE=$PREFIX INSTALL_MOD_PATH=$MODULE_INSTALL modules_install

   # Build rootfs and copy initramfs to path expected by kernel
   make -j16 -C $BUILDROOT_DIR BR2_EXTERNAL=../buildroot
   cp $BUILDROOT_DIR/output/images/rootfs.cpio ../initramfs_data.cpio

   # Build kernel again to use initramfs
   make -j16 ARCH=arm CROSS_COMPILE=$PREFIX KCFLAGS="$KCFLAGS" uImage
)

cp linux/arch/arm/boot/uImage .

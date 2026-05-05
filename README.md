# Nest OEM Details

* https://nest-open-source.googlesource.com/nest-learning-thermostat/5.9.4/x-loader
* https://nest-open-source.googlesource.com/nest-learning-thermostat/5.9.4/u-boot
* https://nest-open-source.googlesource.com/nest-learning-thermostat/5.9.4/linux
* Linux 2.6.37
* libc 2.19
* gcc 4.8.2

# TI AM3703

* https://www.ti.com/product/AM3703#software-development
* am37x-evm-sdk-src-06.00.00.00.tar.gz
* SDK code likely used by Nest when developing firmware

# Buildroot Hacking

```console
# Get buildroot source
wget https://buildroot.org/downloads/buildroot-2026.02.tar.xz
tar xf buildroot-2026.02.tar.xz

# https://buildroot.org/downloads/buildroot-2015.11.1.tar.bz2
# Last version before iptables updated from 1.4.21 to 1.6

# Path to dir with buildroot configs, root overlay, packages, etc.
export BR2_EXTERNAL=$PWD/buildroot

# Load buildroot config
make j49_defconfig
# Save changes to buildroot config
make savedefconfig BR2_DEFCONFIG=../buildroot/configs/j49_defconfig

# Open BusyBox config
make busybox-menuconfig
# Save changes to BR2_PACKAGE_BUSYBOX_CONFIG
make busybox-update-config

# Open Linux menuconfig, extra flags to get past lxdialog-check error
make HOST_EXTRACFLAGS=-Wno-implicit-int linux-menuconfig
# Save defconfig to BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE
make linux-update-defconfig
# Save .config to BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE
make linux-update-config

# Setting job number to speed up builds
make BR2_JLEVEL=16
```

# Toolchain

Latest ct-ng (1.28 at time of writing) can build GCC as old as 4.9.
OEM nest image uses GCC 4.8, so I went back to ct-ng 1.22.

The docker image is helpful to build a toolchain using an old ubunto release.
How portable are these toolchain builds? I don't know, but they seem to work
fine on my Arch system (your millage may vary).

```console
# Creates toolchain under ${OUTPUT_DIR}/arm-nest-linux-gnueabihf.
# OUTPUT_DIR is optional, defaults to ${PWD}/build
toolchain$ OUTPUT_DIR=~/Toolchains ./make.sh
```

## Using crosstool-ng

```console
# Load configuration
ct-ng defconfig DEFCONFIG=toolchain/toolchain_ct1.22_gcc4.8.config
# Save configuration
ct-ng savedefconfig DEFCONFIG=toolchain/toolchain_ct1.22_gcc4.8.config
# Build and output to $TOOLCHAINS dir
# CT_PREFIX_DIR="${TOOLCHAINS}/${CT_TARGET}"
TOOLCHAINS=~/Toolchains ct-ng build
```

# Boot with omap_loader

```console
# Boot with initramfs inside kernel
./omap_loader -f x-load.bin \
   -f u-boot.bin -a 0x80100000 \
   -f uImage -a 0x80A00000 \
   -v -j 0x80100000

# Boot with initrd, separate rootfs image
# (fixes relocation errors loading modules; when initramfs grows large)
./omap_loader \
   -f x-load.bin \
   -f u-boot.bin -a 0x80100000 \
   -f buildroot-2026.02/output/images/uImage -a 0x80A00000 \
   -f buildroot-2026.02/output/images/rootfs.cpio.uboot -a 0x82000000 \
   -v -j 0x80100000

setenv bootargs console=ttyO0,115200 rdinit=/sbin/init nlmodel=Display-2.14
bootm 0x80A00000 0x82000000
```

# Misc saved commands

```console
# Playing with docker as build env
docker run -it --rm --user 1000:100 -v "$(pwd):/work" debian:11.11 bash

# Build u-boot
make ARCH=arm CROSS_COMPILE=arm-nest-linux-gnueabihf- distclean
make ARCH=arm CROSS_COMPILE=arm-nest-linux-gnueabihf- diamond
make ARCH=arm CROSS_COMPILE=arm-nest-linux-gnueabihf-

# Build linux
make ARCH=arm distclean gtvhacker_defconfig
make ARCH=arm CROSS_COMPILE=arm-nest-linux-gnueabihf- uImage
```

# Dump and view rootfs from device flash

```console
# Host netcat to receive rootfs image
nc -l -p 51234 >root.jffs2.bz2
# Send rootfs image from device
dd bs=1M if=/dev/mtd7ro | bzip2 -c | nc 192.168.1.10 51234

# Load modules for putting rootfs image in memory as block device
modprobe mtdram total_size=65536 erase_size=128
modprobe mtdblock

# Write image and mount
dd if=backups/root_rooted.jffs2 of=/dev/mtdblock0
mount -t jffs2 /dev/mtdblock0 /mnt/nest/
```

# crosstool-ng 1.21.0 hacks

`kconfig/zconf.hash.c:41`

Change `unsigned` arg type to `size_t`

```
static struct kconf_id *kconf_id_lookup(register const char *str, register size_t len);
```

---

Fix invalid download link

`scripts/build/companion_libs/120-ppl.sh:15`

```
    CT_GetFile "ppl-${CT_PPL_VERSION}" .tar.gz \
        https://support.bugseng.com/ppl/download/ftp/releases/${CT_PPL_VERSION} \
```

---

During build, cloog-ppl will fail with autoconf version missmatch.
Re-gen autoconf stuff and resume build.

```
cd .build/src/cloog-ppl-0.15.11
	libtoolize --force
	aclocal
	autoconf
	automake --add-missing
```

# crosstool-ng 1.22.0 hacks

`scripts/build/companion_libs/121-isl.sh:17`

Fix invalid URL:
   "http://isl.gforge.inria.fr" => "https://libisl.sourceforge.io"
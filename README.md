# Nest OEM Details

* https://nest-open-source.googlesource.com/nest-learning-thermostat/5.9.4/u-boot
* https://nest-open-source.googlesource.com/nest-learning-thermostat/5.9.4/x-loader
* Linux 2.6.37
* libc 2.19
* gcc 4.8.2

# Buildroot Hacking

```console
# Get buildroot source
wget https://buildroot.org/downloads/buildroot-2026.02.tar.xz
tar xf buildroot-2026.02.tar.xz

# Path to dir with buildroot configs, root overlay, packages, etc.
export BR2_EXTERNAL=$PWD/buildroot

# Load buildroot config
make j49_defconfig
# Save changes to buildroot config
make savedefconfig BR2_DEFCONFIG=../buildroot/configs/j49_defconfig

# Open BusyBox config
make busybox-menuconfig
# Save changes to BusyBox config
make busybox-update-config

# Setting job number to speed up builds
make BR2_JLEVEL=16
```

# Toolchain

ct-ng savedefconfig DEFCONFIG=my-custom-config
ct-ng defconfig DEFCONFIG=my-custom-config
CT_PREFIX=~/Toolchains/foo

# Misc saved commands

```console
# Playing with docker as build env
docker run -it --rm --user 1000:100 -v "$(pwd):/work" debian:11.11 bash

# Build u-boot
make ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- distclean
make ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- diamond
make ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi-

# Build linux
make ARCH=arm distclean gtvhacker_defconfig
make ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- uImage

# Booting with DFU
./omap_loader -f x-load.bin \
   -f u-boot.bin -a 0x80100000 \
   -f uImage -a 0x80A00000 \
   -v -j 0x80100000
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

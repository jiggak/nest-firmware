#!/bin/bash

# Fail script if any command fails
set -e

if [ -z "${TOOLCHAIN}" -o -z "${TOOLCHAIN_PREFIX}" ]; then
   echo "TOOLCHAIN and TOOLCHAIN_PREFIX env vars required"
   exit 1
fi

export PATH=$TOOLCHAIN/bin:$PATH
OUTPUT_DIR=$PWD/build

(cd u-boot/u-boot

   FLAGS='-DNEST_BUILD_CONFIG=\"jiggak@github\"'
   make ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX distclean
   make ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX EXTRA_CPPFLAGS=$FLAGS j49
   make ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX EXTRA_CPPFLAGS=$FLAGS

   cp u-boot.bin $OUTPUT_DIR
)

(cd x-loader/x-loader

   make ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX distclean || true
   make ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX j49-usb-loader_config
   make ARCH=arm CROSS_COMPILE=$TOOLCHAIN_PREFIX HOSTCFLAGS+="-Wno-implicit-int"

   cp x-load.bin $OUTPUT_DIR
)
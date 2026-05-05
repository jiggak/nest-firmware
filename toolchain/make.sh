#!/bin/bash

IMAGE_NAME=nest-toolchain
OUTPUT_DIR=${OUTPUT_DIR:=${PWD}/build}

if [ -z "$(docker images -q $IMAGE_NAME)" ]; then
   (cd docker && docker build . -t $IMAGE_NAME)
fi

docker run -it --rm --user 1000:100 \
   -v "${OUTPUT_DIR}:/work" \
   -v "$(pwd)/toolchain_ct1.22_gcc4.8.config:/work/defconfig" \
   $IMAGE_NAME defconfig DEFCONFIG=defconfig
docker run -it --rm --user 1000:100 \
   -v "${OUTPUT_DIR}:/work" \
   -e TOOLCHAINS=/work \
   $IMAGE_NAME build
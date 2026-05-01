#!/bin/bash

IMAGE_NAME=nest-toolchain

if [ -z "$(docker images -q $IMAGE_NAME)" ]; then
   (cd docker && docker build . -t $IMAGE_NAME)
fi

docker run -it --rm --user 1000:100 \
   -v "$(pwd)/build:/work" \
   -v "$(pwd)/toolchain_ct1.22_gcc4.8.config:/work/my-config" \
   $IMAGE_NAME defconfig DEFCONFIG=my-config
docker run -it --rm --user 1000:100 \
   -e TOOLCHAINS=/work \
   -v "$(pwd)/build:/work" \
   $IMAGE_NAME build
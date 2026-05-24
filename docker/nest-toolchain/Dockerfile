# FROM ct-ng-legacy AS build
FROM ghcr.io/jiggak/ct-ng-legacy:latest AS build

ADD toolchain_ct1.22_gcc4.8.config /work/defconfig

RUN ct-ng defconfig DEFCONFIG=defconfig
RUN ct-ng build

FROM ubuntu:24.04

COPY --from=build /work/arm-nest-linux-gnueabihf /arm-nest-linux-gnueabihf

ENV PATH="/arm-nest-linux-gnueabihf/bin:${PATH}"

CMD ["/bin/bash"]
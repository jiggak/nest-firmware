# FROM ubuntu:18.04
FROM ubuntu:14.04

ARG CT_VERSION="1.22.0"

RUN apt-get update && apt-get install -y \
   # core build tools
   gcc g++ make \
   # download/extract toolchain
   wget xz-utils \
   # crosstool-ng
   gperf bison flex texinfo help2man patch gawk libtool automake autoconf ncurses-dev

# Download, configure, make ct-ng
RUN mkdir /crosstool-ng && \
   CT_DOWNLOAD=https://github.com/crosstool-ng/crosstool-ng/releases/download/crosstool-ng-${CT_VERSION}/crosstool-ng-${CT_VERSION}.tar.xz && \
   wget -O /tmp/crosstool-ng.tar.xz $CT_DOWNLOAD && \
   tar xf /tmp/crosstool-ng.tar.xz -C /crosstool-ng --strip-components=1 && \
   sed -i 's/http:\/\/isl.gforge.inria.fr/https:\/\/libisl.sourceforge.io/' crosstool-ng/scripts/build/companion_libs/121-isl.sh && \
   (cd /crosstool-ng && ./configure --enable-local && make)

# Include ct-ng in PATH
ENV PATH "/crosstool-ng:$PATH"

RUN useradd -u 1000 josh
RUN mkdir /work && chown 1000:100 /work

WORKDIR /work
USER 1000:100

ENTRYPOINT ["ct-ng"]

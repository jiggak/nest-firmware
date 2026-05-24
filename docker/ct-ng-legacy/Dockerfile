# FROM ubuntu:18.04
FROM ubuntu:14.04

ARG CT_VERSION="1.22.0"

ARG USERNAME=ubuntu
ARG UID=1000
ARG GID=1000

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
ENV TOOLCHAINS "/work"

RUN mkdir /work

RUN if [ "$UID" != "0" ]; then \
   useradd -u ${UID} ${USERNAME} && \
   chown ${UID}:${GID} /work; \
fi

WORKDIR /work

# non-root user required: ct-ng will error if run as root
USER ${UID}:${GID}

ENTRYPOINT ["ct-ng"]

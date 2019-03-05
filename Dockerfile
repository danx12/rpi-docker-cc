

# USAGE: docker run -it --rm -v ${PWD}:/src rpi-
# USAGE: docker run -it --rm -v ${PWD}:/src rpi-dev bash

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
	autoconf \
	automake \
	bc \
	binutils \
	bison \
	bzip2 \
	ca-certificates \
	flex \
	g++ \
	gawk \
	gcc \
	git \
	gperf \
	libtool-bin \
	make \
	ncurses-dev \
	openssl \
	patch \
	texinfo \
	wget \
	sudo \
	nano


RUN mkdir /raspberry
WORKDIR /raspberry

COPY config.gz config.gz
COPY hash.txt hash.txt

RUN git clone --progress --verbose https://github.com/raspberrypi/tools.git --depth=1 tools \
&& git clone --progress --verbose https://github.com/raspberrypi/linux linux

RUN zcat ./config.gz > ./linux/.config

ENV PATH /raspberry/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin:$PATH

WORKDIR /raspberry/linux
RUN /bin/bash -c "cat /raspberry/hash.txt | xargs -I {} git checkout --progress {} \
&& cd /raspberry/linux \
&& make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- oldconfig \
&& make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc)"

RUN mkdir /src
WORKDIR /src
ENV BUILD_FOLDER /src
ENV LINUX /raspberry/linux

CMD ["make"]
# Compile and install qemu_stm32
from ubuntu:18.04

# required to install tzdata
RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

RUN apt-get -y update && \
    apt-get -y install apt-transport-https ca-certificates curl software-properties-common && \
    apt-get -y install git cmake pkg-config valgrind && \
    apt-get install -y tzdata
# bigger packages
RUN apt-get -y install libglib2.0-dev zlib1g libpixman-1-dev libsdl1.2-dev libgtk3.0-cil-dev libvte-dev && \
    apt-get purge -y --auto-remove
RUN dpkg-reconfigure --frontend noninteractive tzdata
# install toolchain
RUN add-apt-repository -y ppa:team-gcc-arm-embedded/ppa && \
    apt-get -y update && \
    apt-get install -y gcc-arm-embedded


RUN git clone https://github.com/beckus/qemu_stm32.git
RUN cd qemu_stm32 &&  git submodule init && git submodule update --recursive && ./configure --extra-cflags="-w" --enable-debug --target-list="arm-softmmu"
RUN cd qemu_stm32 && make && make install

# Install demos
RUN git clone https://github.com/beckus/stm32_p103_demos.git && cd stm32_p103_demos && make



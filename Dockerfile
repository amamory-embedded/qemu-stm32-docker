# Compile and install qemu_stm32
from ubuntu:18.04

# required to install tzdata
RUN export DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#qemu depedencies
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends apt-transport-https ca-certificates curl software-properties-common \
    git cmake pkg-config valgrind flex bison wget tzdata 
# bigger packages
#RUN apt-get -y install --no-install-recommends libglib2.0-dev zlib1g libpixman-1-dev libsdl1.2-dev libgtk3.0-cil-dev libvte-dev && \
#    apt-get purge -y --auto-remove
RUN dpkg-reconfigure --frontend noninteractive tzdata
#RUN apt-get install -y 

FROM python:2
RUN mkdir -p /usr/src/app/stm32
WORKDIR /usr/src/app/stm32

RUN git clone https://github.com/beckus/qemu_stm32.git
RUN cd qemu_stm32 &&  git submodule init && git submodule update --recursive
RUN cd qemu_stm32 && ./configure --extra-cflags="-w" --enable-debug --target-list="arm-softmmu"
RUN cd qemu_stm32 && make && make install

# install ARM toolchain -- old version
###RUN add-apt-repository -y ppa:team-gcc-arm-embedded/ppa && \
###    apt-get -y update && \
###    apt-get install -y gcc-arm-embedded
### install ARM toolchain -- install most updated version - v9.2x
###RUN wget --quiet --show-progress  https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/RC2.1/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2
### use ADD to cache the downloaded file
ADD https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/RC2.1/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 .
RUN mkdir /opt/gcc-arm \
    && tar xf gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 --strip 1 -C /opt/gcc-arm 
#RUN rm gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 
ENV PATH $PATH:/opt/gcc-arm/bin

# Install demos
WORKDIR /usr/src/app/stm32
RUN git clone https://github.com/beckus/stm32_p103_demos.git && cd stm32_p103_demos && make

# for STlink - libusb-1.0-0-dev was not found !!!
#RUN apt-get -y install --no-install-recommends libusb-1.0-0-dev 
RUN rm -rf /var/lib/apt/lists/* 

# install examples from the book 'Beginning STM32 : Developing with FreeRTOS, libopencm3 and GCC'
WORKDIR /usr/src/app/stm32
RUN git clone https://github.com/ve3wwg/stm32f103c8t6.git stm32-book
RUN cd stm32-book &&  git submodule update --init --recursive 
# install and configure FreeRTOS
ADD https://cfhcable.dl.sourceforge.net/project/freertos/FreeRTOS/V10.2.1/FreeRTOSv10.2.1.zip /usr/src/app/stm32/stm32-book/rtos
RUN cd /usr/src/app/stm32/stm32-book/rtos && unzip FreeRTOSv10.2.1.zip && sed -i 's/FreeRTOSv10.0.1/FreeRTOSv10.2.1/g' Project.mk
#RUN rm -rf FreeRTOSv10.2.1.zip
#RUN cd stm32-book &&  git submodule update --init --recursive && cd libopencm3 && make clobber && make -j2 & 
# compile stlink driver and examples with libopencm3
#RUN cd /usr/src/app/stm32/stm32-book/stlink && make all && make install && cd .. && make clobber && make 
RUN cd /usr/src/app/stm32/stm32-book/ && make

# setup stm32-base
WORKDIR /usr/src/app/stm32
RUN mkdir stm32-base && cd stm32-base/ && mkdir libraries  projects templates tools
# link to tool chain
RUN cd /usr/src/app/stm32/stm32-base/tools/ && ln -s /opt/gcc-arm/* . 
RUN cd /usr/src/app/stm32/stm32-base/ && git clone https://github.com/STM32-base/STM32-base.git
RUN cd /usr/src/app/stm32/stm32-base/ && git clone https://github.com/STM32-base/STM32-base-STM32Cube.git
RUN cd /usr/src/app/stm32/stm32-base/templates && git clone https://github.com/STM32-base/STM32-base-F1-template.git
RUN cd /usr/src/app/stm32/stm32-base/templates/STM32-base-F1-template/ && ln -s ../../STM32-base  &&  ln -s ../../STM32-base-STM32Cube
RUN cd /usr/src/app/stm32/stm32-base/templates/ && cp -r STM32-base-F1-template/ blink && cd blink && make

#cleaning up
RUN cd /usr/src/app/stm32 && rm -rf gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 qemu_stm32
RUN cd /usr/src/app/stm32/stm32-book/rtos && rm -rf FreeRTOSv10.2.1.zip

# setting up 
RUN echo "alias ll='ls -alFh'" >> ~/.bashrc
RUN echo "alias qemu-arm='qemu-system-arm -machine stm32-f103c8 -nographic -kernel '" >> ~/.bashrc
RUN echo "alias qemu-arm-gdb='qemu-system-arm -machine stm32-f103c8 -S -gdb tcp::1234  -kernel '" >> ~/.bashrc

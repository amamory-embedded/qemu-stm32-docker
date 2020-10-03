# docker image for STM32 Develpment

[![Docker Hub](https://img.shields.io/docker/pulls/amamory/qemu-stm32.svg?style=flat-square)](https://hub.docker.com/r/amamory/qemu-stm32/)

Dockerfile for qemu for STM32 devices on Ubuntu 18.04 including some nice programming environments, libraries, and examples such as:  
 - https://github.com/beckus/stm32_p103_demos.git
 - https://github.com/ve3wwg/stm32f103c8t6.git, from the book 'Beginning STM32 : Developing with FreeRTOS, libopencm3 and GCC'
 - https://github.com/STM32-base/STM32-base.git

## Downloading

```
$ docker pull amamory/qemu-stm32
```

## Building the Software

```
$ docker run --rm -v $PWD:/work qemu-stm32 \
  riscv32-unknown-elf-gcc -march=rv32g hello.c -o hello
```

## Running and existing example

```
$ docker run --rm amamory/qemu-stm32 /usr/local/bin/qemu-system-arm -nographic -M stm32-f103c8 -kernel /usr/src/app/stm32/stm32_p103_demos/demos/freertos_singlethread/main.bin
$ docker run --rm amamory/qemu-stm32 /usr/local/bin/qemu-system-arm -nographic -M stm32-f103c8 -kernel /usr/src/app/stm32/stm32-book/miniblink/miniblink.elf
$ docker run --rm amamory/qemu-stm32 /usr/local/bin/qemu-system-arm -nographic -M stm32-f103c8 -kernel /usr/src/app/stm32/stm32-base/templates/blink/bin/stm32_executable.elf
```

## Compiling and running your own example


```
$ docker run --rm -v $PWD:/work qemu-stm32  ./hello
```

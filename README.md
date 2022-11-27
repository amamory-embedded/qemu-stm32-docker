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

## Running and existing example

```
$ docker run --name stm32 -it --rm -v $PWD:/work amamory/qemu-stm32 qemu-system-arm \
  -M stm32-p103 -s \
  -kernel /usr/src/app/stm32/stm32_p103_demos/demos/freertos_singlethread/main.elf
```

## Debugging the example in the running container

```
$ docker exec -it stm32 arm-none-eabi-gdb  /usr/src/app/stm32/stm32_p103_demos/demos/freertos_singlethread/main.elf
```

## Building an existing example inside container

```
$ docker run -it --rm -v $PWD:/work amamory/qemu-stm32 bash 

$ make -C ./stm32_p103_demos/ clean freertos_singlethread_ALL
```

## Building your own projects

```
$ docker run -it --rm -v $PWD:/work amamory/qemu-stm32 arm-none-eabi-gcc \
  -mcpu=cortex-m3 \
  hello_app.c -o hello_app
```

## Running your own project

```
$ docker run --rm -v $PWD:/work amamory/qemu-stm32  qemu-system-arm \
  -M stm32-p103 -s \
  -kernel ./hello
```

# qemu-stm32-docker

[![Docker Hub](https://img.shields.io/docker/pulls/amamory/qemu-stm32.svg?style=flat-square)](https://hub.docker.com/r/amamory/qemu-stm32/)

Dockerfile for qemu for STM32 devices on Ubuntu 18.04


## Downloading

```
$ docker pull amamory/qemu-stm32
```

## Building the Software

```
$ docker run --rm -v $PWD:/work qemu-stm32 \
  riscv32-unknown-elf-gcc -march=rv32g hello.c -o hello
```

## Running it

```
$ docker run --rm -v $PWD:/work qemu-stm32  ./hello
```

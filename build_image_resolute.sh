#!/bin/bash

ARCH=amd64

if ! [ -z "$1" ]; then
    ARCH=$1
fi

# Docker names the armv7 platform linux/arm/v7
PLATFORM=linux/$ARCH
if [ "$ARCH" = "armv7" ]; then
    PLATFORM=linux/arm/v7
fi

docker build --file Dockerfile-resolute \
    --platform $PLATFORM \
    --build-arg ARCH=$ARCH \
    --tag ghcr.io/nfrechette/toolchain-$ARCH-resolute:v1 .

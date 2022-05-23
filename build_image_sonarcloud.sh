#!/bin/bash

ARCH=amd64

if ! [ -z "$1" ]; then
    ARCH=$1
fi

docker build --file Dockerfile-sonarcloud \
    --platform linux/$ARCH \
    --build-arg ARCH=$ARCH \
    --tag ghcr.io/nfrechette/toolchain-$ARCH-linux-sonarcloud:v1 .

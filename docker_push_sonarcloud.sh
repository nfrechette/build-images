#!/bin/bash

ARCH=amd64

if ! [ -z "$1" ]; then
    ARCH=$1
fi

docker image push ghcr.io/nfrechette/toolchain-$ARCH-linux-sonarcloud:v3

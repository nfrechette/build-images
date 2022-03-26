#!/bin/bash

# Modify these to control what project builds and what architecture to use
SRC=~/sjson-cpp
ARCH=amd64

exec docker run --rm \
    -v $SRC:/project-src:Z \
    ghcr.io/nfrechette/toolchain-$ARCH-bionic:v1 \
    "$@"

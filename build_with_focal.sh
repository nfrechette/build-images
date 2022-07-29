#!/bin/bash

# Source directory we'll map
SRC=$1

# Try and detect our architecture, we'll use it if we can
sys_info=$(uname -a)
if [[ $sys_info =~ x86_64 ]]; then
    ARCH=amd64
elif [[ $sys_info =~ arm64 ]] || [[ $sys_info =~ aarch64 ]]; then
    ARCH=arm64
else
    # If we can't detect the architecture, use amd64
    ARCH=amd64
fi

# If we specify a second argument, use it for our architecture
if ! [ -z "$2" ]; then
    ARCH=$2
fi

exec docker run -it --rm \
    -v $SRC:/project-src:Z \
    ghcr.io/nfrechette/toolchain-$ARCH-focal:v1

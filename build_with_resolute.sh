#!/bin/bash

# Usage: .\build_with_resolute.sh path/to/src/dir [arch]
# First argument is source directory we'll map
# Second argument is optional architecture to use (amd64, arm64, or armv7), if omitted, we'll use the detected architecture

# Source directory we'll map
SRC=$1

# Try and detect our architecture, we'll use it if we can
sys_info=$(uname -a)
if [[ $sys_info =~ x86_64 ]]; then
    ARCH=amd64
elif [[ $sys_info =~ arm64 ]] || [[ $sys_info =~ aarch64 ]]; then
    ARCH=arm64
elif [[ $sys_info =~ armv7 ]]; then
    ARCH=armv7
else
    # If we can't detect the architecture, use amd64
    ARCH=amd64
fi

# If we specify a second argument, use it for our architecture
if ! [ -z "$2" ]; then
    ARCH=$2
fi

# Docker names the armv7 platform linux/arm/v7
PLATFORM=linux/$ARCH
if [ "$ARCH" = "armv7" ]; then
    PLATFORM=linux/arm/v7
fi

exec docker run -it --rm \
    --platform $PLATFORM \
    -v $SRC:/project-src:Z \
    ghcr.io/nfrechette/toolchain-$ARCH-resolute:v1

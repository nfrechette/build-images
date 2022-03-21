#!/bin/bash
SRC=~/sjson-cpp
exec docker run --rm \
    -v $SRC:/project-src:Z \
    ghcr.io/nfrechette/toolchain-amd64-xenial:v1 \
    python3 make.py -compiler gcc5 -cpu x86 -build -unit_test -clean

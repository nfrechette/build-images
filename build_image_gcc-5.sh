#!/bin/bash
docker build --file Dockerfile-xenial \
    --platform linux/amd64 \
    --build-arg GCC_VERSION=5 \
    --tag ghcr.io/nfrechette/toolchain-amd64-gcc-5:v1 .

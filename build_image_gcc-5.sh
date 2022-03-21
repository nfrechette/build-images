#!/bin/bash
docker build --file Dockerfile-gcc \
    --platform linux/amd64 \
    --build-arg GCC_VERSION=5 \
    --build-arg UBUNTU_VERSION=16.04 \
    --tag ghcr.io/nfrechette/toolchain-amd64-gcc-5:v1 .

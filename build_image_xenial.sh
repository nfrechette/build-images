#!/bin/bash
docker build --file Dockerfile-xenial \
    --platform linux/amd64 \
    --tag ghcr.io/nfrechette/toolchain-amd64-xenial:v1 .

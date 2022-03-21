#!/bin/bash
docker build --build-arg GCC_VERSION=5 --build-arg UBUNTU_VERSION=16.04 -t build-images:gcc-5 .
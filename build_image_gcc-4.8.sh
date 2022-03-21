#!/bin/bash
docker build --build-arg GCC_VERSION=4.8 --build-arg UBUNTU_VERSION=16.04 -t build-images:gcc-4.8 .
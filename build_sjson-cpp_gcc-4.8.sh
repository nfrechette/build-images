#!/bin/bash
SRC=~/sjson-cpp
exec docker run --rm -v $SRC:/project-src:Z build-images:gcc-4.8 python3 make.py -compiler gcc4.8 -build -unit_test -clean
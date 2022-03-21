#!/bin/bash
SRC=~/sjson-cpp
exec docker run --rm -v $SRC:/project-src:Z build-images:gcc-4.9 python3 make.py -compiler gcc4.9 -build -unit_test -clean
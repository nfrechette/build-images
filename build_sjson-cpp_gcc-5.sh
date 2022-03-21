#!/bin/bash
SRC=~/sjson-cpp
exec docker run --rm -v $SRC:/project-src:Z build-images:gcc-5 python3 make.py -compiler gcc5 -build -unit_test -clean
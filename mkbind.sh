#!/bin/bash
set -e
set -x

dstep -o binding.d \
        /usr/include/libudev.h \
        --rename-enum-members=true \
        --package udevd \
        --comments=true \
        --global-attribute '@nogc' \
        --global-attribute 'nothrow'

cp binding.d source/udevd/binding.d
rm binding.d

#!/bin/bash
set -e
set -x

dstep -o binding.d \
        /usr/include/libudev.h \
        --rename-enum-members=true \
        --package udev \
        --comments=false \
        --global-attribute '@nogc' \
        --global-attribute 'nothrow'

cp binding.d source/udev/binding.d
rm binding.d

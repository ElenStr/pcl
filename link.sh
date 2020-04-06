#!/bin/sh

if [ "$1" != "" ]; then
    echo "Linking $1"
    clang-8 $1.asm the_lib -o $1
else 
    echo "Program file name required (without '.pcl')"
fi
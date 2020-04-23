#!/bin/sh

CLANG=clang-8 #tested with version 8.0.1
LIBFILE=edsger_lib/lib.a 

if [ "$1" != "" ]; then    
    $CLANG $1.asm $LIBFILE -o $1
else 
    echo "Program file name required (without '.pcl')"
fi
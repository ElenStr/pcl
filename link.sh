#!/bin/sh

CLANG=clang-9 #tested with versions 9.0.1 and 8.0.1
LIBFILE=edsger_lib/lib.a 

if [ "$1" != "" ]; then    
    $CLANG $1.asm $LIBFILE -o $1
else 
    echo "Program file name required (without '.pcl')"
fi
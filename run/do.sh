#!/bin/sh

if [ "$1" != "" ]; then
    echo "Compiling $1"
    ../Main.d.byte < $1 > tmp|| exit 1
    llc-9 a.ll -o a.s
    clang-8 -v a.s the_lib -o a.out
fi
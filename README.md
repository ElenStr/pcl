# pcl

Compiler implementation for [PCL](http://courses.softlab.ntua.gr/compilers/2019a/pcl2019.pdf) language in OCaml using LLVM. 
See implementation report in PCL.pdf.

## Installation
### Prerequisites
* OCaml 4.02.3 (or later but this is tested)
* ocamlbuild
* ocamlfind (tested in 1.8.1)
* menhir    (tested in 20190924)
* llvm (OCaml Module version 9.0.0)
* cmdliner  (tested in  1.0.2)

Once all packages needed in Makefile are installed (installation via opam recommended),
produce the compiler executable simply by cloning the project and running make. 

## Build Library
The pcl library functions are implented in [this repo](https://github.com/abenetopoulos/edsger_lib).
For convenience the contents of the repo are copied in folder edsger_lib. To build library functions :
'''
cd edsger_lib
./libs.sh
'''

A `lib.a` file is created and will be required later

## Run
The compiler executable is named `pclc`. Run with file as input with :
'''

./pclc path/to/program.pcl

'''
This will produce `path/to/program.asm` and `path/to/program.imm`. To see further options
run :
'''
./pclc --help
'''
Explicit program behaviour specified in greek in [language specification](http://courses.softlab.ntua.gr/compilers/2019a/pcl2019.pdf)
in chapter 4.

## Create exexcutable
To produce final executable edit `link.sh` CLANG variable appropriately (however version 8.0.1 is tested) and run :
'''
./link.sh path/to/program
'''
The executable path/to/program will be created. Alternatively run :
'''
clang path/to/program.asm edsger_lib/lib.a -o executable_name
'''



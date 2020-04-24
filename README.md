# PCL Compiler

Compiler implementation for [PCL](http://courses.softlab.ntua.gr/compilers/2019a/pcl2019.pdf) language in OCaml using LLVM. 
See implementation report in PCL.pdf in greek. 

## Build Compiler
### Prerequisites
* OCaml 4.02.3 (tested version)
* ocamlbuild (tested in 0 version)
* [ocamlfind](https://opam.ocaml.org/packages/ocamlfind/) (tested in 1.8.1)
* [menhir] (https://opam.ocaml.org/packages/menhir/menhir.20190924/) (tested in 20190924)
* llvm ([LLVM 9.0.1](https://releases.llvm.org/download.html) , OCaml [Llvm](https://opam.ocaml.org/packages/llvm/llvm.9.0.0/) package version 9.0.0)
* [cmdliner](https://opam.ocaml.org/packages/cmdliner/cmdliner.1.0.2/) (OCaml package tested in  1.0.2)

Once all packages needed in Makefile are installed (installation via [opam](https://opam.ocaml.org/) recommended),
produce the compiler executable simply by cloning the project and running make. 

## Build Library
The PCL library functions are implemented in [this repo](https://github.com/abenetopoulos/edsger_lib).
For convenience the contents of the repo are copied in folder edsger_lib. To build library functions :
```
cd edsger_lib
./libs.sh
```
A `lib.a` file is created and will be required later.

## Run
The compiler executable is named `pclc`. Run with file input :
```
./pclc path/to/program.pcl
```
This will produce `path/to/program.asm` and `path/to/program.imm`. To see further options
run :
```
./pclc --help
```
Explicit program behaviour specified in greek in [language specification](http://courses.softlab.ntua.gr/compilers/2019a/pcl2019.pdf) in chapter 4.
## Create executable
To produce final executable edit `link.sh` CLANG variable if needed (versions 8.0.1, 9.0.1 tested) and run :
```
./link.sh path/to/program
```
The executable path/to/program will be created. Alternatively run :
```
clang-9 path/to/program.asm edsger_lib/lib.a -o executable_name
```
to create the excutable and run it :
```
./executable_name
```

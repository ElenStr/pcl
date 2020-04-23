.PHONY: clean distclean


ifdef OS
   EXE=.exe
else
   EXE=
endif

EXEFILE=pclc$(EXE)
PACKAGES=llvm,llvm.analysis,str,llvm.target,llvm.scalar_opts,llvm.all_backends,cmdliner
# opam install ctypes foreign for opts


$(EXEFILE):
	ocamlbuild -use-ocamlfind -use-menhir -pkgs $(PACKAGES) src/Main.byte
	cp Main.byte $(EXEFILE)
	rm Main.byte

clean:
	ocamlbuild -clean

distclean:
	ocamlbuild -clean
	rm $(EXEFILE)
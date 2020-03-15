.PHONY: clean distclean


ifdef OS
   EXE=.exe
else
   EXE=
endif

EXEFILE=pcl$(EXE)
PACKAGES=llvm,llvm.analysis,str,llvm.executionengine,llvm.target,llvm.scalar_opts,llvm.all_backends,cmdliner
# opam install ctypes foreign for opts


$(EXEFILE):
	ocamlbuild -use-ocamlfind -use-menhir -pkgs $(PACKAGES) src/Main.byte
	#mv ./_build/Main.d.byte $(EXEFILE)

clean:
	ocamlbuild -clean

distclean:
	ocamlbuild -clean
	rm $(EXEFILE)
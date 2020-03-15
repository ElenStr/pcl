open Ocamlbuild_plugin

open Command 


let () = dispatch begin function
    | After_rules ->
      
      flag ["link"; "ocaml"; "g++"] (A"-cc");
      flag ["link"; "ocaml"; "g++"] (A"g++");  

      flag ["ocaml";"pp"; "use_camlp5"] (A"camlp5o");
      flag ["ocaml";"pp";"use_pa_extend"] (A"pa_extend.cmo");
      flag ["ocaml";"pp";"use_q_MLast"] (A"q_MLast.cmo");    
      flag ["ocaml";"pp";"use_extend"] (A"src/extend.cmo");
      flag ["ocaml";"compile";"I"] (A "-I");
      flag ["ocaml";"compile";"camlp"] (A("+camlp5"));
      dep ["ocaml"; "ocamldep"; "use_extend"] ["src/extend.cmo"];
     
    | _ -> ()
  end

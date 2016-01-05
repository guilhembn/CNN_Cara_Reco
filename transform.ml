let saveToTab = fun neurNet ->
  let filterimgs = neurNet.Computevision.filterImgs in
  let interw = neurNet.Computevision.inter_weights in
  let finalw = neurNet.Computevision.final_weights in
  
  let nbFil = Array.length filterimgs in
  let filSize = Array.length filterimgs.(0) in

  let nbNeurInt = Array.length interw in
  let imgSize = Array.length interw.(0).(0) in

  let nbNeurFin = Array.length finalw in
  
  let tab = Array.make (nbFil * filSize * filSize + nbNeurInt * nbFil * imgSize * imgSize + nbNeurInt * nbNeurFin) 0. in
  
 (*  filter_width, filter_height, filter_nb, pooled_width, pooled_height, nb_neu_inter 
  let info = (nbFil, filSize, nbNeurInt, nbLay, imgSize, nbNeurFin) in*)
  
  let avancement = ref 0 in
      
  let cpyw = fun nb ->
    tab.(!avancement) <- nb;
    avancement := !avancement + 1
  in

  let cpyw2 = fun t ->
    Array.iter cpyw t
  in

  let cpyw3 = fun t ->
    Array.iter cpyw2 t
  in

  let cpyw4 = fun t ->
    Array.iter cpyw3 t
  in

  Array.iter cpyw3 filterimgs;
  Array.iter cpyw4 interw;
  Array.iter cpyw2 finalw;
  tab;;

let tabToSave = fun tab info ->
  
  let nbFil, filSize, nbNeurInt, imgSize, nbNeurFin = info in

  let avancement = ref 0 in

  let extract = fun _ ->
    let nb = tab.(!avancement) in
    avancement := !avancement + 1;
    nb
  in

  let filterimgs = Array.init nbFil ( fun i -> Array.init filSize ( fun j -> Array.init filSize extract)) in
  let interw = Array.init nbNeurInt ( fun i -> Array.init nbFil ( fun j -> Array.init imgSize ( fun k -> Array.init imgSize  extract))) in
  let finalw = Array.init nbNeurFin ( fun i -> Array.init nbNeurInt extract) in

  let network = {Computevision.filterImgs=filterimgs; Computevision.inter_weights=interw; Computevision.final_weights=finalw} in
  network;;

let createInlinePopulation = fun info nb ->
  let population = Array.init nb (fun _ -> saveToTab (Computevision.createNetwork info)) in
  population 

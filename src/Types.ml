type typ = TYPE_none
         | TYPE_int
         | TYPE_real
         | TYPE_char
         | TYPE_bool
         | TYPE_array of
             typ * int option
         | TYPE_ptr of typ


let rec sizeOfType t =
  match t with
  | TYPE_int  -> 1
  | TYPE_real -> 1
  | TYPE_char | TYPE_bool -> 1
  | TYPE_array (dt,Some(n)) -> 1
  | TYPE_ptr dt -> 1
  | _        -> 1
let rec pcl_type_str t =
  match t with
  | TYPE_int  -> "integer"
  | TYPE_real -> "real"
  | TYPE_char -> "char"
  | TYPE_bool -> "boolean"
  | TYPE_array (dt,Some(n)) -> String.concat "" ["array(";(string_of_int n);",";(pcl_type_str dt);")"]
  | TYPE_ptr dt -> String.concat  "" ["ptr(";(pcl_type_str dt);" )"]
  | TYPE_array (dt,None) ->String.concat "" ["array( ";(pcl_type_str dt); " )"]
  | _        -> "unknown"

let rec equalType t1 t2 =
  match t1, t2 with
  | TYPE_array (et1, None), TYPE_array (et2, None) -> equalType et1 et2
  | TYPE_ptr dt1, TYPE_ptr dt2 -> equalType  dt1 dt2
  | TYPE_array (et1, Some(n1)), TYPE_array (et2, Some(n2)) -> (n1==n2) && (equalType et1 et2)
  | _-> t1 = t2 

let is_basic t =
  match t with
    ( TYPE_int|TYPE_bool|TYPE_real|TYPE_char) -> true
  | _-> false

let  rec is_complete t = 
  match t with 
  |TYPE_array (dt,None)  -> false
  |TYPE_none -> false
  |  _ -> true

let is_numerical t = 
  match t with 
    (TYPE_int | TYPE_real) -> true
  |_ ->false

let rec is_valid t =
  match t with 
  | TYPE_ptr dt -> (is_valid dt)
  | TYPE_array (dt, Some(_)) -> (is_complete dt)&&(is_valid dt)
  | TYPE_array (dt,None) -> (is_complete dt)&&(is_valid dt)
  | _ -> true

  let is_assignement_compatible lt rt =
    match (lt, rt) with 
    | (TYPE_real, TYPE_int) -> true
    | (TYPE_ptr(TYPE_array(dt1,None)),TYPE_ptr(TYPE_array(dt2,Some(_))) ) when equalType dt1 dt2 -> true
    | (TYPE_ptr(_),TYPE_ptr(TYPE_none )) -> true
    | (t1, t2) -> (equalType t1 t2)&&(is_complete t1)
  
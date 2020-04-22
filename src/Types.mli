type typ = TYPE_none
         | TYPE_int
         | TYPE_real
         | TYPE_char
         | TYPE_bool
         | TYPE_array of
             typ * int option 
         | TYPE_ptr of typ

val sizeOfType : typ -> int
val pcl_type_str : typ -> string
val equalType : typ -> typ -> bool
val is_complete : typ -> bool
val is_numerical : typ -> bool
val is_valid : typ -> bool
val is_assignement_compatible : typ -> typ -> bool
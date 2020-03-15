; ModuleID = 'mycompiler'
source_filename = "mycompiler"

@global_scope = external global { i16, {} }

define void @main() {
entry:
  %prev_fp = load {}, {}* getelementptr inbounds ({ i16, {} }, { i16, {} }* @global_scope, i32 0, i32 1)
  %"Please, give the number of rings : " = alloca { i32, i8 }
  %set_arr_size = getelementptr { i32, i8 }, { i32, i8 }* %"Please, give the number of rings : ", i32 0, i32 0
  %init_arr = getelementptr { i32, i8 }, { i32, i8 }* %"Please, give the number of rings : ", i32 0, i32 1
  store i32 36, i32* %set_arr_size
  store i8 80, i8* %init_arr
  %"Please, give the number of rings : 1" = alloca { i32, i8 }
  %set_arr_size2 = getelementptr { i32, i8 }, { i32, i8 }* %"Please, give the number of rings : 1", i32 0, i32 0
  %init_arr3 = getelementptr { i32, i8 }, { i32, i8 }* %"Please, give the number of rings : 1", i32 0, i32 1
  store i32 36, i32* %set_arr_size2
  store i8 80, i8* %init_arr3
  %str_lib_cast = getelementptr inbounds { i32, i8 }, { i32, i8 }* %"Please, give the number of rings : 1", i32 0, i32 1
  call void @writeString(i8* %str_lib_cast)
  %prev_fp4 = load {}, {}* getelementptr inbounds ({ i16, {} }, { i16, {} }* @global_scope, i32 0, i32 1)
  %calltmp = call i16 @readInteger()
  store i16 %calltmp, i16* getelementptr inbounds ({ i16, {} }, { i16, {} }* @global_scope, i32 0, i32 0)
  %prev_fp5 = load {}, {}* getelementptr inbounds ({ i16, {} }, { i16, {} }* @global_scope, i32 0, i32 1)
  %"\5CnHere is the solution :\5Cn\5Cn" = alloca { i32, i8 }
  %set_arr_size6 = getelementptr { i32, i8 }, { i32, i8 }* %"\5CnHere is the solution :\5Cn\5Cn", i32 0, i32 0
  %init_arr7 = getelementptr { i32, i8 }, { i32, i8 }* %"\5CnHere is the solution :\5Cn\5Cn", i32 0, i32 1
  store i32 29, i32* %set_arr_size6
  store i8 92, i8* %init_arr7
  %"\5CnHere is the solution :\5Cn\5Cn8" = alloca { i32, i8 }
  %set_arr_size9 = getelementptr { i32, i8 }, { i32, i8 }* %"\5CnHere is the solution :\5Cn\5Cn8", i32 0, i32 0
  %init_arr10 = getelementptr { i32, i8 }, { i32, i8 }* %"\5CnHere is the solution :\5Cn\5Cn8", i32 0, i32 1
  store i32 29, i32* %set_arr_size9
  store i8 92, i8* %init_arr10
  %str_lib_cast11 = getelementptr inbounds { i32, i8 }, { i32, i8 }* %"\5CnHere is the solution :\5Cn\5Cn8", i32 0, i32 1
  call void @writeString(i8* %str_lib_cast11)
  %left = alloca { i32, i8 }
  %set_arr_size12 = getelementptr { i32, i8 }, { i32, i8 }* %left, i32 0, i32 0
  %init_arr13 = getelementptr { i32, i8 }, { i32, i8 }* %left, i32 0, i32 1
  store i32 5, i32* %set_arr_size12
  store i8 108, i8* %init_arr13
  %right = alloca { i32, i8 }
  %set_arr_size14 = getelementptr { i32, i8 }, { i32, i8 }* %right, i32 0, i32 0
  %init_arr15 = getelementptr { i32, i8 }, { i32, i8 }* %right, i32 0, i32 1
  store i32 6, i32* %set_arr_size14
  store i8 114, i8* %init_arr15
  %middle = alloca { i32, i8 }
  %set_arr_size16 = getelementptr { i32, i8 }, { i32, i8 }* %middle, i32 0, i32 0
  %init_arr17 = getelementptr { i32, i8 }, { i32, i8 }* %middle, i32 0, i32 1
  store i32 7, i32* %set_arr_size16
  store i8 109, i8* %init_arr17
  call void @hanoi1({ i32, i8 }* %left, { i32, i8 }* %right, { i32, i8 }* %middle, i16* getelementptr inbounds ({ i16, {} }, { i16, {} }* @global_scope, i32 0, i32 0), { i16, {} }* @global_scope)
  ret void
}

declare void @writeInteger(i16)

declare void @writeBoolean(i8)

declare void @writeChar(i8)

declare void @writeReal(x86_fp80)

declare void @writeString(i8*)

declare i16 @readInteger()

declare i8 @readBoolean()

declare i8 @readChar()

declare x86_fp80 @readReal()

declare void @readString(i16, i8*)

declare i16 @abs(i16)

declare x86_fp80 @fabs(x86_fp80)

declare x86_fp80 @sqrt(x86_fp80)

declare x86_fp80 @sin(x86_fp80)

declare x86_fp80 @cos(x86_fp80)

declare x86_fp80 @tan(x86_fp80)

declare x86_fp80 @arctan(x86_fp80)

declare x86_fp80 @exp(x86_fp80)

declare x86_fp80 @ln(x86_fp80)

declare x86_fp80 @pi()

declare i16 @trunc(x86_fp80)

declare i16 @round(x86_fp80)

declare i16 @ord(i8)

declare i8 @chr(i16)

define void @hanoi1({ i32, i8 }* %source, { i32, i8 }* %auxiliary, { i32, i8 }* %target, i16* byval %rings, { i16, {} }* %pscope) {
entry:
  %scope = alloca { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }
  %var_addr = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 3
  %rings1 = load i16, i16* %var_addr
  %igetmp = icmp sge i16 %rings1, 1
  br label %test

test:                                             ; preds = %entry
  br i1 %igetmp, label %then, label %else

then:                                             ; preds = %test
  %prev_fp_gep = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 4
  %prev_fp = load { i16, {} }*, { i16, {} }** %prev_fp_gep
  %var_addr2 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 0
  %var_addr3 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 1
  %var_addr4 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 2
  %var_addr5 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 3
  %rings6 = load i16, i16* %var_addr5
  %isubtmp = sub i16 1, %rings6
  %par_pass = alloca i16
  store i16 %isubtmp, i16* %par_pass
  call void @hanoi1({ i32, i8 }* %var_addr2, { i32, i8 }* %var_addr3, { i32, i8 }* %var_addr4, i16* %par_pass, { i16, {} }* %prev_fp)
  %var_addr7 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 0
  %var_addr8 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 2
  call void @move2({ i32, i8 }* %var_addr7, { i32, i8 }* %var_addr8, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope)
  %prev_fp_gep9 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 4
  %prev_fp10 = load { i16, {} }*, { i16, {} }** %prev_fp_gep9
  %var_addr11 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 1
  %var_addr12 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 2
  %var_addr13 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 0
  %var_addr14 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %scope, i32 0, i32 3
  %rings15 = load i16, i16* %var_addr14
  %isubtmp16 = sub i16 1, %rings15
  %par_pass17 = alloca i16
  store i16 %isubtmp16, i16* %par_pass17
  call void @hanoi1({ i32, i8 }* %var_addr11, { i32, i8 }* %var_addr12, { i32, i8 }* %var_addr13, i16* %par_pass17, { i16, {} }* %prev_fp10)
  br label %ifcont

else:                                             ; preds = %test
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  br label %"4ret"

"4ret":                                           ; preds = %ifcont
  ret void
}

define void @move2({ i32, i8 }* %source, { i32, i8 }* %target, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %pscope) {
entry:
  %scope = alloca { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }
  %prev_fp_gep = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }, { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }* %scope, i32 0, i32 2
  %prev_fp = load { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }*, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }** %prev_fp_gep
  %prev_fp_gep1 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %prev_fp, i32 0, i32 4
  %prev_fp2 = load { i16, {} }*, { i16, {} }** %prev_fp_gep1
  %prev_fp_gep3 = getelementptr inbounds { i16, {} }, { i16, {} }* %prev_fp2, i32 0, i32 1
  %prev_fp4 = load {}, {}* %prev_fp_gep3
  %"Move from " = alloca { i32, i8 }
  %set_arr_size = getelementptr { i32, i8 }, { i32, i8 }* %"Move from ", i32 0, i32 0
  %init_arr = getelementptr { i32, i8 }, { i32, i8 }* %"Move from ", i32 0, i32 1
  store i32 11, i32* %set_arr_size
  store i8 77, i8* %init_arr
  %"Move from 5" = alloca { i32, i8 }
  %set_arr_size6 = getelementptr { i32, i8 }, { i32, i8 }* %"Move from 5", i32 0, i32 0
  %init_arr7 = getelementptr { i32, i8 }, { i32, i8 }* %"Move from 5", i32 0, i32 1
  store i32 11, i32* %set_arr_size6
  store i8 77, i8* %init_arr7
  %str_lib_cast = getelementptr inbounds { i32, i8 }, { i32, i8 }* %"Move from 5", i32 0, i32 1
  call void @writeString(i8* %str_lib_cast)
  %prev_fp_gep8 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }, { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }* %scope, i32 0, i32 2
  %prev_fp9 = load { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }*, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }** %prev_fp_gep8
  %prev_fp_gep10 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %prev_fp9, i32 0, i32 4
  %prev_fp11 = load { i16, {} }*, { i16, {} }** %prev_fp_gep10
  %prev_fp_gep12 = getelementptr inbounds { i16, {} }, { i16, {} }* %prev_fp11, i32 0, i32 1
  %prev_fp13 = load {}, {}* %prev_fp_gep12
  %var_addr = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }, { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }* %scope, i32 0, i32 0
  %source14 = load { i32, i8 }, { i32, i8 }* %var_addr
  %var_addr15 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }, { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }* %scope, i32 0, i32 0
  %str_lib_cast16 = getelementptr inbounds { i32, i8 }, { i32, i8 }* %var_addr15, i32 0, i32 1
  call void @writeString(i8* %str_lib_cast16)
  %prev_fp_gep17 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }, { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }* %scope, i32 0, i32 2
  %prev_fp18 = load { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }*, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }** %prev_fp_gep17
  %prev_fp_gep19 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %prev_fp18, i32 0, i32 4
  %prev_fp20 = load { i16, {} }*, { i16, {} }** %prev_fp_gep19
  %prev_fp_gep21 = getelementptr inbounds { i16, {} }, { i16, {} }* %prev_fp20, i32 0, i32 1
  %prev_fp22 = load {}, {}* %prev_fp_gep21
  %" to " = alloca { i32, i8 }
  %set_arr_size23 = getelementptr { i32, i8 }, { i32, i8 }* %" to ", i32 0, i32 0
  %init_arr24 = getelementptr { i32, i8 }, { i32, i8 }* %" to ", i32 0, i32 1
  store i32 5, i32* %set_arr_size23
  store i8 32, i8* %init_arr24
  %" to 25" = alloca { i32, i8 }
  %set_arr_size26 = getelementptr { i32, i8 }, { i32, i8 }* %" to 25", i32 0, i32 0
  %init_arr27 = getelementptr { i32, i8 }, { i32, i8 }* %" to 25", i32 0, i32 1
  store i32 5, i32* %set_arr_size26
  store i8 32, i8* %init_arr27
  %str_lib_cast28 = getelementptr inbounds { i32, i8 }, { i32, i8 }* %" to 25", i32 0, i32 1
  call void @writeString(i8* %str_lib_cast28)
  %prev_fp_gep29 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }, { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }* %scope, i32 0, i32 2
  %prev_fp30 = load { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }*, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }** %prev_fp_gep29
  %prev_fp_gep31 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %prev_fp30, i32 0, i32 4
  %prev_fp32 = load { i16, {} }*, { i16, {} }** %prev_fp_gep31
  %prev_fp_gep33 = getelementptr inbounds { i16, {} }, { i16, {} }* %prev_fp32, i32 0, i32 1
  %prev_fp34 = load {}, {}* %prev_fp_gep33
  %var_addr35 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }, { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }* %scope, i32 0, i32 1
  %target36 = load { i32, i8 }, { i32, i8 }* %var_addr35
  %var_addr37 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }, { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }* %scope, i32 0, i32 1
  %str_lib_cast38 = getelementptr inbounds { i32, i8 }, { i32, i8 }* %var_addr37, i32 0, i32 1
  call void @writeString(i8* %str_lib_cast38)
  %prev_fp_gep39 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }, { { i32, i8 }, { i32, i8 }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* }* %scope, i32 0, i32 2
  %prev_fp40 = load { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }*, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }** %prev_fp_gep39
  %prev_fp_gep41 = getelementptr inbounds { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }, { { i32, i8 }, { i32, i8 }, { i32, i8 }, i16, { i16, {} }* }* %prev_fp40, i32 0, i32 4
  %prev_fp42 = load { i16, {} }*, { i16, {} }** %prev_fp_gep41
  %prev_fp_gep43 = getelementptr inbounds { i16, {} }, { i16, {} }* %prev_fp42, i32 0, i32 1
  %prev_fp44 = load {}, {}* %prev_fp_gep43
  %".\5Cn" = alloca { i32, i8 }
  %set_arr_size45 = getelementptr { i32, i8 }, { i32, i8 }* %".\5Cn", i32 0, i32 0
  %init_arr46 = getelementptr { i32, i8 }, { i32, i8 }* %".\5Cn", i32 0, i32 1
  store i32 4, i32* %set_arr_size45
  store i8 46, i8* %init_arr46
  %".\5Cn47" = alloca { i32, i8 }
  %set_arr_size48 = getelementptr { i32, i8 }, { i32, i8 }* %".\5Cn47", i32 0, i32 0
  %init_arr49 = getelementptr { i32, i8 }, { i32, i8 }* %".\5Cn47", i32 0, i32 1
  store i32 4, i32* %set_arr_size48
  store i8 46, i8* %init_arr49
  %str_lib_cast50 = getelementptr inbounds { i32, i8 }, { i32, i8 }* %".\5Cn47", i32 0, i32 1
  call void @writeString(i8* %str_lib_cast50)
  br label %"4ret"

"4ret":                                           ; preds = %entry
  ret void
}

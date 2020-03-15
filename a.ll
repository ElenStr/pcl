; ModuleID = 'mycompiler'
source_filename = "mycompiler"

@global_scope_def = global { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} } zeroinitializer

define void @main() {
entry:
  %malloccall = tail call i8* @malloc(i32 trunc (i64 mul (i64 ptrtoint (i16* getelementptr (i16, i16* null, i32 1) to i64), i64 6) to i32))
  %new_array = bitcast i8* %malloccall to [3 x [2 x i16]]*
  %new_arr_bitcast = bitcast [3 x [2 x i16]]* %new_array to [0 x [2 x i16]]*
  store [0 x [2 x i16]]* %new_arr_bitcast, [0 x [2 x i16]]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 2)
  %malloccall1 = tail call i8* @malloc(i32 trunc (i64 mul nuw (i64 ptrtoint (i8* getelementptr (i8, i8* null, i32 1) to i64), i64 4) to i32))
  %new_array2 = bitcast i8* %malloccall1 to [4 x i8]*
  %new_arr_bitcast3 = bitcast [4 x i8]* %new_array2 to [0 x i8]*
  store [0 x i8]* %new_arr_bitcast3, [0 x i8]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 0)
  store i8 112, i8* getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 1, i32 0)
  %"asd " = alloca [7 x i8]
  store [7 x i8] c"asd \00\00\00", [7 x i8]* %"asd "
  %str_cast = bitcast [7 x i8]* %"asd " to [0 x i8]*
  store [0 x i8]* %str_cast, [0 x i8]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 0)
  %prev_fp = load {}, {}* getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 5)
  %"Hello " = alloca [8 x i8]
  store [8 x i8] c"Hello \00\00", [8 x i8]* %"Hello "
  %str_cast4 = bitcast [8 x i8]* %"Hello " to [0 x i8]*
  %"Hello 5" = load [0 x i8], [0 x i8]* %str_cast4
  %"Hello 6" = alloca [8 x i8]
  store [8 x i8] c"Hello \00\00", [8 x i8]* %"Hello 6"
  %str_cast7 = bitcast [8 x i8]* %"Hello 6" to [0 x i8]*
  call void @writeString([0 x i8]* %str_cast7)
  %prev_fp8 = load {}, {}* getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 5)
  %c = load [0 x i8]*, [0 x i8]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 0)
  %"Var(c)_ptr" = load [0 x i8], [0 x i8]* %c
  %c9 = load [0 x i8]*, [0 x i8]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 0)
  call void @writeString([0 x i8]* %c9)
  %c10 = load [0 x i8]*, [0 x i8]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 0)
  %array_element_gep = getelementptr [0 x i8], [0 x i8]* %c10, i32 0, i32 0
  store i8 10, i8* %array_element_gep
  %prev_fp11 = load {}, {}* getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 5)
  %c12 = load [0 x i8]*, [0 x i8]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 0)
  %array_element_gep13 = getelementptr [0 x i8], [0 x i8]* %c12, i32 0, i32 4
  %array_element = load i8, i8* %array_element_gep13
  %c14 = load [0 x i8]*, [0 x i8]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 0)
  %array_element_gep15 = getelementptr [0 x i8], [0 x i8]* %c14, i32 0, i32 4
  %array_element16 = load i8, i8* %array_element_gep15
  call void @writeChar(i8 %array_element16)
  %prev_fp17 = load {}, {}* getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 5)
  %c18 = load [0 x i8]*, [0 x i8]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 0)
  %"Var(c)_ptr19" = load [0 x i8], [0 x i8]* %c18
  %c20 = load [0 x i8]*, [0 x i8]** getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 0)
  call void @writeString([0 x i8]* %c20)
  %prev_fp21 = load {}, {}* getelementptr inbounds ({ [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* @global_scope_def, i32 0, i32 5)
  call void @writeChar(i8 10)
  br label %"4ret"

"4ret":                                           ; preds = %entry
  ret void
}

declare void @writeInteger(i16)

declare void @writeBoolean(i1)

declare void @writeChar(i8)

declare void @writeReal(x86_fp80)

declare void @writeString([0 x i8]*)

declare i16 @readInteger()

declare i1 @readBoolean()

declare i8 @readChar()

declare x86_fp80 @readReal()

declare void @readString(i16, [0 x i8]*)

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

define void @a1(i16* %i, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* %pscope) {
entry:
  %scope = alloca { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }
  %bind_param_ptr = getelementptr inbounds { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }, { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }* %scope, i32 0, i32 0
  store i16* %i, i16** %bind_param_ptr
  %bind_param_ptr1 = getelementptr inbounds { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }, { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }* %scope, i32 0, i32 1
  store { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* %pscope, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }** %bind_param_ptr1
  %bind_param_ptr2 = getelementptr inbounds { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }, { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }* %scope, i32 0, i32 1
  store { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* %pscope, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }** %bind_param_ptr2
  %tmp_var_addr = getelementptr inbounds { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }, { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }* %scope, i32 0, i32 0
  %var_addr = load i16*, i16** %tmp_var_addr
  %tmp_var_addr3 = getelementptr inbounds { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }, { i16*, { [0 x i8]*, [32 x i8], [0 x [2 x i16]]*, x86_fp80, i16, {} }* }* %scope, i32 0, i32 0
  %var_addr4 = load i16*, i16** %tmp_var_addr3
  %i5 = load i16, i16* %var_addr4
  %iaddtmp = add i16 1, %i5
  store i16 %iaddtmp, i16* %var_addr
  br label %"4ret"

"4ret":                                           ; preds = %entry
  ret void
}

declare noalias i8* @malloc(i32)

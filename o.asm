	.text
	.file	"mycompiler"
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:
	.cfi_startproc
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movl	$12, %edi
	callq	malloc
	movq	%rax, global_scope_def+40(%rip)
	movl	$4, %edi
	callq	malloc
	movq	%rax, global_scope_def(%rip)
	movb	$112, global_scope_def+8(%rip)
	movq	global_scope_def+40(%rip), %rax
	movw	$2, 6(%rax)
	movw	$1, global_scope_def+64(%rip)
	movl	$global_scope_def+64, %edi
	movl	$global_scope_def, %esi
	callq	a1
	movl	global_scope_def+64(%rip), %edi
	callq	writeInteger
	movb	$0, 16(%rsp)
	movw	$10, 14(%rsp)
	movw	$10, 11(%rsp)
	movb	$0, 13(%rsp)
	leaq	11(%rsp), %rdi
	callq	writeString
	movq	global_scope_def+40(%rip), %rax
	movzwl	6(%rax), %edi
	callq	writeInteger
	movb	$0, 23(%rsp)
	movw	$0, 21(%rsp)
	movl	$543454049, 17(%rsp)
	leaq	17(%rsp), %rax
	movq	%rax, global_scope_def(%rip)
	movabsq	$35662932501832, %rax
	movq	%rax, 32(%rsp)
	movq	%rax, 24(%rsp)
	leaq	24(%rsp), %rdi
	callq	writeString
	movq	global_scope_def(%rip), %rdi
	callq	writeString
	movq	global_scope_def(%rip), %rax
	movb	$10, (%rax)
	movq	global_scope_def(%rip), %rax
	movzbl	4(%rax), %edi
	callq	writeChar
	movq	global_scope_def(%rip), %rdi
	callq	writeString
	movl	$10, %edi
	callq	writeChar
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc

	.globl	a1
	.p2align	4, 0x90
	.type	a1,@function
a1:
	.cfi_startproc
	movq	%rdi, -16(%rsp)
	movq	%rsi, -8(%rsp)
	incw	(%rdi)
	retq
.Lfunc_end1:
	.size	a1, .Lfunc_end1-a1
	.cfi_endproc

	.type	global_scope_def,@object
	.bss
	.globl	global_scope_def
	.p2align	4
global_scope_def:
	.zero	80
	.size	global_scope_def, 80


	.section	".note.GNU-stack","",@progbits

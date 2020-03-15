	.text
	.file	"mycompiler"
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -16
	movl	$12, %edi
	callq	malloc
	movq	%rax, %rbx
	movq	%rax, global_scope_def+40(%rip)
	movl	$4, %edi
	callq	malloc
	movq	%rax, global_scope_def(%rip)
	movb	$112, global_scope_def+8(%rip)
	movw	$2, 6(%rbx)
	movl	$262149, global_scope_def+64(%rip)
	movl	$global_scope_def+64, %edi
	movl	$global_scope_def, %esi
	callq	a1
	movl	global_scope_def+64(%rip), %edi
	callq	writeInteger
	movw	$10, 14(%rsp)
	movb	$0, 16(%rsp)
	leaq	14(%rsp), %rdi
	callq	writeString
	movq	global_scope_def+40(%rip), %rax
	movzwl	6(%rax), %edi
	callq	writeInteger
	movl	$543454049, 17(%rsp)
	movw	$0, 21(%rsp)
	movb	$0, 23(%rsp)
	leaq	17(%rsp), %rax
	movq	%rax, global_scope_def(%rip)
	movabsq	$35662932501832, %rax
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
	movl	$97, %edi
	callq	writeChar
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
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

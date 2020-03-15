	.text
	.file	"mycompiler"
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:
	.cfi_startproc
	subq	$184, %rsp
	.cfi_def_cfa_offset 192
	movabsq	$8315736636128257647, %rax
	movq	%rax, 163(%rsp)
	movabsq	$2338042629976321568, %rcx
	movq	%rcx, 155(%rsp)
	movabsq	$7307218077898664295, %rdx
	movq	%rdx, 147(%rsp)
	movabsq	$2318339454418644048, %rsi
	movq	%rsi, 139(%rsp)
	movb	$0, 175(%rsp)
	movl	$2112032, 171(%rsp)
	movq	%rax, 99(%rsp)
	movq	%rcx, 91(%rsp)
	movq	%rdx, 83(%rsp)
	movq	%rsi, 75(%rsp)
	movb	$0, 111(%rsp)
	movl	$2112032, 107(%rsp)
	leaq	75(%rsp), %rdi
	callq	writeString
	callq	readInteger
	movw	%ax, global_scope_def(%rip)
	movabsq	$8316213806999357450, %rax
	movq	%rax, 112(%rsp)
	movabsq	$7813590461488591904, %rcx
	movq	%rcx, 120(%rsp)
	movabsq	$736937147716170869, %rdx
	movq	%rdx, 128(%rsp)
	movw	$10, 136(%rsp)
	movb	$0, 138(%rsp)
	movq	%rax, 48(%rsp)
	movq	%rcx, 56(%rsp)
	movq	%rdx, 64(%rsp)
	movb	$0, 74(%rsp)
	movw	$10, 72(%rsp)
	leaq	48(%rsp), %rdi
	callq	writeString
	movw	$0, 38(%rsp)
	movl	$1952867692, 34(%rsp)
	movl	$1952867692, 21(%rsp)
	movw	$0, 25(%rsp)
	movl	$1751607666, 27(%rsp)
	movw	$116, 31(%rsp)
	movb	$0, 33(%rsp)
	movb	$0, 20(%rsp)
	movl	$1751607666, 14(%rsp)
	movw	$116, 18(%rsp)
	movabsq	$111516215175533, %rax
	movq	%rax, 176(%rsp)
	movq	%rax, 40(%rsp)
	movzwl	global_scope_def(%rip), %eax
	movw	%ax, (%rsp)
	leaq	21(%rsp), %rdi
	leaq	14(%rsp), %rsi
	leaq	40(%rsp), %rdx
	movl	$global_scope_def, %ecx
	callq	hanoi1
	addq	$184, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc

	.globl	hanoi1
	.p2align	4, 0x90
	.type	hanoi1,@function
hanoi1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -24(%rbp)
	leaq	16(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	%rcx, -8(%rbp)
	cmpw	$0, 16(%rbp)
	jle	.LBB1_2
	movq	-8(%rbp), %rcx
	movq	-24(%rbp), %rsi
	movq	-40(%rbp), %rdi
	movq	-32(%rbp), %rdx
	movq	-16(%rbp), %rax
	movzwl	(%rax), %r8d
	decl	%r8d
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	movw	%r8w, -16(%rax)
	subq	$16, %rsp
	movzwl	-16(%rax), %eax
	movw	%ax, (%rsp)
	callq	hanoi1
	addq	$16, %rsp
	movq	-40(%rbp), %rdi
	movq	-32(%rbp), %rsi
	leaq	-40(%rbp), %rdx
	callq	move2
	movq	-8(%rbp), %rcx
	movq	-24(%rbp), %rdi
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rsi
	movq	-16(%rbp), %rax
	movzwl	(%rax), %r8d
	decl	%r8d
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	movw	%r8w, -16(%rax)
	subq	$16, %rsp
	movzwl	-16(%rax), %eax
	movw	%ax, (%rsp)
	callq	hanoi1
	addq	$16, %rsp
.LBB1_2:
	movq	%rbp, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	hanoi1, .Lfunc_end1-hanoi1
	.cfi_endproc

	.globl	move2
	.p2align	4, 0x90
	.type	move2,@function
move2:
	.cfi_startproc
	subq	$72, %rsp
	.cfi_def_cfa_offset 80
	movq	%rdi, 32(%rsp)
	movq	%rsi, 40(%rsp)
	movq	%rdx, 48(%rsp)
	movabsq	$8030593374882262861, %rax
	movq	%rax, 60(%rsp)
	movl	$8301, 68(%rsp)
	movq	%rax, 20(%rsp)
	movl	$8301, 28(%rsp)
	leaq	20(%rsp), %rdi
	callq	writeString
	movq	32(%rsp), %rdi
	callq	writeString
	movl	$544175136, 10(%rsp)
	movw	$0, 14(%rsp)
	movl	$544175136, 4(%rsp)
	movw	$0, 8(%rsp)
	leaq	4(%rsp), %rdi
	callq	writeString
	movq	40(%rsp), %rdi
	callq	writeString
	movl	$2606, 16(%rsp)
	movl	$2606, (%rsp)
	movq	%rsp, %rdi
	callq	writeString
	addq	$72, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	move2, .Lfunc_end2-move2
	.cfi_endproc

	.type	global_scope_def,@object
	.bss
	.globl	global_scope_def
	.p2align	3
global_scope_def:
	.zero	2
	.size	global_scope_def, 2


	.section	".note.GNU-stack","",@progbits

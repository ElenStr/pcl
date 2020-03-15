	.text
	.file	"mycompiler"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$72, %rsp
	.cfi_def_cfa_offset 80
	movl	$36, 64(%rsp)
	movb	$80, 68(%rsp)
	leaq	52(%rsp), %rdi
	movl	$36, 48(%rsp)
	movb	$80, 52(%rsp)
	callq	writeString
	callq	readInteger
	movw	%ax, global_scope(%rip)
	movl	$29, 56(%rsp)
	movb	$92, 60(%rsp)
	leaq	44(%rsp), %rdi
	movl	$29, 40(%rsp)
	movb	$92, 44(%rsp)
	callq	writeString
	movl	$5, 32(%rsp)
	movb	$108, 36(%rsp)
	movl	$6, 24(%rsp)
	movb	$114, 28(%rsp)
	movl	$7, 16(%rsp)
	movb	$109, 20(%rsp)
	movzwl	global_scope(%rip), %eax
	movw	%ax, (%rsp)
	leaq	32(%rsp), %rdi
	leaq	24(%rsp), %rsi
	leaq	16(%rsp), %rdx
	movl	$global_scope, %ecx
	callq	hanoi1
	addq	$72, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	hanoi1                  # -- Begin function hanoi1
	.p2align	4, 0x90
	.type	hanoi1,@function
hanoi1:                                 # @hanoi1
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	subq	$48, %rsp
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	cmpw	$0, -48(%rbp)
	jle	.LBB1_2
# %bb.1:                                # %then
	movq	-40(%rbp), %rcx
	leaq	-64(%rbp), %r14
	leaq	-56(%rbp), %r15
	movw	$1, %bx
	movw	$1, %ax
	subw	-48(%rbp), %ax
	movq	%rsp, %rdx
	leaq	-16(%rdx), %rsp
	movw	%ax, -16(%rdx)
	subq	$16, %rsp
	movzwl	-16(%rdx), %eax
	movw	%ax, (%rsp)
	leaq	-72(%rbp), %r12
	movq	%r12, %rdi
	movq	%r14, %rsi
	movq	%r15, %rdx
	callq	hanoi1
	addq	$16, %rsp
	movq	%r12, %rdi
	movq	%r15, %rsi
	movq	%r12, %rdx
	callq	move2
	movq	-40(%rbp), %rcx
	subw	-48(%rbp), %bx
	movq	%rsp, %rax
	leaq	-16(%rax), %rsp
	movw	%bx, -16(%rax)
	subq	$16, %rsp
	movzwl	-16(%rax), %eax
	movw	%ax, (%rsp)
	movq	%r14, %rdi
	movq	%r15, %rsi
	movq	%r12, %rdx
	callq	hanoi1
	addq	$16, %rsp
.LBB1_2:                                # %ifcont
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	hanoi1, .Lfunc_end1-hanoi1
	.cfi_endproc
                                        # -- End function
	.globl	move2                   # -- Begin function move2
	.p2align	4, 0x90
	.type	move2,@function
move2:                                  # @move2
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$72, %rsp
	.cfi_def_cfa_offset 80
	movl	$11, 40(%rsp)
	movb	$77, 44(%rsp)
	leaq	20(%rsp), %rdi
	movl	$11, 16(%rsp)
	movb	$77, 20(%rsp)
	callq	writeString
	leaq	52(%rsp), %rdi
	callq	writeString
	movl	$5, 32(%rsp)
	movb	$32, 36(%rsp)
	leaq	12(%rsp), %rdi
	movl	$5, 8(%rsp)
	movb	$32, 12(%rsp)
	callq	writeString
	leaq	60(%rsp), %rdi
	callq	writeString
	movl	$4, 24(%rsp)
	movb	$46, 28(%rsp)
	leaq	4(%rsp), %rdi
	movl	$4, (%rsp)
	movb	$46, 4(%rsp)
	callq	writeString
	addq	$72, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	move2, .Lfunc_end2-move2
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits

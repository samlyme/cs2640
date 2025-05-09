#
# Name: Ly, Sam
# Project: 4
# Due: May 9, 2025
# Course: cs-2640-03-sp25
#
# Description:
# 	Solve quadratice equation
#
	.data
title:	.asciiz	"Quadratic Equation Solver v0.25 by S. Ly\n\n"
qa:	.asciiz	"Enter value for a? "
qb:	.asciiz	"Enter value for b? "
qc:	.asciiz	"Enter value for c? "

noquad:	.asciiz	"\nNot a quadratic equation."
linsol:	.asciiz "\nx = "
iroot:	.asciiz	"\nRoots are imaginary."

root1:	.asciiz	"\nx1 = "
root2:	.asciiz	"\nx2 = "

	.text
main:
	la	$a0, title
	li	$v0, 4
	syscall

	la	$a0, qa
	li	$v0, 4
	syscall

	li	$v0, 6
	syscall

	mov.s	$f12, $f0

	la	$a0, qb
	li	$v0, 4
	syscall

	li	$v0, 6
	syscall

	mov.s	$f13, $f0

	la	$a0, qc
	li	$v0, 4
	syscall

	li	$v0, 6
	syscall

	mov.s	$f14, $f0

	jal	solve

	beq	$v0, -1, ir
	beq	$v0, 0, nq
	beq	$v0, 1, oner
	beq	$v0, 2, twor

# imaginary root case
ir:	la	$a0, iroot
	li	$v0, 4
	syscall

	b exit

# not quadratic 
nq:	la	$a0, noquad
	li	$v0, 4
	syscall

	b exit

# 1 root
oner:	la	$a0, linsol
	li	$v0, 4
	syscall
	
	mov.s	$f12, $f0
	li	$v0, 2
	syscall

	b exit

# 2 roots
twor:	la	$a0, root1
	li	$v0, 4
	syscall

	mov.s	$f12, $f0
	li	$v0, 2
	syscall

	la	$a0, root2
	li	$v0, 4
	syscall

	mov.s	$f12, $f1
	li	$v0, 2
	syscall

	b exit

solve:	# $f12 = a, $f13 = b, $f14 = c
	li.s	$f4, 0.0
	c.eq.s	$f12, $f4
	bc1f	quad

	c.eq.s	$f13, $f4
	bc1t	nquad
	bc1f	lin
# not quadratic
nquad:	li	$v0, 0
	jr	$ra
# is quadratic
quad:	mul.s	$f4, $f13, $f13
	li.s	$f5, 4.0
	mul.s	$f5, $f5, $f12
	mul.s	$f5, $f5, $f14

	c.lt.s	$f4, $f5
	bc1t	imagr

	sub.s	$f6, $f4, $f5
	sqrt.s	$f6, $f6

	neg.s	$f0, $f13
	neg.s	$f1, $f13

	add.s	$f0, $f0, $f6
	sub.s	$f1, $f1, $f6

	li.s	$f7, 2.0
	div.s	$f0, $f0, $f7
	div.s	$f1, $f1, $f7

	div.s	$f0, $f0, $f12
	div.s	$f1, $f1, $f12

	li	$v0, 2
	jr	$ra
# imaginary roots
imagr:	li	$v0, -1
	jr	$ra
# is a linear eq
lin:	div.s	$f0, $f14, $f13
	neg.s	$f0, $f0

	li	$v0, 1
	jr	$ra

exit:
	li	$a0, '\n'
	li	$v0, 11
	syscall

	li	$v0, 10
	syscall

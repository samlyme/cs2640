#
# Name: Ly, Sam
# Project: 4
# Due: April 29, 2025
# Course: cs-2640-03-sp25
#
# Description:
# Use recursion and file I/O to build and traverse linked lists.
#
	.data
head:	.word	0
ptfname:	.asciiz	"/Users/samly/Documents/code/assembly/proj4/enames.dat"
title:	.asciiz	"Elements by S. Ly v0.1\n\n"
nl:	.asciiz	"\n\n"
buf:	.space	64

	.text
main:	
	la	$a0, title
	li	$v0, 4
	syscall

	la	$a0, ptfname
	li	$a1, 0
	jal	open

	move	$s0, $v0
	li	$s1, 0
while:	move	$a0, $s0
	la	$a1, buf
	jal	fgetln

	beqz	$v0, endwhile

	la	$a0, buf
	jal	strdup

	move	$a0, $v0
	lw	$a1, head
	jal	getnode

	sw	$v0, head

	addi	$s1, $s1, 1
	b	while
endwhile: 
	move	$a0, $s0
	jal	close

	move	$a0, $s1
	li	$v0, 1
	syscall

	la	$a0, nl
	li	$v0, 4
	syscall

	lw	$a0, head
	la	$a1, print
	jal	traverse

	li	$v0, 10
	syscall

traverse:
	# $a0: pointer to head of linked list
	# $a1: pointer to procedure

	# flow:
	# if next > 0: traverse next, then print
	# if next == 0: print and return
	beqz	$a0, return

	addiu	$sp, $sp, -8
	sw	$a0, 4($sp)
	sw	$ra, 0($sp)

	lw	$t0, 4($a0)	# node: 0 = str, 4 = next
	move	$a0, $t0
	jal	traverse

	lw	$t0, 4($sp)
	lw	$a0, 0($t0)
	jalr	$a1
	
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 8
return:	jr $ra

getnode:# $a0: pointer to cstring
	# $a1: pointer to next
	addiu	$sp, $sp, -8
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)

	# save old fp
	addiu	$sp, -4
	sw	$fp, ($sp)
	move	$fp, $sp

	# saved registers
	addiu	$sp, -4
	sw	$ra,-4($fp)

	# local vars
	addiu	$sp, $sp, -4

	jal	strdup
	sw	$v0, -8($fp)

	li	$a0, 8
	jal	malloc

	lw	$t0, -8($fp)
	lw	$t1, 8($fp)

	sw	$t0, 0($v0)
	sw	$t1, 4($v0)

	lw	$ra, -4($fp)
	move	$sp, $fp
	lw	$fp, ($fp)
	addiu	$sp, $sp, 12

	jr	$ra

print:	# $a0: pointer to cstring
	addiu	$sp, $sp, -8
	sw	$a0, 4($sp)
	sw	$ra, 0($sp)

	jal	cstrlen

	move	$a0, $v0
	li	$v0, 1
	syscall

	li	$a0, ':'
	li	$v0, 11
	syscall

	lw	$a0, 4($sp)
	li	$v0, 4
	syscall

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 8
	jr	$ra

strdup:	# $a0: pointer to cstring
	# This procedure is NOT a leaf
	addiu	$sp, $sp, -8
	sw	$s0, 0($sp)
	sw	$ra, 4($sp)

	move	$s0, $a0	# save a copy of the start of string

	jal	cstrlen
	move	$t0, $v0
	addi	$t0, $t0, 1	# make room for null terminator

	move	$a0, $t0
	jal	malloc

	move	$a0, $v0	# address of freshly allocated memory
	move	$a1, $s0	# source of string
	jal	strcpy

	lw	$s0, 0($sp)
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8

	# v0 still contains memory address of new string
	jr	$ra

strcpy:	# copy a string from a source to a new destination memory
	# returns start of destination
	move	$v0, $a0	# known to not change
whileC:	# while copy
	lb	$t0, ($a1)
	sb	$t0, ($a0)

	beqz	$t0, endC

	addi	$a0, $a0, 1
	addi	$a1, $a1, 1

	b	whileC
endC:
	jr	$ra
	
cstrlen:	# return length of string excluding null
	move	$t0, $a0
	li	$v0, 0	# start counter at 0
whileL:	# while length
	lb	$t1, ($t0)
	beqz	$t1, endL
	addi	$v0, $v0, 1
	addi	$t0, $t0, 1
	b	whileL
endL:
	jr	$ra

malloc:
	# size should be in a0
	li	$v0, 9
	syscall

	jr	$ra
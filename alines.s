#
# Name: Ly, Sam
# Project: 2
# Due: March 28, 2025
# Course: cs-2640-03-sp25
#
# Description:
# Prints strings
#

	.data	
title:	.asciiz	"Lines with Array by S. Ly\n\n"
prompt:	.asciiz	"Enter text? "
lines:	.word	0:10	# store 10 addresses
buffer:	.space	40	# trust the user doesn't input more

	.text
main:
	la	$a0, title
	li	$v0, 4
	syscall

	li	$s0, 0	# let s0 be the count
whileR:	# while read
	beq	$s0, 10, endR

	la	$a0, prompt
	li	$v0, 4
	syscall

	jal	gets
	
	lb	$t0, buffer	# First character of input
	li	$t1, 10		# ASCII value of '\n'
	beq	$t0, $t1, endR

	la	$a0, buffer
	jal	strdup

	move	$t2, $v0	# memory address of new string

	la	$t3, lines	# base
	sll	$t4, $s0, 2	# offset
	add	$t5, $t3, $t4	# effective address

	sw	$t2, ($t5)

	addi	$s0, $s0, 1
	b	whileR
endR:
	li	$s1, 0	# start at line 0

whileP:	# while print
	beq	$s1, $s0, endP	# loop until same number as read

	la	$t0, lines	# base
	sll	$t1, $s1, 2	# offset
	add	$t2, $t0, $t1	# effective address

	lw	$s2, ($t2)	# current string

	move	$a0, $s2
	jal	cstrlen
	move	$s3, $v0

	# Print length
	move	$a0, $s3
	li	$v0, 1
	syscall

	# Print ':'
	li	$a0, ':'
	li	$v0, 11
	syscall

	# Print string
	move	$a0, $s2
	li	$v0, 4
	syscall

	addi	$s1, $s1, 1

	b	whileP
endP:
	li	$v0, 10
	syscall

gets:	# get user input and store in buffer
	la	$a0, buffer
	li	$a1, 40
	li	$v0, 8
	syscall

	jr	$ra

strdup:	# string to duplicate is in $a0
	# This procedure is NOT a leaf
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

	# DODGY CODE: t8 can't be assumed to stay the same
	move	$t8, $a0	# save a copy of the start of string

	jal	cstrlen
	move	$t0, $v0
	addi	$t0, $t0, 1	# make room for null terminator

	move	$a0, $t0
	jal	malloc

	move	$a0, $v0	# address of freshly allocated memory
	move	$a1, $t8	# source of string
	jal	strcpy

	lw	$ra, ($sp)
	addiu	$sp, $sp, 4

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
	li	$v0, 9
	syscall

	jr	$ra
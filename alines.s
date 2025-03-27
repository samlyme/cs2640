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
lines:	.word	0:10
buffer:	.space	40

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

	la	$t2, lines
	sll	$t3, $s0, 2

	add	$t4, $t2, $t3

	sw	$v0, ($t4)

	addiu	$s0, $s0, 1

	b	whileR
endR:	
	li	$v0, 10
	syscall

gets:	# get user input and store in buf
	la	$a0, buffer
	li	$a1, 40
	li	$v0, 8
	syscall

	jr	$ra

cstrlen:	# return length of string excluding null
	move	$t0, $a0
	li	$v0, 0	# start counter at 0

whileL:	# while length
	lb	$t1, ($t0)
	beqz	$t1, endL
	addi	$v0, $v0, 1
	addi	$t0, $t0, 1
endL:
	jr	$ra

strdup:	# duplicates a string and stores it in heap
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

	# save the pointer to c string
	addiu	$sp, $sp, -4
	sw	$a0, ($sp)

	li	$a0, 40
	jal	malloc

	move	$t0, $v0
	move	$t9, $v0	# do not touch, need to return

	lw	$t1, ($sp)	# get the pointer to c string
	addiu	$sp, $sp, 4

	# TEMP: print received c string
	move	$a0, $t1
	li	$v0, 4
	syscall

whileC:	# while copy
	lb	$t2, ($t1)

	# TEMP: print current copy char
	move	$a0, $t2
	li	$v0, 4
	syscall

	sb	$t2, ($t0)

	beqz	$t1, endC

	addiu	$t0, $t0, 1
	addiu	$t1, $t1, 1

	b	whileC

endC:	# end copy loop
	lw	$ra, ($sp)
	addiu	$sp, $sp, 4

	move	$v0, $t9

	jr	$ra

malloc:
	# a0 should already have the size
	li	$v0, 9
	syscall

	jr	$ra
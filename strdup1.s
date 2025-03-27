	.data
string:	.asciiz	"asdf\n"

	.text
main:
	la	$a0, string
	jal	strdup

	move	$a0, $v0
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall

strdup:	# string to duplicate is in $a0
	# This procedure is NOT a leaf
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

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
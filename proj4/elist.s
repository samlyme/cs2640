	.data
head:	.word	0
ptfname:	.asciiz	"/Users/samly/Documents/code/assembly/proj4/enames.dat"

test1:	.asciiz	"Heliumi00"
test2:	.asciiz	"Hydrogen"
test3:	.asciiz	"Lithium"

	.text
main:	
	move	$a0, $sp
	li	$v0, 1
	syscall

	la	$a0, '\n'
	li	$v0, 11
	syscall

	la	$a0, test1
	la	$a1, 0
	jal	getnode
	move	$s0, $v0

	lw	$a0, 0($v0)
	jal	print

	la	$a0, '\n'
	li	$v0, 11
	syscall

	la	$a0, test2
	move	$a1, $s0
	jal	getnode
	move	$s1, $v0

	lw	$a0, 0($v0)
	jal	print

	la	$a0, '\n'
	li	$v0, 11
	syscall

	# save head
	sw	$s1, head

	li	$v0, 10
	syscall

getnode: # takes in an address pointing to a cstring, and a "next"
	# save args
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

print:
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

strdup:	# string to duplicate is in $a0
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
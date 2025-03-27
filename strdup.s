	.data
string:	.asciiz	"asdf\n"

	.text
main:

	la	$a0, string
	jal	cstrlen

	move	$t0, $v0
	addi	$t0, $t0, 1	# make room for null

	move	$a0, $t0
	jal	malloc

	move	$t1, $v0
	move	$t9, $v0	# do not touch, need to return

	la	$t2, string
	
	jal	whileC

	move	$a0, $t9
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall

whileC:	# while copy
	lb	$t3, ($t2)
	sb	$t3, ($t1)

	beqz	$t3, endC

	addi	$t1, $t1, 1
	addi	$t2, $t2, 1

	b whileC

endC:	# end whileC
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
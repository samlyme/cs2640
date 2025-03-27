	.data
prompt:	.asciiz	"Enter F: "

	.text
main:
	li	$v0, 4		# print the prompt
	la	$a0, prompt
	syscall

	li	$v0, 5		# read int from system
	syscall

	addi	$t0, $v0, -32	# $v0 has our input values
	mul	$t0, $t0, 5
	div	$t0, $t0, 9

	# print out result
	move	$a0, $t0
	li	$v0, 1
	syscall

	li	$v0, 10	# exit
	syscall

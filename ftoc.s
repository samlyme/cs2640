	.data
prompt:	.asciiz	"Enter F: "

	.text
main:
	li	$v0, 4		# print the prompt
	la	$a0, prompt
	syscall

	li	$v0, 5		# read int from system
	syscall

	# bad practice to do math in a0
	addi	$a0, $v0, -32	# $v0 has our input values
	mul	$a0, $a0, 5	# just do all math straight in $a0
	div	$a0, $a0, 9

	# print out result
	li	$v0, 1
	syscall

	li	$v0, 10	# exit
	syscall

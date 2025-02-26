	.text
main:	li	$t0, 10
	li	$t1, 20
	add	$a0, $t0, $t1

	li	$v0, 10		# system call to exit program
	syscall
	.end main

	.data
buf:	.word	0, 1, 2, 3, 4

	.text
main:
	li	$t0, 0
	li	$t1, 0
	lw	$t2, 1(buf)

	move	$a0, $t2
	li	$v0, 1
	syscall

	li	$v0, 10
	syscall
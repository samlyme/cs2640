#
# Name:		Ly, Sam
# Homework:	1
# Due: 		February 25, 2025
# Course:	cs-2640-03-sp25
#
# Description:
# 	Hello world application
#

	.data
hello:	.ascii	"helloworld by S. Ly\n\n"
	.asciiz	"hello world from mips32\n"

	.text
main:
	la	$a0, hello	# display hello
	li	$v0, 4
	syscall

	add	$t0, $t1, $t2

	li	$v0, 10	# exit
	syscall
	

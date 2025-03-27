#
# Name: Ly, Sam
# Project: 1
# Due: March 11, 2025
# Course: cs-2640-03-sp25
#
# Description:
# Counts change
#
	.data
intro:	.asciiz	"Change Machine by S. Ly\n\n"
p1:	.asciiz	"Enter the receipt amount? "
p2:	.asciiz	"Enter the amount tendered? "
q:	.asciiz	"\nQuarters: "
d:	.asciiz	"\nDimes:    "
n:	.asciiz	"\nNickels:  "
p:	.asciiz	"\nPennies:  "
nc:	.asciiz	"\nNo change"

	.text
main:
	la	$a0, intro
	li	$v0, 4
	syscall

	la	$a0, p1		# display prompt 1
	li	$v0, 4
	syscall

	li	$v0, 5		# read in receipt amount
	syscall
	move	$t0, $v0

	la	$a0, p2		# display prompt 2
	li	$v0, 4
	syscall

	li	$v0, 5		# read in tendered amount
	syscall
	move	$t1, $v0

	# If tendered amount is less than or equal to receipt, no change
	ble	$t1, $t0, na

	# Calculate change
	sub	$t2, $t1, $t0	# t2 is amount left over

qr:	# quarters routine
	blt	$t2, 25, dr

	div	$t3, $t2, 25	# t3 is the amout of coins

	la	$a0, q
	li	$v0, 4
	syscall

	move	$a0, $t3
	li	$v0, 1
	syscall

	mfhi	$t2

dr:	# dimes routine
	blt	$t2, 10, nr

	div	$t3, $t2, 10	# t3 is the amout of coins

	la	$a0, d
	li	$v0, 4
	syscall

	move	$a0, $t3
	li	$v0, 1
	syscall

	mfhi	$t2

nr:	# nickle routine
	blt	$t2, 5, pr

	div	$t3, $t2, 5	# t3 is the amout of coins

	la	$a0, n
	li	$v0, 4
	syscall

	move	$a0, $t3
	li	$v0, 1
	syscall

	mfhi	$t2

pr:	# penny routine
	beqz	$t2, end

	la	$a0, p
	li	$v0, 4
	syscall

	move	$a0, $t2	# t2 is number of cents = no. of pennies
	li	$v0, 1
	syscall

	mfhi	$t2
	
	b end

na:
	la	$a0, nc
	li	$v0, 4
	syscall

end:
	li	$v0, 10
	syscall
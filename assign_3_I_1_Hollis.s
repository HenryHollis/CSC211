# Text problem 2.20

	.data
#Test values
t0val:	.word	0x8F0F0F0F	# Test value for $t0
t1val:	.word	0x90A0A0A0	# Test value for $t1

	.text
	.globl	main		#System 'calls' main
	
	# The next two lines I used to help debug my code.
	#  Feel free to ignore these.
main:	lw	$s0, t0val	# Preserve t0val for debugging
	lw	$s1, t1val	# Preserve t1val for debugging

	lw	$t0, t0val	# Load test value into %t0
	lw	$t1, t1val	# Load test value into $t1
	srl     $t0, $t0, 11    # clear bits 0-10 from $t0
        sll     $t0, $t0, 26    # clear bits 31-16 from $t0
        sll     $t1, $t1, 6     # set last 6 bits of $t1 to 0 to make room for insertion
        srl     $t1, $t1, 6	# put bits 25-0 back in original place
        or      $t1, $t1, $t0   # or $t0 with $t1 to insert the 6 bits into $t1

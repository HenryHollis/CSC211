# Text problem 2.27.

	.data
a:	.word	2		# $s0
b:	.word	2		# $s1
i:	.word	0		# $t0
j:	.word	0		# $t1
D:	.word	2, 3, 4, 5

	.text
	.globl   main		#System 'calls' main
	
main:	lw	$s0, a
	lw	$s1, b
	lw	$t0, i
	lw	$t1, j
	la	$s2, D
	
outer_loop:   addi $t0, $t0, 1
	      slt	$t2, $t0, $s0         # set $t2 to 1 if i < a
	      beq	$t2, $zero, Exit      # if i is not smaller than a, exit big loop
	      #the following code executes when i < a:
	      and $t1, $t1, $zero             # reset j = 0
	          
inner_loop:   slt	$t2, $t1, $s1         # set $t2 to 1 if j < b
              beq	$t2, $zero, outer_loop  #when inner loop is done, increment i and repeat outer_loop
              #the following executes while j < b:
              
              add $t2, $t0, $t1	      # add i + j, store the result in $t2
              sll $t3, $t1, 4        # calculates needed offset (j*4)* 4 bytes to get to the correct word index in D, stores result in $t3
              add $t4, $s2, $t3      # adds the offset calculated above to the base address of D, store result in $t4
              sw $t2, 0($t4)         # now D[j*4] contains i + j
              addi $t1, $t1, 1       #j++
              j inner_loop	     # repeat inner loop
              
increment_i: addi $t0, $t0, 1
             j outer_loop


Exit:
	#for MARS, end with the following.
	li	$v0, 10
	syscall

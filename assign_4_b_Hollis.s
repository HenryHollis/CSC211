	.data
N:	.word		4
fn:	.word		0
tmp:	.word		0xFFFFFFFF

	.text
	.globl main
	
main:
	lw $s0, N         # load N into register $s0
	la $s1, fn        # load address of fn, so I can store it later
	add $a0, $0, $s0  # put N into argument register
	jal fib		  # call fib(N)
	sw $v0, 0($s1)    # save result of fib(N) into fn in memory
	
	
	li	$v0, 10        # return to user
	syscall 
	
fib:
	addi $sp, $sp, -12 	# allocate space for 3 words on stack
    	sw   $ra, 0($sp)	# Store the return address
  	sw   $t0, 4($sp)        # A placeholder for fib() to store temp1
  	sw   $t1, 8($sp)        # A placeholder for fib() to store temp2
      	
	addi $t3, $zero, 1    # create a register with 1 to check if N == 1 later in the code
	add $t0, $zero, $a0   # move N argument to $t0 
	
	
	bne   $t0, $zero, check_if_one   # check if base case where n == 0
	addi  $v0, $zero, 0  		 # if so, return 0, if not, check if n == 1
	j ExitProcedure                  # exit procedure
	
check_if_one:				 # check if base case where N == 1 
	bne $t0, $t3, Else	         # if so return 1, if not, jump to recursive step
	addi  $v0, $zero, 1              # return 1
	j ExitProcedure			 # exit procedure
	  
Else:      #recursive step

	addi $a0, $t0, -1   # take the argument and decrement by 1
    	jal fib             # call fib with (n-1)
    	
    	add $t1, $zero, $v0   #t0 = fib(n-1)
    	
    	addi $a0, $t0, -2   #take the argument and decrement by 2
    	jal fib             # call fib with (n-2)
    	
    	add $v0, $t1, $v0   #return fib(n-2) + fib(n-1)
    	

ExitProcedure:

	lw   $ra, 0($sp)   # restore the return address from the stack
    	lw   $t0, 4($sp)   # restore temp1 from the stack
	lw   $t1, 8($sp)   # restore temp2 from the stack
	addi $sp, $sp, 12  # adjust stack pointer to pop 3 items
	jr $ra             # return to caller

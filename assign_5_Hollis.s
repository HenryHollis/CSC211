 	.data
prompt_float:		.asciiz	"Enter a float:"
return_char:		.asciiz "\n"
max_sum_prod:           .asciiz "Max, Sum, Product:\n"
exp_and_signif:         .asciiz "Biased and unbiased exponents and significand of float1:\n"

	.macro console(%x)    # macro to simplify my input/output to console
	la $a0, prompt_float  # load in my string to print("Enter a float")
	li $v0, 4             # system call for printing string
	syscall
	
	li  $v0, 6            # get float from user
	syscall
	
	mov.s %x, $f0         # move float to f0

	li $v0, 2	      # system call code for printing float
	mov.s $f12, %x        # move the entered float to f12, for printing
	syscall		      
	la $a0, return_char   # load in newline char ('\n')
	li $v0, 4             # system call for printing string
	syscall
	.end_macro

	.text			 # Code segment
	
	.globl	main		 # System 'calls' main
main:

console($f1)              # input float1, store in f1
console($f2)              # input float1, store in f2
console($f3)              # input float1, store in f3

	#finding the max of the first 2 floats:
        c.le.s $f1, $f2   # set condition flag 0 to true if $f1 <= $f2
        movt.s  $f6, $f2  # move $f2 to $f6 if $f2 was the max
        movf.s $f6, $f1   # move $f1 to $f6 if $f1 was the max
        
        #extracting the exponent
        mfc1 $s0, $f1
        sll $s1, $s0, 9
        srl $s1, $s1, 9 #s1 holds fraction without hidden bit
        addi $s1, $s1, 8388608 #add the hidden bit, so s1 holds the significand
        sll $s0, $s0, 1
        srl $s0, $s0, 24  #s0 holds biased exponent
        addi $s2, $s0, -127 #s2 holds the unbiased exponent
        
        #Now print all this info:
        la $a0, exp_and_signif  # load in my string to print("Biased and unbiased...")
	li $v0, 4               # system call for printing string
	syscall
	
	li $v0, 1		# system call code for printing int
	move $a0, $s0           # print biased exponent
	syscall
	
	la $a0, return_char     # load in newline character
	li $v0, 4               # system call for printing string
	syscall
	
	li $v0, 1		# system call code for printing int
	move $a0, $s2 		# print unbiased exponent 
	syscall
	la $a0, return_char     # load in newline character
	li $v0, 4               # system call for printing string
	syscall
	
	li $v0, 1		# system call code for printing int
	move $a0, $s1           # print significand
	syscall
	
	la $a0, return_char     # load in newline character
	li $v0, 4               # system call for printing string
	syscall
jal a3fp         # call (f1 + f1) + f3
jal m3fp         # call (f1 * f2) * f3
	
	la $a0, max_sum_prod  # load in my string to print("max, sum, product:")
	li $v0, 4             # system call for printing string
	syscall
	
	li $v0, 2	      # system call code for printing float
	mov.s $f12, $f6	      # print the max
	syscall
	
	la $a0, return_char   # load in newline character
	li $v0, 4             # system call for printing string
	syscall
	
	li $v0, 2	      # system call code for printing float
	mov.s $f12, $f4       # print sum
	syscall
	
	la $a0, return_char   # load newline
	li $v0, 4             # system call for printing string
	syscall
	
	li $v0, 2	      # system call code for printing float
	mov.s $f12, $f5       # print product
	syscall
	
	la $a0, return_char   # load in newline
	li $v0, 4             # system call for printing string
	syscall

Exit:
li	$v0, 10			# return to caller (system)
	syscall

#*******function definitions*******
a3fp:
	add.s $f4, $f1, $f2   # add f1 and f2
	add.s $f4, $f4, $f3   # add sum to f3, total in f4
	jr $ra                # return to caller
m3fp:
	mul.s $f5, $f1, $f2   # same exact logic as function above
	mul.s $f5, $f5, $f3
	jr $ra
	



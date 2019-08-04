	        .data
x:	        .word	10
y:	        .word	200
z:	        .word   0
A:  	        .word   4, 9, 15, 20
result:        	.word	0
input_z:        .asciiz "Enter an integer z: "
input_j:	.asciiz "Enter an int j in [0,3]"
prf:		.asciiz	"The result is:  "	#String for printing
crlf:		.asciiz	"\n"	                #For printing a cr/lf
	.text			 # Code segment
	
	.globl	main		 # System 'calls' main

main:		la $t0, z	 #get the address of z, I'll store something here later	
		la $a0, input_z  #load in my string to print (ENTER z:)
		li $v0, 4        #system call for printing string
		syscall
		
		li $v0, 5        #get z from user
		syscall
		sw $v0, 0($t0)   #store the z value into memory		
				
		lw $t1, x        #get x value
		lw $t2, y        #get y value
		add $t1, $t1, $t2   #$t1 is now x + y
		sub $t1, $t1, $v0   #$t1 is now x + y - z
		
		la $a0, input_j   #load in the string to print (ENTER j)
		li $v0, 4         #system call for printing string
		syscall
		
		li $v0, 5       #get j from user
		syscall
		
		la $t3, A          #get base address of a
		sll $t4, $v0, 2    #take j, multiply it by 4 to get the desired number of bytes from A[base], store result in $t4
		add $t4, $t4, $t3  #add this new number to the base address of A and place it in $t4
		lw $t4, 0($t4)     #now $t4 has the value of A[j]
		add $t1, $t1, $t4  # calculate x + y - z + A[j] and place in $t1
		
		la $t5, result    #get memory adress of result, place in $t5
		sw $t1, 0($t5)	  #store the answer to the expression in result's memory address
		
		li $v0, 4         #system call for printing string
		la $a0, prf       #load string to print (RESULT IS)
		syscall
		li $v0, 1            #system call for printing int
		add $a0, $t1, $zero  #load answer to print
		syscall
		
		li $v0, 4       #system call for printing string
		la $a0, crlf	#load string to print (\n)
		syscall	
		
		li	$v0, 10			# return to caller (system) – For MARS
		syscall
		

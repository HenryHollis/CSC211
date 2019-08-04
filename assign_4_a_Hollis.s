	.data
N:	.word		8
arr:	.word		16, 8, 5, 3, 1, 7, 63, 31
ES:     .asciiz         " "
tmp:	.word		0xFFFFFFFF

  	.text
	.globl	main		#System 'calls' main
	
main:
	la $s0, arr
	lw $s1, N
	srl $s2, $s1, 1
	add $s3, $zero, $zero  #create a counter i in $s3
	
	add $t1, $zero, $zero #I want to keep track of the offset of a[i] seperately from i
				    # on this first pass, the base-address-offset should be zero
Loop: 
	slt $t0, $s3, $s2   # if i < N/2 set $t0 to 1
	beq $t0, $zero, SET_UP
	add $t1, $t1, $s0   # add the offset to the base address
	add $a0, $t1, $zero # pass arr as an argument
	add $a1, $s3, $zero # pass a[i] as an argument
	jal swapgt
	addi $s3, $s3, 1    # i++
	sll $t1, $s3, 2     # I now want to increase the base-address-offset by i*4 (to make it word addressable)
	j Loop
		
swapgt:
	sll $t0, $a1, 2   # calculate the offset of i from a[o] and store in $t0
	addi $t1, $t0, 4  # calculate the offset of i+1 from a[0] and store in $t1
	add $t0, $t0, $a0 # now $t0 holds the address of &a[i]
	add $t1, $t1, $a0 # now $t1 holds the address of &a[i+1]
	lw $t3, 0($t0)    # now $t3 holds value of a[i]
	lw $t4, 0($t1)    # now $t4 holds value of a[i+1]
	
			  # To sum up: &a[i] is in t0  &a[i+1] is in t1
	                  # and         a[i] is in t3   a[i+1] is in t4
	                  
        slt $t2, $t4, $t3 # set $t2 to 1 if a[i+1] < a[i]
        beq $t2, $zero, DontSwap # if a[i+1] >= a[i] then dontSwap
        sw $t4, 0($t0)      # now a[i] holds the old a[i+1]
        sw $t3, 0($t1)      # and a[i+1] holds the old a[i]
        addi $v0, $zero, 1  # return a 1 because a swap occured 
        jr $ra              # return to caller
DontSwap: 
       	add $v0, $zero, $zero # return a 0 because a swap occured 
        jr $ra                # return to caller
        
SET_UP:
	lw $s7, N # N should be the size of the array, in this case 8
	move $s1, $zero
	move $s2, $zero
	
PRINT_LOOP:
	bge $s1, $s7, Exit #If we are done sorting, jump to the Exit label
	lw $a0, arr($s2) #Print the current element in the array
	li $v0, 1
	syscall
	la $a0, ES #Print empty space
	li $v0, 4
	syscall
	addi $s1, $s1, 1 #Increment the loop counter
	addi $s2, $s2, 4 #Move to the next element in the array
	j PRINT_LOOP #Keep on printing until you are done
	
Exit:
	li	$v0, 10        # return to user
	syscall

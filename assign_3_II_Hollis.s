	.data
N:	.word	7
sum:	.word	0
max:	.word	0
hld1:	.word 0xAAAAAAAA
vals:	.word	5, 8, 1, -3, 7, 10, 2
i:       .word   0
tempMax: .word   0
space:   .asciiz " "
hld2:	.word 0xFFFFFFFF
	
	.text
	.globl   main		#System 'calls' main
	

main:	lw $s0 sum
	lw $s1 max
	la $s2 vals
	lw $s3 N
	lw $t0 i
	lw $s4 tempMax
	
# loop for finding the max and sum:

lw $t2, 0($s2)     #these two lines assign vals[0] to max, this is better than assuming max is 0
add $s4, $t2, $0

Loop1: slt $t1, $t0, $s3   # is i < N ?
      beq $t1, $0, Exit1   # exit loop when i == N
      sll $t1, $t0, 2      # mulitply i * 4 to get an offset for the array
      add $t1, $s2, $t1    # add base address of vals to offset in order to go to the correct index in the array
      lw  $t2, 0($t1)      # reg $t2 now has the word at vals[i]
      add $s0, $t2, $s0	   # add vals[i] to running sum
      slt $t1, $s4, $t2    # is the old candidate for max smaller than the current vals[i]?
      beq $t1, $0 skipLine # if so, update the max to the bigger value, else skipLine
      add $s4, $t2, $0     # updates the max to the bigger number
skipLine:
      addi $t0, $t0, 1     # i++
      j Loop1              # repeat loop
      
Exit1:
      sw $s4, max     # store max back into memory
      sw $s0, sum     # store sum back into memory
      add $t0, $0, $0 # reset i
      
      #printing to the console:
   
      lw $a0, sum        # output the sum integer value
      li $v0, 1          # system call for printing int
      syscall
      
      la $a0, space      # load space into $a0
      li $v0, 4          # system call for printing a string
      syscall
 
      lw $a0, max        # output the max integer value
      li $v0, 1          # system call for printing int
      syscall




#BubbleCode:
										
Loop2: slt $t1, $t0, $s3  # is i < N ?
      beq $t1, $0, Exit2  # exit loop when i == N
      sll $t1, $t0, 2     # mulitply i * 4 to get an offset for vals[i]
      subi $t7 $s3, 1     # get n-2 because I dont want to swap the last element with an elment out of bounds
      addi $t3, $t1, 4    # get the offest for vals[i+1]
      add $t5, $s2, $t1   # add base address of vals to offset in order to go to vals[i]
      add $t6, $s2, $t3   # add the base address of vals to vals[i+1] offset to go to vals[i+1]
      lw  $t2, 0($t5)     # reg $t2 now has the word at vals[i]
      lw  $t4, 0($t6)	  # register $t4 now has word at vals[i+1]
      beq $t7, $t0, dontSwap  # only swap if i < n-2, I dont want to swap the last element with the next outOfBounds element
      slt $t1, $t4, $t2    # is vals[i+1] < vals[i] ??
      beq $t1, $0 dontSwap # if so, swap, else, dontSwap
      sw $t4, 0($t5)       # store swapped words back into vals array
      sw $t2, 0($t6)
dontSwap:           
      addi $t0, $t0, 1 # increment i
      j Loop2          # repeat loop
      
Exit2:




	

.data 
	input: .space 20
	output: .space 20
	giveWord: .asciiz "Enter the string: "
	reverseWord: .asciiz "Reverse string: "
.text
	main: 
		# Printing the message
		li $v0, 4
		la $a0, giveWord
		syscall
	
		# Getting the string from the user
		li $v0, 8
		# The adress of string in a0
		la $a0, input
		# The length of string in a1
		li $a1, 20
		syscall
		# Moving the array to t1, because a0 will be useful in another way
		move $t1, $a0
		
		push: 
			# Getting the one char from the array
			lb $t0, ($t1)
			beqz $t0, pop
			
			# Allocate the memory stack
			addi $sp, $sp, -4
			# Store the char on the stack
			sw $t0, ($sp)
			# Shift the ref on next char in array
			addi $t1, $t1, 1
			j push
			
			pop: 
				# The adress of the array
				la $t1, input
				
				print: 
					# Get the byte from the array to detect the end of string
					lb $t0, ($t1)
					beqz $t0, printEnd
					
					# Load the char from the stack
					lw $t0, ($sp)
					# Delete the one cell on the stack
					addi $sp, $sp, 4
					# Store the char in the array
					sb $t0, ($t1)
					# Shift the ref on the next char in array
					addi $t1, $t1, 1
					j print
		
					printEnd:
						# Printing the message
						li $v0, 4
						la $a0, reverseWord
						syscall
						
						# Printing the reverseWord
						li $v0, 4
						la $a0, input
						syscall
						
						# The end of programm
						li $v0, 10
						syscall
		
	
              
       

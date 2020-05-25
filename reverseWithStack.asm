.data
	str: .space 100
	enterString: .asciiz "Enter the string: "
	reversedString: .asciiz "Reversed string: "
.text
	main:
		# Printing the message
		li $v0, 4
		la $a0, enterString
		syscall
		
		# Getting the string from the user
		li $v0, 8
		#Load int the str
		la $a0, str
		li $a1, 100
		syscall
		move $t1, $a0
		# The number of element on stack
		li $s0, 0
		
		push: 
			lb $t0, ($t1)
			beqz $t0, reverse
			
			# Allocate the memory on stack
			addi $sp, $sp, -4
			# Adding on the stack
			sw $t0, ($sp)
			# Shift in the array by one char
			addi $t1, $t1, 1
			# Increment the size of stack
			addi $s0, $s0, 1
			
			j push
			
			reverse: 
				# Printing the message
				li $v0, 4
				la $a0, reversedString
				syscall
				
				# The counter of printing chars
				li $s1, 0
				
				print: 
					bge $s1, $s0, printEnd
					
					# Pop the char
					lw $a0, ($sp)
					li $v0, 11
					syscall
					# Delete the cell on the stack
					addi $sp, $sp, 4
					# Increment the number of printed elements
					addi $s1, $s1, 1
					
					j print
					
					printEnd:
						# The end of programm
						li $v0, 10
						syscall
					
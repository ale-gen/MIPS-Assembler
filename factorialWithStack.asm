.data
	result: .space 4
	n: .asciiz "Podaj wartosc n, dla ktorej chcesz obliczyc silnie: "
	resultMessage: .asciiz "Wynik = "
.text
	main:
		# Printing the task
		li $v0, 4
		la $a0, n
		syscall
		
		# Getting the number from the user
		li $v0, 5
		syscall
		addi $sp, $sp, -4
		move $a1, $v0
		
		jal factorial
		
		# We come back here when the factorial will be counted
		# Load adress of result
		la $t0, result
		# Save the result to data $t0
		sw $v0, ($t0)
		
		# Print the result message  
		li $v0, 4
		la $a0, resultMessage
		syscall
		
		# Print the result
		lw $a0, ($t0)
		li $v0, 1
		syscall
		
		# The end of programm
		li $v0, 10
		syscall
		
		factorial: 
			# Move on the stack, and save the $ra from the last jump
			addi $sp, $sp, -4
			sw $ra, ($sp)
			# While n > 0, store n on the stack
			bnez $a1, notZero
			
			# 1! = 0
			li $v0, 1
			lw $ra, ($sp)
			addi $sp, $sp, 4
			
			jr $ra	
			
			notZero:
				# Store n on the stack
				addi $sp, $sp, -4
				sw $a1, ($sp)
				# n--
			 	subi $a1, $a1, 1
			 	
			 	jal factorial
			 	
			 	# If n = 0 or come back from $ra, we load the result of n(n-1) on stack
			 	lw $t0, ($sp)
			 	addi $sp, $sp, 4
			 	# n(n-1)
			 	mul $v0, $v0, $t0
			 	# Load the $ra again
			 	lw $ra, ($sp)
			 	addi $sp, $sp, 4
			 	
			 	jr $ra
			 	

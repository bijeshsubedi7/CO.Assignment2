.data
userInput: .space 1001

.text
main:
	# Inputing the data from the user
	li $v0, 8		# Asking the OS to input a string
	la $a0, userInput	# Specifying where the input would be stored
	la $a1, 1001		# Specifying the max-size of the input
	syscall			# Performing the system call to input the string
	
	# Calling the function to trim the space from front and behind
	jal trimSpace	
	la  $t0, ($v0)	# Storing the starting address of the string
	
	loop:	lb $t1, ($t0)		# Loading the byte value at address pointed by $t0
		beq $t1, 0, exitLoop	# If the loaded byte is end of the line character then we exit the loop
		
		# Printing the integer value of the loaded byte for the testing purpose		
		li $v0, 11		# Asking the OS to print an integer
		la $a0, ($t1)		# Passing the byte to be printed
		syscall			# Making the system call to print
		
		# Printing the new line character
		li $v0, 11
		li $a0, 10
		syscall
		
		# Increasing the value of the pointer to point to the next character in the string and looping
		addu $t0, $t0, 1
		j loop
	exitLoop:
	# Syscall to end the program
	li $v0, 10
	syscall
	
trimSpace:
# Fucntion to trim the spaces from infront and back of the input
# Takes argument in $a0
# Returns the start address of the string in $t0
	# Loop 1 marks the beginning of the string by getting rid of all the tabs and the spaces in front of the string
	loop1:	lb  $t7, ($a0)			# Loading the character pointed by the address at $a0
		beq $t7, 0, exitLoop1		# If the character is the end of the line character we exit the loop
		beq $t7, 32, continueLoop1	
		beq $t7, 9, continueLoop1
		j   exitLoop1
		continueLoop1:
		addi $a0, $a0, 1
		j    loop1
	exitLoop1:
	la $v0, ($a0)
	li $t6, 0 	# The number of space
	
	# Loop 2 marks the end of the string by getting rid of all the tabs and the spaces at the end of the string
	loop2: 	lb  $t5, ($a0)		# Storing the byte a0 is pointing to in $t5
		beq $t5, 0, exitLoop2	# If the pointer reaches the end of the string 
		beq $t5, 10, exitLoop2	# If the pointer points to the newLine exit the loop
		beq  $t5, 32, whiteSpace # If a space is found we perform related operations in whiteSpace label
		beq  $t5, 9,  whiteSpace # If a tab is found we perform related operations in whiteSpace label
		li   $t6, 0
		j    continueLoop2
		whiteSpace:		# Operations to perform when we encounter a white space
		addi $t6, $t6, 1
		continueLoop2:		# Loop related increaments
		addi $a0, $a0, 1
		j    loop2
	exitLoop2:
	sub $a0, $a0, $t6		# $a0 now points to the last character disregarding all the tabs and spaces at the end
	li  $t7, 0			# $t7 stores end of the line character
	sb  $t7, ($a0)			# End of the character is inserted at the end of the valid character
	jr  $ra				# Returning control to the main program

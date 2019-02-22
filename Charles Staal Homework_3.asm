.data
NameStr: .space 128
AgeStr: .space 4
SelectionStr: .space 16
#Written to spec, including typos
InputNameStr: .asciiz "Please enter your name:"
ServicePromptStr: .asciiz "\nWhat type of service do you need-\nNew License,\nLicense Renewal,\nNew Plate,\nPlate Renewal,\nor Lerner permit\n\nplease enter:"
NLPromptStr: .asciiz "New license"
LRPromptStr: .asciiz "License Renewal"
NPPromptStr: .asciiz "New Plate"
PRPromptStr: .asciiz "Plate Renewal"
LPPromptStr: .asciiz "Lerner permit"
AgePromptStr: .asciiz "Your age please: "
AgeAndStarsPromptStr: .asciiz "**************************\n***\n***\n\nYour age please: "
PrintingPromptStr: .asciiz "\nprinting Ticket.........\n\n"
NameDisplayStr: .asciiz "Name:"
PurposeDisplayStr: .asciiz "purpose:"
AgeDisplayStr: .asciiz "\nage:"
NewLine: .asciiz "\n"
.text

main:

	#Asks for name
	la $a0, InputNameStr #Loads Prompt in to a0 register
	li $v0, 4 #prints a0 register
	syscall

	#Reads string, stores word
	la $a0, NameStr #Reads the input
	li $a1, 128 #At most 127 characters + null terminator
	li $v0, 8 #Reads String
	syscall
	
	#Displays Service Prompt 
	la $a0, ServicePromptStr #Loads service prompt in to a0 register
	li $v0, 4 #prints a0 register
	syscall
	
	#Reads string, stores word
	la $a0, SelectionStr
	li $a1, 16 #At most 15+ null terminator
	li $v0, 8 #Reads string
	syscall
	
	#Prints the stars
	la $a0, AgeAndStarsPromptStr
	li $v0, 4 #prints a0 register
	syscall
	
	#Reads integer, stores
	li $v0, 5 #Reads integer
	syscall
	sw $v0, AgeStr
	
	#Displays Printing Ticket message
	la $a0, PrintingPromptStr
	li $v0, 4
	syscall
	
	#Displays all the things
	la $a0, NameDisplayStr
	li $v0, 4
	syscall
	
	la $a0, NameStr
	li $v0, 4
	syscall
	
	la $a0, PurposeDisplayStr
	li $v0, 4
	syscall
	
	la $a0, SelectionStr
	li $v0, 4
	syscall
	
	la $a0, AgeDisplayStr
	li $v0, 4
	syscall
	
	li $v0, 1
	lw $a0, AgeStr
	syscall
	
	la $a0, NewLine #So the desired output matches that of the sheet
	li $v0, 4
	syscall
	
	#exit
	li $v0, 10
	syscall
	

	
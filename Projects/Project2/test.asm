.data
str_input: .asciiz "Input: "
str_result: .asciiz "Result: "
str_return: .asciiz "Return: "

# toUpper
toUpper_TC1: .asciiz ""
toUpper_TC2: .asciiz "ALLUPPERCASECHARACTERS"
toUpper_TC3: .asciiz "alllowercasecharacters"
toUpper_TC4: .asciiz "CamelCaseTestingString"
toUpper_TC5: .asciiz "#symbols & spaces!"

# length2Char
length2Char_TC: .asciiz "Looking for characters."
length2Char_char1: .asciiz "o" 
length2Char_char2: .asciiz " " 
length2Char_char3: .asciiz "." 
length2Char_char4: .asciiz "" 

# strcmp
strcmp_header: .asciiz "\n\n********* strcmp *********\n"
strcmp_str1: .asciiz "Hi Cse220!"
strcmp_str2: .asciiz "Hi Cse220!"
strcmp_str3: .asciiz "Hi Cse220! Isn't MIPS fun"

# toMorse1
toMorse_plaintext1: .asciiz "ABC"
toMorse_plaintext2: .asciiz "ABCdE"
toMorse_plaintext3: .asciiz "ABCdE"
toMorse_plaintext4: .asciiz ""
toMorse_plaintext5: .asciiz "ABC"
toMorse_mcmsg1: .space 24
toMorse_mcmsg2: .space 24
toMorse_mcmsg3: .space 24
toMorse_mcmsg4: .space 24
toMorse_mcmsg5: .space 4
.align 2
toMorse_size1: .word 24
.align 2
toMorse_size2: .word 24
.align 2
toMorse_size3: .word -10
.align 2
toMorse_size4: .word 24
.align 2
toMorse_size5: .word 4

# createKey
createKey_phrase1: .asciiz "computer science is fun"
createKey_phrase2: .asciiz "Computer_Science!Is^Fun!!!"
createKey_phrase3: .asciiz ""
createKey_phrase4: .asciiz "Computer Science Is Fun"
createKey_key1: .space 26
			   .byte 0
createKey_key2: .space 26
			   .byte 0
createKey_key3: .space 26
			   .byte 0
createKey_key4: .space 26
			   .byte 0

# Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_INT 1
.eqv PRINT_HEX 34
.eqv NULL 0x0

.macro print_string(%address)
	li $v0, PRINT_STRING
	la $a0, %address
	syscall 
.end_macro

.macro print_ready_string(%str)
	.data
		Label: .asciiz %str
	.text
		li $v0, 4
		la $a0, Label
		syscall
.end_macro
.macro print_string_reg(%reg)
	li $v0, PRINT_STRING
	la $a0, 0(%reg)
	syscall 
.end_macro

.macro print_hex(%reg)
	li $v0, PRINT_HEX
	la $a0, 0(%reg)
	syscall
.end_macro

.macro print_newline
	li $v0, 11
	li $a0, '\n'
	syscall 
.end_macro

.macro print_space
	li $v0, 11
	li $a0, ' '
	syscall 
.end_macro

.macro print_int(%register)
	li $v0, 1
	add $a0, $zero, %register
	syscall
.end_macro

.macro print_char_addr(%address)
	li $v0, 11
	lb $a0, %address
	syscall
.end_macro

.macro print_char_reg(%reg)
	li $v0, 11
	move $a0, %reg
	syscall
.end_macro

.macro exit_program
	li $v0, 10
	syscall
.end_macro

.globl main

main:

.text

	############################################
	# TEST CASE 1 for toUpper	
	############################################
	print_ready_string("=== TESTING toUpper - Test Case 1: Empty String ===\n")
	print_string(str_input)
	print_string(toUpper_TC1) 
	print_newline

	la $a0, toUpper_TC1
	jal toUpper

	move $t0, $v0
	print_string(str_result)	
	print_string_reg($t0) 
	print_newline
	print_string(str_result)
	print_hex($t0) 
	print_newline
	print_newline
	
	############################################
	# TEST CASE 2 for toUpper	
	############################################
	print_ready_string("=== TESTING toUpper - Test Case 2: All uppercase characters ===\n")
	print_string(str_input)
	print_string(toUpper_TC2) 
	print_newline

	la $a0, toUpper_TC2
	jal toUpper

	move $t0, $v0
	print_string(str_result)	
	print_string_reg($t0) 
	print_newline
	print_newline
	
	############################################
	# TEST CASE 3 for toUpper	
	############################################
	print_ready_string("=== TESTING toUpper - Test Case 3: All lowercase characters in string ===\n")
	print_string(str_input)
	print_string(toUpper_TC3) 
	print_newline

	la $a0, toUpper_TC3
	jal toUpper

	move $t0, $v0
	print_string(str_result)	
	print_string_reg($t0) 
	print_newline
	print_newline
	
	############################################
	# TEST CASE 4 for toUpper	
	############################################
	print_ready_string("=== TESTING toUpper - Test Case 4: Camel Case string ===\n")
	print_string(str_input)
	print_string(toUpper_TC4) 
	print_newline

	la $a0, toUpper_TC4
	jal toUpper

	move $t0, $v0
	print_string(str_result)	
	print_string_reg($t0) 
	print_newline
	print_newline
	
	############################################
	# TEST CASE 5 for toUpper	
	############################################
	print_ready_string("=== TESTING toUpper - Test Case 5: Symbols and spaces ===\n")
	print_string(str_input)
	print_string(toUpper_TC5) 
	print_newline

	la $a0, toUpper_TC5
	jal toUpper

	move $t0, $v0
	print_string(str_result)	
	print_string_reg($t0) 
	print_newline
	print_newline
	
	############################################
	# TEST CASE 1 for length2Char
	############################################
	print_ready_string("=== TESTING length2char - Test Case 1: Character appears multiple times in String ===\n")
	print_string(str_input)
	print_string(length2Char_TC)
	print_newline

	la $a0, length2Char_TC
	la $a1, length2Char_char1
	jal length2Char

	move $t0, $v0
	print_string(str_return)
	print_int($t0)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 2 for length2Char
	############################################
	print_ready_string("=== TESTING length2char - Test Case 1: Character appears multiple times in String ===\n")
	print_string(str_input)
	print_string(length2Char_TC)
	print_newline

	la $a0, length2Char_TC
	la $a1, length2Char_char2
	jal length2Char

	move $t0, $v0
	print_string(str_return)
	print_int($t0)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 3 for length2Char
	############################################
	print_ready_string("=== TESTING length2char - Test Case 3: Looking for punctuation ===\n")
	print_string(str_input)
	print_string(length2Char_TC)
	print_newline

	la $a0, length2Char_TC
	la $a1, length2Char_char3
	jal length2Char

	move $t0, $v0
	print_string(str_return)
	print_int($t0)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 4 for length2Char
	############################################
	print_ready_string("=== TESTING length2char - Test Case 4: Looking for NULL ===\n")
	print_string(str_input)
	print_string(length2Char_TC)
	print_newline

	la $a0, length2Char_TC
	la $a1, length2Char_char4
	jal length2Char

	move $t0, $v0
	print_string(str_return)
	print_int($t0)
	print_newline
	print_newline

	############################################
	# TEST CASE 1 for strcmp
	############################################
	print_ready_string("=== TESTING strcmp Test Case 1: numCompares = -3 ===\n")
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str2)
	print_newline
	print_string(str_input)
	li $t1, -3
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str2
	li $a2, -3
	jal strcmp

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 2 for strcmp
	############################################
	print_ready_string("=== TESTING strcmp Test Case 2: Matching strings ===\n")
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str2)
	print_newline
	print_string(str_input)
	li $t1, 0
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str2
	li $a2, 0
	jal strcmp

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 3 for strcmp
	############################################
	print_ready_string("=== TESTING strcmp Test Case 3: Matching substring ===\n")
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str3)
	print_newline
	print_string(str_input)
	li $t1, 0
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str3
	li $a2, 0
	jal strcmp

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 4 for strcmp
	############################################
	print_ready_string("=== TESTING strcmp Test Case 4: Matching substring with larger numCompares ===\n")
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str3)
	print_newline
	print_string(str_input)
	li $t1, 15
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str3
	li $a2, 15
	jal strcmp

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 5 for strcmp
	############################################
	print_ready_string("=== TESTING strcmp Test Case 5: Matching strings with larger numCompares than string length ===\n")
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str3)
	print_newline
	print_string(str_input)
	li $t1, 15
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str3
	li $a2, 15
	jal strcmp

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 6 for strcmp
	############################################
	print_ready_string("=== TESTING strcmp Test Case 6: Matching substrings with numCompares smaller than substring length ===\n")
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str3)
	print_newline
	print_string(str_input)
	li $t1, 5
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str3
	li $a2, 5
	jal strcmp

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 7 for strcmp
	############################################
	print_ready_string("=== TESTING strcmp Test Case 7: Matching strings with larger numCompares than string length ===\n")
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str2)
	print_newline
	print_string(str_input)
	li $t1, 6
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str2
	li $a2, 6
	jal strcmp

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 8 for strcmp
	############################################
	print_ready_string("=== TESTING strcmp Test Case 8: Matching substrings with larger numCompares substring length ===\n")
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str3)
	print_newline
	print_string(str_input)
	li $t1, 15
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str3
	li $a2, 15
	jal strcmp

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 1 for toMorse
	############################################
	print_ready_string("=== TESTING toMorse Test Case 1: Basic string ==\n")
	print_string(str_input)
	print_string(toMorse_plaintext1)
	print_newline
	print_string(str_input)
	print_string(toMorse_mcmsg1)
	print_newline
	print_string(str_input)
	lw $t9, toMorse_size1
	print_int($t9)
	print_newline

	la $a0, toMorse_plaintext1
	la $a1, toMorse_mcmsg1
	lw $a2, toMorse_size1
	jal toMorse

	move $t0, $v0
	move $t1, $v1

	print_string(str_result)
	print_string(toMorse_mcmsg1)
	print_newline
	
	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 2 for toMorse
	############################################
	print_ready_string("=== TESTING toMorse Test Case 2: Basic string with lowercase char ===\n")
	print_string(str_input)
	print_string(toMorse_plaintext2)
	print_newline
	print_string(str_input)
	print_string(toMorse_mcmsg2)
	print_newline
	print_string(str_input)
	lw $t9, toMorse_size2
	print_int($t9)
	print_newline

	la $a0, toMorse_plaintext2
	la $a1, toMorse_mcmsg2
	lw $a2, toMorse_size2
	jal toMorse

	move $t0, $v0
	move $t1, $v1

	print_string(str_result)
	print_string(toMorse_mcmsg2)
	print_newline

	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline

	############################################
	# TEST CASE 3 for toMorse
	############################################
	print_ready_string("=== TESTING toMorse Test Case 3: Size is < 0 ===\n")
	print_string(str_input)
	print_string(toMorse_plaintext3)
	print_newline
	print_string(str_input)
	print_string(toMorse_mcmsg3)
	print_newline
	print_string(str_input)
	lw $t9, toMorse_size3
	print_int($t9)
	print_newline

	la $a0, toMorse_plaintext3
	la $a1, toMorse_mcmsg3
	lw $a2, toMorse_size3
	jal toMorse

	move $t0, $v0
	move $t1, $v1

	print_string(str_result)
	print_string(toMorse_mcmsg3)
	print_newline

	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline

	############################################
	# TEST CASE 4 for toMorse
	############################################
	print_ready_string("=== TESTING toMorse Test Case 4: NULL plaintext ===\n")
	print_string(str_input)
	print_string(toMorse_plaintext4)
	print_newline
	print_string(str_input)
	print_string(toMorse_mcmsg4)
	print_newline
	print_string(str_input)
	lw $t9, toMorse_size4
	print_int($t9)
	print_newline

	la $a0, toMorse_plaintext4
	la $a1, toMorse_mcmsg4
	lw $a2, toMorse_size4
	jal toMorse

	move $t0, $v0
	move $t1, $v1

	print_string(str_result)
	print_string(toMorse_mcmsg4)
	print_newline

	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline

	############################################
	# TEST CASE 5 for toMorse
	############################################
	print_ready_string("=== TESTING toMorse Test Case 5: Basic string with buffer smaller than required ===\n")
	print_string(str_input)
	print_string(toMorse_plaintext5)
	print_newline
	print_string(str_input)
	print_string(toMorse_mcmsg5)
	print_newline
	print_string(str_input)
	lw $t9, toMorse_size5
	print_int($t9)
	print_newline

	la $a0, toMorse_plaintext5
	la $a1, toMorse_mcmsg5
	lw $a2, toMorse_size5
	jal toMorse

	move $t0, $v0
	move $t1, $v1

	print_string(str_result)
	print_string(toMorse_mcmsg5)
	print_newline

	print_string(str_return)
	print_int($t0)
	print_ready_string(",")
	print_int($t1)
	print_newline
	print_newline

	############################################
	# TEST CASE 1 for createKey
	############################################
	print_ready_string("=== TESTING createKey Test Case 1: Basic string ===\n")
	print_string(str_input)
	print_string(createKey_phrase1)
	print_newline
	print_string(str_input)
	print_string(createKey_key1)
	print_newline

	la $a0, createKey_phrase1
	la $a1, createKey_key1
	jal createKey

	print_string(str_result)
	print_string(createKey_key1)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 2 for createKey
	############################################
	print_ready_string("=== TESTING createKey Test Case 2: Basic string with symbols ===\n")
	print_string(str_input)
	print_string(createKey_phrase2)
	print_newline
	print_string(str_input)
	print_string(createKey_key2)
	print_newline

	la $a0, createKey_phrase2
	la $a1, createKey_key2
	jal createKey

	print_string(str_result)
	print_string(createKey_key2)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 3 for createKey
	############################################
	print_ready_string("=== TESTING createKey Test Case 3: NULL string ===\n")
	print_string(str_input)
	print_string(createKey_phrase3)
	print_newline
	print_string(str_input)
	print_string(createKey_key3)
	print_newline

	la $a0, createKey_phrase3
	la $a1, createKey_key3
	jal createKey

	print_string(str_result)
	print_string(createKey_key3)
	print_newline
	print_newline
	
	############################################
	# TEST CASE 4 for createKey
	############################################
	print_ready_string("=== TESTING createKey Test Case 4: Mixed upper and lower case ===\n")
	print_string(str_input)
	print_string(createKey_phrase4)
	print_newline
	print_string(str_input)
	print_string(createKey_key4)
	print_newline

	la $a0, createKey_phrase4
	la $a1, createKey_key4
	jal createKey

	print_string(str_result)
	print_string(createKey_key4)
	print_newline
	print_newline
	
	exit_program
	
	.include "Charles Staal Project_2.asm"

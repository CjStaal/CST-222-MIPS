##############################################################
# Do NOT modify this file.
# This file is NOT part of your homework 2 submission.
##############################################################

.data
str_input: .asciiz "Input: "
str_result: .asciiz "Result: "
str_return: .asciiz "Return: "

# toUpper
toUpper_header: .asciiz "\n\n********* toUpper *********\n"
toUpper_CSisFun: .asciiz "Computer Science is fun."

# length2Char
length2Char_header: .asciiz "\n\n********* length2Char *********\n"
length2Char_char: .asciiz "S"
length2Char_CSisFun: .asciiz "Computer Science is fun."

# strcmp
strcmp_header: .asciiz "\n\n********* strcmp *********\n"
strcmp_str1: .asciiz "MIPS!!"
strcmp_str2: .asciiz "MIPS - Millions.of.Instruction.Per...Second"

# toMorse
toMorse_header: .asciiz "\n\n********* toMorse *********\n"
toMorse_plaintext: .asciiz "MIPS!!"
toMorse_mcmsg: .space 30
.align 2
toMorse_size: .word 30

# createKey
createKey_header: .asciiz "\n\n********* createKey *********\n"
createKey_phrase: .asciiz "Computer Science is fun."
createKey_key: .space 26
			   .byte 0

# keyIndex
keyIndex_header: .asciiz "\n\n********* keyIndex *********\n"
keyIndex_mcmsg: .asciiz "--x..x.--.x...xx..xx..-.x-.-.--xx"

# FMCEncrypt
FMCEncrypt_header: .asciiz "\n\n********* FMCEncrypt *********\n"
FMCEncrypt_plaintext: .asciiz "GO SEAWOLVES!"
FMCEncrypt_phrase: .asciiz "Computer Science is cool!"
FMCEncrypt_encryptBuffer: .space 100
.align 2
FMCEncrypt_size: .word 100

# FMCDecrypt
FMCDecrypt_header: .asciiz "\n\n********* FMCDecrypt *********\n"
FMCDecrypt_ciphertext: .asciiz "AWHCQTUWFIJTEMNU"
FMCDecrypt_phrase: .asciiz "Computer Science is cool!"
FMCDecrypt_decryptBuffer: .space 100
.align 2
FMCDecrypt_size: .word 100

# fromMorse
fromMorse_header: .asciiz "\n\n********* fromMorse *********\n"
fromMorse_morsecode: .asciiz " --x..x.--.x...x-.-.--x-.-.--"
fromMorse_plaintextBuffer: .space 30
.align 2
fromMorse_size: .word 30


# Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_INT 1
.eqv NULL 0x0

.macro print_string(%address)
	li $v0, PRINT_STRING
	la $a0, %address
	syscall 
.end_macro

.macro print_string_reg(%reg)
	li $v0, PRINT_STRING
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

.text
.globl main

main:

	############################################
	# TEST CASE for length2Char
	############################################
	print_string(length2Char_header)
	print_string(str_input)
	print_string(length2Char_CSisFun)
	print_newline

	la $a0, length2Char_CSisFun
	la $a1, length2Char_char 
	jal length2Char

	move $t0, $v0
	print_string(str_return)
	print_int($t0)
	print_newline

	# QUIT Program
quit_main:
	li $v0, QUIT
	syscall



#################################################################
# Student defined functions will be included starting here
#################################################################

.include "Charles Staal Project_2.asm"
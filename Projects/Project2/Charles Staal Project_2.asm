##############################################################
# Homework #2
# name: Charles Staal
# scccid: 01040168
##############################################################
.text
##############################
# PART 1 FUNCTIONS 
##############################

toUpper:
	# a0 is string, a1 length of string
	# t0 is counter
	# t1 is char value
	# t2 is memory address of #a0
	# a0 = string uppcased
	# v0 = return value
	la $t3, ($a0)
	li $t0, 0
	li $t1, 0
	li $t2, 0
	loopToUpper:
		beq $a1, $t0, doneToUpper		# if t0 = length of string, it is finished
		lb  $t1,($t2)					# load the byte to be manipulated from the address
		beq $t1, $0, doneToUpper		# if a null bit, we are at the end of the string
		blt $t1, 'a', endofloopToUpper	# if char is less than 97 skip it
		bgt $t1, 'z', endofloopToUpper	# or if char is greater than 122 skip it
		and $t1, $t1, '_'				# bitwise AND to clear 5th bit 
		sb $t1, ($t2)					# Store the manipulated byte to the address
		endofloopToUpper:				#
		addi $t0, $t0, 1				# Increase counter
		addi $t2, $t2, 1				# Go to next byte
		b loopToUpper					#
	doneToUpper:						#
	move $v0, $a0						#
	jr $ra								# return to main

length2Char:
	# v0 = counter/ strlength
	# a0 = string
	# a1 = specified terminator
	# t1 = string address
	li $v0, 0
	la $t1, ($a0)						# Load string address
	loopLength2Char:					#
		lb $t0, ($t1)					# load char
		beq $t0, $a1, doneLength2Char	# if char = terminator
		addi $v0, $v0, 1				# increase counter
		addi $t1, $t1, 1				# go to next byte
		b loopLength2Char				#
	doneLength2Char:					#
	jr $ra								#

strcmp:
	# a0 = str1
	# t0 = str1 address
	# a1 = str2
	# t1 = str2 address
	# a2 = length
	# t2 = length of str1
	# t3 = length of str2
	move $s0, $a0						# save str1 to s0
	move $s1, $a1						# save str2 to s1
	move $s2, $a2						# save length to s2
	li $a1, 0							# set terminator to null for length2char
	jal length2Char						# call length2char for str2
	move $t2, $v0						# move return value to t2
	move $a0, $s1						# move str2 to argument
	jal length2Char						# call length2char for str2
	move $t3, $v0						# move return value to t3
	move $a0, $s0						# recall str1 to a0
	move $a1, $s1						# recall str2 to a1
	move $a2, $s2						# recall length to a2

		 
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

toMorse:
	#Define your code here
	jr $ra

createKey:
	#Define your code here
	jr $ra

keyIndex:
	#Define your code here
	jr $ra

FMCEncrypt:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

##############################
# EXTRA CREDIT FUNCTIONS
##############################

FMCDecrypt:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

fromMorse:
	#Define your code here
	jr $ra

.data
MorseCode: .word MorseExclamation, MorseDblQoute, MorseHashtag, Morse$, MorsePercent, MorseAmp, MorseSglQoute, MorseOParen, MorseCParen, MorseStar, MorsePlus, MorseComma, MorseDash, MorsePeriod, MorseFSlash, Morse0, Morse1,  Morse2, Morse3, Morse4, Morse5, Morse6, Morse7, Morse8, Morse9, MorseColon, MorseSemiColon, MorseLT, MorseEQ, MorseGT, MorseQuestion, MorseAt, MorseA, MorseB, MorseC, MorseD, MorseE, MorseF, MorseG, MorseH, MorseI, MorseJ, MorseK, MorseL, MorseM, MorseN, MorseO, MorseP, MorseQ, MorseR, MorseS, MorseT, MorseU, MorseV, MorseW, MorseX, MorseY, MorseZ 

MorseExclamation: .asciiz "-.-.--"
MorseDblQoute: .asciiz ".-..-."
MorseHashtag: .ascii ""
Morse$: .ascii ""
MorsePercent: .ascii ""
MorseAmp: .ascii ""
MorseSglQoute: .asciiz ".----."
MorseOParen: .asciiz "-.--."
MorseCParen: .asciiz "-.--.-"
MorseStar: .ascii ""
MorsePlus: .ascii ""
MorseComma: .asciiz "--..--"
MorseDash: .asciiz "-....-"
MorsePeriod: .asciiz ".-.-.-"
MorseFSlash: .ascii ""
Morse0: .asciiz "-----"
Morse1: .asciiz ".----"
Morse2: .asciiz "..---"
Morse3: .asciiz "...--"
Morse4: .asciiz "....-"
Morse5: .asciiz "....."
Morse6: .asciiz "-...."
Morse7: .asciiz "--..."
Morse8: .asciiz "---.."
Morse9: .asciiz "----."
MorseColon: .asciiz "---..."
MorseSemiColon: .asciiz "-.-.-."
MorseLT: .ascii ""
MorseEQ: .asciiz "-...-"
MorseGT: .ascii ""
MorseQuestion: .asciiz "..--.."
MorseAt: .asciiz ".--.-."
MorseA: .asciiz ".-"
MorseB:	.asciiz "-..."
MorseC:	.asciiz "-.-."
MorseD:	.asciiz "-.."
MorseE:	.asciiz "."
MorseF:	.asciiz "..-."
MorseG:	.asciiz "--."
MorseH:	.asciiz "...."
MorseI:	.asciiz ".."
MorseJ:	.asciiz ".---"
MorseK:	.asciiz "-.-"
MorseL:	.asciiz ".-.."
MorseM:	.asciiz "--"
MorseN: .asciiz "-."
MorseO: .asciiz "---"
MorseP: .asciiz ".--."
MorseQ: .asciiz "--.-"
MorseR: .asciiz ".-."
MorseS: .asciiz "..."
MorseT: .asciiz "-"
MorseU: .asciiz "..-"
MorseV: .asciiz "...-"
MorseW: .asciiz ".--"
MorseX: .asciiz "-..-"
MorseY: .asciiz "-.--"
MorseZ: .asciiz "--.."


FMorseCipherArray: .asciiz ".....-..x.-..--.-x.x..x-.xx-..-.--.x--.-----x-x.-x--xxx..x.-x.xx-.x--x-xxx.xx-"

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
	# t0 = byte counter
	# t1 = char value
	# t2 = offset
	# v0 = return value
	
	li $t0, 0							# intialize byte counter to zero
	
	loopToUpper:
		add $t2, $a0, $t0				# add base address to counter creating offset address
		lb $t1, 0($t2)					# load byte to be manipulated
		beq $t1, '\0' doneToUpper		# if a null bit, we are at the end of the string
		blt $t1, 'a', endofloopToUpper	# if char is less than 97 skip it
		bgt $t1, 'z', endofloopToUpper	# or if char is greater than 122 skip it
		and $t1, $t1, '_'				# clear 5th bit
		sb $t1, 0($t2)					# store manipulated byte
		endofloopToUpper:				#
		addi $t0, $t0, 1				# increment counter
		b loopToUpper					#
	doneToUpper:						#
	move $v0, $a0						# move final value to return value
	jr $ra								# return to main

length2Char:
	# v0 = counter/ strlength
	# a0 = address of string
	# a1 = address of specified terminator
	# t1 = string address
	# t2 = terminator char
	li $v0, 0
	beqz $a1, a1null
	lb $t2, 0($a1)
	loopLength2Char:					#
		lb $t0, 0($a0)					# load char
		beq $t0, $t2, doneLength2Char	# if char = terminator
		addi $v0, $v0, 1				# increase counter
		addi $a0, $a0, 1				# go to next byte
		b loopLength2Char				#
	doneLength2Char:					#
	jr $ra								#
	a1null:
		li $t2, '\0'
		b loopLength2Char

strcmp:
	# s0 = str1
	# s1 = str2
	# s2 = length
	# s3 = str1byte
	# s4 = str2byte
	# a2 = length
	# t0 = offset of str1
	# t1 = offset of str2
	# t2 = length of str1
	# t3 = length of str2
	# t4 = counter
	# v0 = if strings matched, 1, otherwise 0
	# t7 = return address
	# s7 = preserve length of str1 during jump

	#Save registers
	move $t7, $ra
	
	move $s0, $a0						# save str1 to s0
	move $s1, $a1						# save str2 to s1
	move $s2, $a2						# save length to s2
	
	li $a1, 0							# set null terminator for length2char
	
	move $a0, $s0
	jal length2Char						# call length2char for str2
	move $s7, $v0						# move return value to t2
	
	move $a0, $s1						# move str2 to argument
	jal length2Char						# call length2char for str2
	move $t3, $v0						# move return value to t3
	move $t2, $s7
	bltz $s2, error						# if length is less than zero, return 0,0
	bgt $s2, $t2, error					# if length is greater than length of string1, return 0,0
	bgt $s2, $t3, error					# if length is greater than length of string2, return 0,0
	
	# initialize the things
	li $t0, 0
	li $t1, 0
	li $t4, 0
	li $v0, 1
	li $v1, 0

	beqz $a2, a2isZero					# if a2 is zero, find out if strings are equal, if not, find the difference and add that to v1, and set v0 to 0
	
	strCmpLoop:
		beq $t4, $s2, done				# it is done once we get to the end of the strings
		add $t0, $s0, $t4				# address + offset for byte to be used from source1
		add $t1, $s1, $t4				# address + offset for byte to be used from source2
		lb $s3, 0($t0)
		lb $s4, 0($t1)
		bne $s3, $s4, different
		add $v1, $v1, 1
		returntoLoop:
		add $t4, $t4, 1
		b strCmpLoop
		
		
	# if one string is larger than the other, add the difference to the amount of different chars and set v0 to 0
	a2isZero:
		bne $t2, $t3, strDiffSize
		move $s2, $t2
		b strCmpLoop
	
	
	strDiffSize:
		li $v0, 0
		blt $t2, $t3, t2Lt3
		move $s2, $t3
		b strCmpLoop
	
	t2Lt3:
		move $s2, $t2
		b strCmpLoop
	
	
	error:
		li $v0, 0
		li $v1, 0
		b done
		
	different:
		li $v0, 0
		b returntoLoop
		
	done:
		move $ra, $t7
		jr $ra

##############################
# PART 2 FUNCTIONS
##############################

toMorse:

	# a0, s0 = address of source string
	# a1, s1 = address of destination string
	# a2, s2 = total numbner of bytes allocated including the null byte. if < 1, return 0,0
	# s3 = byte to be converted from source string
	# s4 = s3 value - 33 which will give index of character in morse array
	
	# v0 = return length of morse code, including '\0'
	# v1 = returns 1 if string was completely and correctly encoded, otherwise 0
	
	# t0 = offset + base address of source string
	# t1 = index counter for source string
	
	# t3 = offset + base address of destination string
	# t4 = index counter for destination string
	# t5 = morse index
	# t6 = address
	# t7 = byte in morse array
	# s5 = address of MorseCode array
	# s6 = return address
	# s7 = uppercased source string
	
	# Morse Code Array 0->57 = ASCII 33->90
	move $s6, $ra						# save return address
	
	blt $a2, 1, error					# if a2 < 1, invalid, return 0,0
	
	# Save arguments
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	# need to convert message to uppercase
	# a0 is still the source string so we can just call toUpper
	jal toUpper							# v0 now holds the formatted string
	move $s7, $v0						# s7 is now the uppercased string
	la $s0, ($s7)						# address of uppercased string
	la $s5, MorseCode
	li $v1, 1							# defaults to complete and correct encoding
	
	toMorseLoop:
		beq $t4, $s2, outOfSpace		# actually needs to check index counter for destination string
		add $t0, $s0, $t1				# create offset + base address for char in source string
		lb $s3, 0($t0)					# Loads byte from source string
		beq $s3, '\0', addNull
		beq $s3, ' ', byteisSpace
		#needs to be between 33->90 in ascii table
		blt $s0, 33, outOfRange
		bgt $s0, 90, outOfRange
		b inRange
		
		returnToMorseLoop:
		addi $t1, $t1, 1				# increments offset
		b toMorseLoop
		
	inRange:
		li $t5, 0
		sub $s4, $s3, 33			# gives index of string in morse array
		mult $s4, 4					# since words are 4 bytes each
		add $s4, $s4, $s5			# now we have address of string in array
		la $t6, 0($s4)				# load the address of the string
		combine:
			lb $t7, 0($t6)			# load byte from morsearray
			beq $t7, '\0', returnToMorseLoop
			sb $t7, 0($t3)			# store byte to destination string
			addi $t4, $t4, 1		# increment destination string index
			add $t3, $s1, $t4		# increment destination string address
			addi $s5, $s5, 1 		# increment morse address by 1
			b combine
		# add the characters of the morse loop in to the destination string
		b returnToMorseLoop
	
	outOfRange:						# skip over if character does not have a morse code pattern
		li $v1, 0
		addi $t1, $t1, 1				# increments offset
		b returnToMorseLoop
		
	outOfSpace:
		li $v0, 0
		b addNull
		
	byteisSpace:
		returnToMorseLoop
		
	error:
		li $v0, 0
		li $v1, 0
		b done
	
	addNull:
		# add null character to end of destination string
		move $a0, $s1
		length2char
		b done
		
	done:
	move $ra, $s6
	jr $ra

createKey:
	#Define your code here
	# a0 = Starting address of phrase
	# a1 = starting address of 26 bytes of memory for output phrase
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
#word aligned array consisting of addresses
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

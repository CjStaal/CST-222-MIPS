##############################################################
# Homework #2
# name: Charles Staal
# scccid: 01040168
##############################################################

.text

##############################
# PART 1 FUNCTIONS 
##############################
# pack it, stuff stack with jump and $s register data
.macro pack_stack()
	subi $sp, $sp, 36 # 9 (items) * 4 (width)
	sw $ra, 0($sp) # 0 ->
	sw $s7, 4($sp)
	sw $s6, 8($sp)
	sw $s5, 12($sp)
	sw $s4, 16($sp)
	sw $s3, 20($sp)
	sw $s2, 24($sp)
	sw $s1, 28($sp)
	sw $s0, 32($sp) # -> 36
.end_macro

# unpack the stack, roll it back to original content
.macro unpack_stack()
	lw $ra, 0($sp) # 0 ->
	lw $s7, 4($sp)
	lw $s6, 8($sp)
	lw $s5, 12($sp)
	lw $s4, 16($sp)
	lw $s3, 20($sp)
	lw $s2, 24($sp)
	lw $s1, 28($sp)
	lw $s0, 32($sp) # -> 36
	addi $sp, $sp, 36 # 9 (items) * 4 (width)
.end_macro
toUpper:
	# t0 = byte counter
	# t1 = char value
	# t2 = offset
	# v0 = return value
	
	li $t0, 0							# intialize byte counter to zero
	
	loopToUpper:						#
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
	li $v0, 0							#
	beqz $a1, a1null					#
	lb $t2, 0($a1)						#
	
	loopLength2Char:					#
		lb $t0, 0($a0)					# load char
		beq $t0, $t2, doneLength2Char	# if char = terminator
		beq $t0, $0, doneLength2Char	# or if we reach the EOS
		addi $v0, $v0, 1				# increase counter
		addi $a0, $a0, 1				# go to next byte
		b loopLength2Char				#
	doneLength2Char:					#
	jr $ra								#
	a1null:								#
		li $t2, '\0'					#
		b loopLength2Char				#

strcmp:
	# s0 = str1
	# s1 = str2
	# s2 = length
	# a2 = length
	# t0 = offset of str1
	# t1 = offset of str2
	# t2 = length of str1
	# t3 = length of str2
	# t4 = counter
	# t5 = str1byte
	# t6 = str2byte
	# t7 = length
	# v0 = number of matching characters
	# v1 = if strings matched, 1, otherwise 0
	# s6 = return address
	# s7 = preserve length of str1 during jump

	#Save registers
	move $s6, $ra						#
	
	move $s0, $a0						# save str1 to s0
	move $s1, $a1						# save str2 to s1
	move $s2, $a2						# save length to s2
	
	li $a1, 0							# set null terminator for length2char
	
	move $a0, $s0						#
	move $a1, $0
	pack_stack()
	jal length2Char						# call length2char for str2
	unpack_stack()
	move $s7, $v0						# move return value to t2
	
	move $a0, $s1						# move str2 to argument
	move $a1, $0
	pack_stack()
	jal length2Char						# call length2char for str2
	unpack_stack()
	move $t3, $v0						# move return value to t3
	move $t2, $s7
	move $t7, $s2
	bltz $t7, error						# if length is less than zero, return 0,0
	bgt $t7, $t2, error					# if length is greater than length of string1, return 0,0
	bgt $t7, $t3, error					# if length is greater than length of string2, return 0,0
	
	# initialize the things
	li $t0, 0							#
	li $t1, 0							#
	li $t4, 0							#
	li $v0, 0							#
	li $v1, 1							#

	beqz $a2, a2isZero					# if a2 is zero, find out if strings are equal, if not, find the difference and add that to v1, and set v0 to 0
	
	strCmpLoop:							#
		beq $t4, $t7, done				# it is done once we get to the end of the strings
		add $t0, $s0, $t4				# address + offset for byte to be used from source1
		add $t1, $s1, $t4				# address + offset for byte to be used from source2
		lb $t5, 0($t0)					# load up that there byte from string 1
		lb $t6, 0($t1)					# load up that there byte from string 2
		bne $t5, $t6, different			# Are they equal? If not lets go down to label different
		add $v0, $v0, 1					# Seems like they're equal. Lets increment 'same' counter
		returntoLoop:					#
		add $t4, $t4, 1					# Lets increment our index
		b strCmpLoop					#
		
		
	# if one string is larger than the other, add the difference to the amount of different chars and set v0 to 0
	a2isZero:							#
		bne $t2, $t3, strDiffSize		# if the strings are a different size, branch
		move $t7, $t2					# else it's the same size, so lets just make the length one of the lengths of the two strings
		b strCmpLoop					# hop on back now ya'll
	
	
	strDiffSize:						#
		li $v1, 0						# Well we know they don't match already there partna'
		blt $t2, $t3, t2Lt3				# Lets save whichever one is lower in to s2
		move $t7, $t3					# right now I guess t3 is lower
		b strCmpLoop					#
	
	t2Lt3:								#
		move $t7, $t2					# right now t2 is lower 
		b strCmpLoop					#
	
	
	error:								#
		li $v0, 0						#
		li $v1, 0						#
		b done							#
		
	different:							#
		li $v1, 0						# They're different. Sound the alarm in v1
		b returntoLoop					#
		
	done:								#
		move $ra, $s6					# lets move the address back in to ra
		jr $ra							# hop on back

##############################
# PART 2 FUNCTIONS
##############################
	
ammendString:
	# a0 = address of string to be ammended
	# a1 = offset address of string to be added
	# a2 = index of a1 placement in to a0
	# a3 = size of a0
	
	# t0 = address + offset of a0
	# t1 = address + offset of a1
	# t2 = offset of a0
	# t3 = offset of a1
	# t4 = byte to be added to a0
	# t5 = a3 - 1. for a0 index 
	# v0 = address of a0
	# v1 = new a3, or -1 if filled and wasn't able to finish 
	move $t2, $a2						#
	li $t3, 0							# gotta zero it out so I'm not a dumbass
	
	ammendLoop:
		add $t0, $a0, $t2				# address + offset for a0, destination string
		add $t1, $a1, $t3				# address + offset for a1, source string
		lb $t4, 0($t1)					# load the byte from the source string 
		beq $t2, $a3, stringFull		# if the index of the destination string is the size of the destination string, we are full (since we are really above the index by 1)
		beq $t4, '\0', finishedAmmend	# if the character we just grabbed from the source string is null, we are done
		sb $t4, 0($t0)					# store the character from the source string to the destination string
		addi $t2, $t2, 1				# increment index for destination string
		addi $t3, $t3, 1				# increment index for source string
		b ammendLoop					# lets keep it movin'
	
	stringFull:
		move $v0, $a0					# move the address of the destination string to v0
		li $v1, -1						# Lets let them know where we are full on the destination string via v1
		jr $ra							# jump wit it
	
	finishedAmmend:
		move $v0, $a0					# again lets move the address of the destination string to v0
		move $v1, $t2					# let them know this is where we are on the destination string
		jr $ra							# jump wit it
		
morseLookup:
	# a0 = character to be looked up
	# v0 = address of morse string
	# v1 = 1 if found, otherwise 0
	# t0 = address of base array
	la $t2, MorseCode					#
	beq $a0, 32, isaspace
	blt $a0, 33, notfound				# Make sure the char is in range
	bgt $a0, 90, notfound				#
	sub $a0, $a0, 33					# subtract 33 so now we are indexed in to the MorseCode array
	sll $a0, $a0, 2						#
	lw $v0, MorseCode($a0)				#
	li $v1, 1							# toggle showing that we have it
	jr $ra								#
	
	isaspace:
		la $v0, Space
		li $v1, 1
		jr $ra
		
	notfound:							#
		li $v0, 0						#
		li $v1, 0						#
		jr $ra							#

zeroCheckArray:
	la $t0, CheckArray
	li $t1, 0
	li $t2, 0
	zeroLoop:
		beq $t1, 26, zeroed
		add $t3, $t0, $t1
		sb $t2, 0($t3)
		addi $t1, $t1, 1
		b zeroLoop
		
	zeroed:
	jr $ra

toMorse:
	# a0 = address of source string
	# a1 = address of destination string
	# a2 = destination string size
	
	# s0 = a0/ source string
	# s1 = a1/ destination string
	# s2 = a2/ destination string size
	# s3 = offset of s0
	# s4 = offset of s1
	# s5 = character to be encoded
	# s6 = flag if any type of error
	
	# t0 = offset + base address of a0
	# t1 = offset + base address of a1
	# t2 = address of morse string
	# t4 = character to be encoded
	
	# v0 = return length of morse code, including '\0'
	# v1 = returns 1 if string was completely and correctly encoded, otherwise 0
	
	# save registers
	move $s0, $a0
	move $s1, $a1						#
	move $s2, $a2						#

	
	blt $a2, 1, invalidEntry			#
	lb $t4, 0($s0)
	beq $t4 '\0', endToMorse
	
	li $s6, 1							#
	li $s3, 0							#
	li $s4, 0							#
	
	toMorseLoop:						#
		beq $s4, $s2, filled			#
		add $t0, $s0, $s3				#
		lb $s5, 0($t0)					# character from source string to be encoded
		beq $s5, '\0', finishedCorrectly#
		move $a0, $s5					# move that character in to argument 0
		pack_stack()
		jal morseLookup
		unpack_stack()
		beq $v1, 0, skip				# if it returned 0 in v1, that means there is no morse for that character, so skip it
		move $a1, $v0					# address of morse string
		move $a0, $s1					# address of destination string
		move $a2, $s4					# index of s1 (where to start ammending)
		move $a3, $s2					# destination string size
		pack_stack()
		jal ammendString
		unpack_stack()
		move $s1, $v0					# move return address in to s1
		move $s4, $v1					# move new s1 offset back in
		beq $s4, -1, unfinished
		bne $s5, ' ', addX
		returnFromAddX:
		beq $s2, $s4, filled
		skip:							#
		addi $s3, $s3, 1				# increment the offset/index for the source string
		b toMorseLoop					#

	addX:
		la $a1, EndChar
		add $t0, $s0, $s3
		addi $t0, $t0, 1
		lb $t5, 0($t0)
		beq $t5, ' ', returnFromAddX
		beq $t5, '\0', finishedCorrectly
		move $a0, $s1
		move $a2, $s4
		move $a3, $s2
		pack_stack()
		jal ammendString
		unpack_stack()
		move $s1, $v0					# move return address in to s1
		move $s4, $v1					# move new s1 offset back in
		beq $s4, -1, unfinished
		b returnFromAddX
		
		
	invalidEntry:						#
		li $v0, 0						#
		li $v1, 0						#
		jr $ra							#
		
	unfinished:							#
		li $s6, 0
		sub $s2, $s2, 1
		add $t1, $s1, $s2
		sb $0, 0($t1)
		b endToMorse		

	finishedCorrectly:
		add $t0, $s0, $s3
		subi $t0, $t0, 1
		lb $t5, 0($t0)
		beq $t5, ' ', dontAddSpaceAtEnd
		la $a1, Space
		move $a0, $s1					# address of destination string
		move $a2, $s4					# index of s1 (where to start ammending)
		move $a3, $s2					# destination string size
		pack_stack()
		jal ammendString
		unpack_stack()
		move $s1, $v0					# move return address in to s1
		move $s4, $v1					# move new s1 offset back in
		beq $s4, -1, unfinished
		dontAddSpaceAtEnd:
		add $t1, $a1, $s4
		sb $0, 0($t1)
		b endToMorse
		
	filled:								#
		add $t0, $s0, $s3				#
		lb $t4, 0($t0)					#
		beq $t4, '\0', finishedCorrectly#
		b endToMorse					#
		
	endToMorse:							#
		move $a0, $s1
		move $a1, $0
		pack_stack()
		jal length2Char
		unpack_stack()
		add $v0, $v0, 1					# because he wants the length INCLUDING the null? wtf?
		move $v1, $s6
		jr $ra							#

	
createKey:
	#Define your code here
	# a0 = Starting address of phrase
	# a1 = starting address of 26 bytes of memory for output phrase
	
	# s0 = address of phrase
	# s1 = address of output
	# s2 = size of phrase
	# s3 = address + index for phrase
	# t0 = index for phrase
	# t1 = character from phrase
	# t2 = character - 41
	# t3 = CheckArray Address
	# t4 = char from CheckArray
	# t5 = address + offset/index output phrase
	# t6 = address + offset ( t2) checkArray
	# t7 = index for output
	# v0 = address of CheckArray
	# v1 = char from CheckArray
	move $s0, $a0
	move $s1, $a1
	pack_stack()
	jal zeroCheckArray	# call length2char for str2
	unpack_stack()
	pack_stack()
	jal length2Char	# call length2char for str2
	unpack_stack()
	move $s2, $v0
	move $a0, $s0
	pack_stack()
	jal toUpper
	unpack_stack()
	move $s0, $v0
	li $t0, 0
	
	la $t3, CheckArray
	li $t5, 0
	li $t6, 0
	li $t7, 0
	createKeyLoop:
		add $s3, $s0, $t0				# base address + offset/index for phrase
		add $t5, $s1, $t7				# base address + offset/index for output
		beq $t0, $s2, fillit			# if the index is larger or equal to the size of the phrase, go back and fill the rest of the letters in
		lb $t1, 0($s3)					# obtain the character from the phrase
		blt $t1, 41, returnToKeyLoop
		bgt $t1, 90, returnToKeyLoop
		subi $t2, $t1, 65				# minus 65 from character to get index of the character in CheckArray
		add $t6, $t3, $t2				# Index for char in CheckArray
		lb $t4, 0($t6)					# Load the characters boolean byte from CheckArray
		beqz $t4, addToOutput			# if the characters boolean is 0, add it to output
		returnToKeyLoop:
		addi $t0, $t0, 1				# else increment the index/counter
		b createKeyLoop
		
	addToOutput:
		sb $t1, 0($t5)					# Add char from phrase to the output phrase
		li $t4, 1						# load 1 to char from check array
		sb $t4, 0($t6)					# add 1 to check array
		addi $t7, $t7, 1 				# increment the output index
		b returnToKeyLoop
		
	addToOutput2:
		sb $t1, 0($t5)					# Add char to the output phrase
		li $t4, 1						# load 1 to char from check array
		sb $t4, 0($t6)					# add 1 to check array
		addi $t7, $t7, 1 				# increment the output 
		b fillitLoop
		
	fillit:
		li $t1, 41						# Load A in to character register
		fillitLoop:
		add $t5, $s1, $t7				# base address + offset/index for output
		beq $t1, 91, createKeyDone		# If we are passed Z, we are done
		subi $t2, $t1, 65				# minus 65 from character to get index of the character in CheckArray
		add $t6, $t3, $t2				# Index for char in CheckArray
		lb $t4, 0($t6)					# Load the characters boolean byte from CheckArray
		beqz $t4, addToOutput2			# if the characters boolean is 0, add it to output
		addi $t1, $t1, 1
		b fillitLoop
			
	createKeyDone:
		li $t1, '\0'
		sb $t1, 0($t5)
		jr $ra

keyIndex:
	# a0/s0 = address of phrase
	# v0 = key index
	
	# s0 = address of phrase
	# s1 = address of FMorseCipherArray
	# s2 = offset of FMorseCipherArray
	# s3 = add + off MCA
	# s5 = loop counter / key index, -1 if not found
	# s7 = return address
	move $s0, $a0
	la $s1, FMorseCipherArray
	li $s2, 0
	li $s5, 0
	keyIndexLoop:
		beq $s5, 26, notfound
		add $s3, $s1, $s2
		move $a0, $s0
		move $a1, $0
		pack_stack()
		jal length2Char
		unpack_stack()
		blt $v0, 3, notFound
		move $a0, $s0
		move $a1, $s3
		li $a2, 3
		pack_stack()
		jal strcmp
		unpack_stack()
		beq $v1, 1, doneKeyIndex
		add $s5, $s5, 1
		add $s2, $s2, 3
		b keyIndexLoop
	
	notFound:
		li $v0, -1
		b keyIndexReturn
	doneKeyIndex:
		move $v0, $s5
		b keyIndexReturn
	
	keyIndexReturn:
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
CheckArray: .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Space: .asciiz "XX"
EndChar: .asciiz "X"
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

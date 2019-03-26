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
	move $t7, $ra						#
	
	move $s0, $a0						# save str1 to s0
	move $s1, $a1						# save str2 to s1
	move $s2, $a2						# save length to s2
	
	li $a1, 0							# set null terminator for length2char
	
	move $a0, $s0						#
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
	li $t0, 0							#
	li $t1, 0							#
	li $t4, 0							#
	li $v0, 1							#
	li $v1, 0							#

	beqz $a2, a2isZero					# if a2 is zero, find out if strings are equal, if not, find the difference and add that to v1, and set v0 to 0
	
	strCmpLoop:							#
		beq $t4, $s2, done				# it is done once we get to the end of the strings
		add $t0, $s0, $t4				# address + offset for byte to be used from source1
		add $t1, $s1, $t4				# address + offset for byte to be used from source2
		lb $s3, 0($t0)					# load up that there byte from string 1
		lb $s4, 0($t1)					# load up that there byte from string 2
		bne $s3, $s4, different			# Are they equal? If not lets go down to label different
		add $v1, $v1, 1					# Seems like they're equal. Lets increment 'same' counter
		returntoLoop:					#
		add $t4, $t4, 1					# Lets increment our index
		b strCmpLoop					#
		
		
	# if one string is larger than the other, add the difference to the amount of different chars and set v0 to 0
	a2isZero:							#
		bne $t2, $t3, strDiffSize		# if the strings are a different size, branch
		move $s2, $t2					# else it's the same size, so lets just make the length one of the lengths of the two strings
		b strCmpLoop					# hop on back now ya'll
	
	
	strDiffSize:						#
		li $v0, 0						# Well we know they don't match already there partna'
		blt $t2, $t3, t2Lt3				# Lets save whichever one is lower in to s2
		move $s2, $t3					# right now I guess t3 is lower
		b strCmpLoop					#
	
	t2Lt3:								#
		move $s2, $t2					# right now t2 is lower 
		b strCmpLoop					#
	
	
	error:								#
		li $v0, 0						#
		li $v1, 0						#
		b done							#
		
	different:							#
		li $v0, 0						# They're different. Sound the alarm in v0
		b returntoLoop					#
		
	done:								#
		move $ra, $t7					# lets move the address back in to ra
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
	# v0 = address of a0
	# v1 = new a3
	
	ammendLoop:
		add $t0, $a0, $t2				# address + offset for a0, destination string
		add $t1, $a1, $t3				# address + offset for a1, source string
		lb $t4, 0($t1)					# load the byte from the source string 
		beq $a2, $a3, stringFull		# if the index of the destination string is the size of the destination string, we are full
		beq $t4, '\0', finishedAmmend	# if the character we just grabbed from the source string is null, we are done
		sb $t4, 0($t0)					# store the character from the source string to the destination string
		addi $t2, $t2, 1				# increment index for destination string
		addi $t3, $t3, 1				# increment index for source string
		b ammendLoop					# lets keep it movin'
	
	stringFull:
		move $v0, $a0					# move the address of the destination string to v0
		move $v1, $a3					# Lets let them know where we are full on the destination string via v1
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
	blt $a0, 33, notfound				# Make sure the char is in range
	bgt $a0, 90, notfound				#
	sub $a0, $a0, 33					# subtract 33 so now we are indexed in to the MorseCode array
	sll $a0, $a0, 2						#
	lw $v0, MorseCode($a0)				#
	li $v1, 1							# toggle showing that we have it
	jr $ra								#
	
	notfound:							#
		li $v0, 0						#
		li $v0, 0						#
		jr $ra							#

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
	# s7 = return address
	
	# t0 = offset + base address of a0
	# t1 = offset + base address of a1
	# t2 = address of morse string
	# t4 = character to be encoded
	
	# v0 = return length of morse code, including '\0'
	# v1 = returns 1 if string was completely and correctly encoded, otherwise 0
	
	# save registers
	move $s1, $a1						#
	move $s2, $a2						#
	move $s7, $ra						#

	jal toUpper							#
	move $s0, $v0						# save the uppercased string address
	
	blt $a2, 1, invalidEntry			#
	
	li $v1, 1							#
	li $s3, 0							#
	li $s4, 0							#
	toMorseLoop:						#
		beq $s4, $s2, filled			#
		add $t0, $a0, $s3				#
		lb $s5, 0($t0)					# character from source string to be encoded
		beq $s5, '\0', filled			#
		move $a0, $s5					# move that character in to argument 0
		jal morseLookup					# returns address of the morse string in to v0 for character in s0
		beq $v1, 0, skip				# if it returned 0 in v1, that means there is no morse for that character, so skip it
		move $a0, $s1					# address of destination string
		move $a1, $v0					# address of morse string
		move $a2, $s4					# index of s1 (where to start ammending)
		move $a3, $s2					# destination string size
		jal ammendString				# v0 = address of ammended string, v1 = new s4
		move $s1, $v0					# move return address in to s1
		move $s4, $v1					# move new s1 index back in
		beq $s2, $s4, filled			# make sure we are not filled
		addi $s4, $s4, 1				# increment the offset/index for the destination string
		skip:							#
		addi $s3, $s3, 1				# increment the offset/index for the source string
		b toMorseLoop					#
		
	filled:								#
		add $t0, $a0, $s3				#
		add $t1, $a1, $s4				#
		lb $t4, 0($t0)					#
		beq $t4, '\0', finishedCorrectly#
		li $v1, 0						#
		finishedCorrectly:				#
		sb $0, 0($t1)					#

		move $a0, $s1					#
		move $a1, $t5					#
		jal length2Char					#

		b endToMorse					#
	
	invalidEntry:						#
		li $v0, 0						#
		li $v0, 0						#
		b endToMorse					#
		
	unfinished:							#
		li $v1, 0						#

	endToMorse:							#
		move $ra, $s7					#
		jr $ra							#

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
.
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

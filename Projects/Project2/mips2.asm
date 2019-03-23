	############################################
	# TEST CASE for toUpper	
	############################################
	print_string(toUpper_header)
	print_string(str_input)
	print_string(toUpper_CSisFun) 
	print_newline

	la $a0, toUpper_CSisFun
	jal toUpper

	move $t0, $v0
	print_string(str_result)	
	print_string_reg($t0) 
	print_newline

	############################################
	# TEST CASE for strcmp
	############################################
	print_string(strcmp_header)
	print_string(str_input)
	print_string(strcmp_str1)
	print_newline
	print_string(str_input)
	print_string(strcmp_str2)
	print_newline
	print_string(str_input)
	li $t1, 4
	print_int($t1)
	print_newline

	la $a0, strcmp_str1
	la $a1, strcmp_str2
	li $a2, 4
	jal strcmp

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_int($t0)
	print_newline

	print_string(str_return)
	print_int($t1)
	print_newline


	############################################
	# TEST CASE for toMorse
	############################################
	print_string(toMorse_header)
	print_string(str_input)
	print_string(toMorse_plaintext)
	print_newline
	print_string(str_input)
	print_string(toMorse_mcmsg)
	print_newline
	print_string(str_input)
	lw $t9, toMorse_size
	print_int($t9)
	print_newline

	la $a0, toMorse_plaintext
	la $a1, toMorse_mcmsg
	lw $a2, toMorse_size
	jal toMorse

	move $t0, $v0
	move $t1, $v1

	print_string(str_result)
	print_string(toMorse_mcmsg)
	print_newline

	print_string(str_return)
	print_int($t0)
	print_newline

	print_string(str_return)
	print_int($t1)
	print_newline

	############################################
	# TEST CASE for createKey
	############################################
	print_string(createKey_header) 
	print_string(str_input)
	print_string(createKey_phrase)
	print_newline
	print_string(str_input)
	print_string(createKey_key)
	print_newline

	la $a0, createKey_phrase
	la $a1, createKey_key
	jal createKey

	print_string(str_result)
	print_string(createKey_key)
	print_newline

	############################################
	# TEST CASE for keyIndex
	############################################
	print_string(keyIndex_header) 
	print_string(str_input)
	print_string(keyIndex_mcmsg)
	print_newline

	la $a0, keyIndex_mcmsg
	jal keyIndex

	move $t0, $v0
	print_string(str_return)
	print_int($t0)
	print_newline

	############################################
	# TEST CASE for FMCEncrypt
	############################################
	print_string(FMCEncrypt_header)
	print_string(str_input)
	print_string(FMCEncrypt_plaintext)
	print_newline
	print_string(str_input)
	print_string(FMCEncrypt_phrase)
	print_newline
	print_string(str_input)
	print_string(FMCEncrypt_encryptBuffer)
	print_newline
	print_string(str_input)
	lw $t9, FMCEncrypt_size
	print_int($t9)
	print_newline

	la $a0, FMCEncrypt_plaintext
	la $a1, FMCEncrypt_phrase
	la $a2, FMCEncrypt_encryptBuffer
	lw $a3, FMCEncrypt_size
	jal FMCEncrypt

	move $t0, $v0
	move $t1, $v1

	print_string(str_return)
	print_string_reg($t0)
	print_newline

	print_string(str_return)
	print_int($t1)
	print_newline

	############################################
	# TEST CASE for FMCDecrypt
	############################################
	print_string(FMCDecrypt_header)
	print_string(str_input)
	print_string(FMCDecrypt_ciphertext)
	print_newline
	print_string(str_input)
	print_string(FMCDecrypt_phrase)
	print_newline
	print_string(str_input)
	print_string(FMCDecrypt_decryptBuffer)
	print_newline
	print_string(str_input)
	lw $t9, FMCDecrypt_size
	print_int($t9)
	print_newline

	la $a0, FMCDecrypt_ciphertext
	la $a1, FMCDecrypt_phrase
	la $a2, FMCDecrypt_decryptBuffer
	lw $a3, FMCDecrypt_size
	jal FMCDecrypt

	move $t0, $v0
	move $t1, $v1
	print_string(str_return)
	print_string_reg($t0)
	print_newline

	print_string(str_return)
	print_int($t1)
	print_newline


	############################################
	# TEST CASE for fromMorse
	############################################
	print_string(fromMorse_header)
	print_string(str_input)
	print_string(fromMorse_morsecode)
	print_newline
	print_string(str_input)
	print_string(fromMorse_plaintextBuffer)
	print_newline
	print_string(str_input)
	lw $t9, fromMorse_size
	print_int($t9)
	print_newline

	la $a0, fromMorse_morsecode
	la $a1, fromMorse_plaintextBuffer
	lw $a2, fromMorse_size
	jal fromMorse

	move $t0, $v0
	move $t1, $v1

	print_string(str_result)
	print_string(fromMorse_plaintextBuffer)
	print_newline

	print_string(str_return)
	print_int($t0)
	print_newline

	print_string(str_return)
	print_int($t1)
	print_newline


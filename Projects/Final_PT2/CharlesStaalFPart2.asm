.data
bitString: .space 128
strippedString: .space 128
bitAdd5: .space 128
displayAdd5: .space 128

.macro get_string(%str)
	la $a0, %str
	li, $a1, 128
	li $v0, 8
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

.macro print_string(%str)
	.text
		li $v0, 4
		la $a0, %str
		syscall
.end_macro

.macro print_int(%int)
	li $v0, 1
	move $a0, %int
	syscall
.end_macro

.macro exit()
	li $v0, 10
	syscall
.end_macro
.text

main:
	print_ready_string("Name: Charles Staal\n")
	main_loop:
	print_ready_string("Enter binary string: ")
	get_string(bitString)

	la $a0, bitString
	jal checkInput
	move $t0, $v0
	beq $t0, 2, exit_main
	print_ready_string("\tVerify\t   : ")
	print_string(bitString)
	beq $t0, 0, input_error_main
	la $a0, bitString
	la $a1, strippedString
	jal stripInput
	la $a0, strippedString
	jal get_length
	move $t0, $v0
	la $a0, strippedString
	move $a1, $t0
	jal convertBinary
	move $s0, $v0
	print_ready_string("Convert to int: ")
	print_int($s0)
	print_ready_string("\n Add 5: ")
	addi $t0, $s0, 5
	print_int($t0)
	print_ready_string("\n Convert to bit string: ")
	move $a0, $t0
	jal convertDecimal
	la $a0, bitAdd5
	jal get_length
	move $t0, $v0
	la $a0, bitAdd5
	jal formatBin
	print_ready_string("'")
	print_string(displayAdd5)
	print_ready_string("'B\n\n")
	j main_loop
	exit_main:
	print_ready_string("\tVerify\t   : ")
	print_string(bitString)
	print_ready_string("Goodbye\n")
	exit()
	input_error_main:
		print_ready_string("\t\t\t\tInput is invalid\n")
		b main_loop

formatBin:
	move $t0, $a0
	ignore_zero_loop:
		lb $t1, 0($t0)
		beq $t1, '1', ignore_zero_loop_done
		addi $t0, $t0, 1
		b ignore_zero_loop
	ignore_zero_loop_done:

	la $t2, displayAdd5
	save_to_array:
		lb $t1, 0($t0)
		sb $t1, 0($t2)
		addi $t2, $t2, 1
		addi $t0, $t0, 1
		beqz $t1, save_to_array_done
		b save_to_array
	save_to_array_done:
	sb $0, 0($t2)
	jr $ra

convertDecimal:
	move $t0, $a0
	li $t1, 0
	li $t3, 1
	la $t5, bitAdd5
	sll $t3, $t3, 31
	addi $t4, $zero, 32	
	loop:

		and $t1, $t0, $t3
		beqz $t1, add_zero
		li $t6, '1'
		sb $t6, 0($t5)
		return_to_loop:
		addi $t5, $t5, 1
		srl $t3, $t3, 1
		addi $t4, $t4, -1
		beqz $t4,  loop_done
		b loop
	loop_done:
	b convertDecimal_done
	add_zero:
		li $t6, '0'
		sb $t6, 0($t5)
		b return_to_loop

	convertDecimal_done:
	sb $0, 0($t5)
	jr $ra

convertBinary:
	subi $a1, $a1, 1
	add $t0, $a0, $a1
	li $t1, 0
	li $t2, 1

	bin_loop:
		lb $t3, 0($t0)
		beq $t3, '0', dec_bin_loop
		add $t1, $t1, $t2
		dec_bin_loop:
		beq $t0, $a0, bin_done
		subi $t0, $t0, 1
		sll $t2, $t2, 1
		b bin_loop
	bin_done:
	move $v0, $t1
	jr $ra

get_length:
	move $t0, $a0
	li $t1, 0
	li $t2, 0
	length_loop:
		lb $t1, 0($t0)
		beqz $t1, length_done
		addi $t2, $t2, 1
		addi $t0, $t0, 1
		b length_loop
	length_done:
	move $v0, $t2
	jr $ra

stripInput:
	move $t0, $a0
	move $t1, $a1
	
	strip_loop:
		lb $t2, 0($t0)
		beq $t2, '1', add_string
		beq $t2, '0', add_string
		beqz $t2, add_null
		strip_loop_return:
		addi $t0, $t0, 1
		b strip_loop
	strip_done:

	add_string:
		sb $t2, 0($t1)
		addi $t1, $t1, 1
		b strip_loop_return

	add_null:
		move $t2, $0
		sb $t2, 0($t1)
	jr $ra

checkInput:
	move $t0, $a0
	li $t1, 0
	li $t2, 0

	lb $t1, 0($t0)
	bne $t1, 39, input_error
	addi $t0, $t0, 1

	input_check_loop:
		lb $t1, 0($t0)
		beq $t1, '0', inc_check
		beq $t1, '1', inc_check
		beq $t1, 39, check_end
		b input_error
		inc_check:
		addi $t0, $t0, 1
		b input_check_loop
	check_end:

	addi $t0, $t0, 1
	lb $t1, 0($t0)
	bne $t1, 'B', input_error
	li $v0, 1
	b checkInput_end

	input_error:
	beq $t1, '*', send_exit
	li $v0, 0
	b checkInput_end

	send_exit:
		li $v0, 2

	checkInput_end:
	jr $ra


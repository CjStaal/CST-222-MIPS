#Project One
#name: Charles Staal
#sccid: 01040168

.data
.align 2
arg1:  .word 0
arg2:  .word 0
error: .asciiz "Incorrect argument provided.\n"
sm:    .asciiz "Signed Magnitude: "
one:   .asciiz "One's Complement: "
gray:  .asciiz "Gray Code: "
dbl:   .asciiz "Double Dabble: "
msg1:  .asciiz "You entered "
msg2:  .asciiz " which parsed to "
msg3:  .asciiz "In hex it looks like "
arg1saved: .word 0

# Helper macro for grabbing command line arguments
.macro load_args()
	.text
		lw $t0, 0($a1)
		sw $t0, arg1
		sw $t0, arg1saved
		lw $t0, 4($a1)
		sw $t0, arg2
.end_macro

.macro print_string(%str)
	.text
		li $v0, 4
		la $a0, %str
		syscall
.end_macro

.macro print_array_string(%add)
	.text
		lw $a0, %add
		li $v0, 4
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

.macro print_integer(%int)
	.text
		li $v0, 1
		lw $a0, %int
		syscall
.end_macro

.macro input_string(%str, %len)
	.text
		la $a0, %str
		li $a1, %len
		li $v0, 8
		syscall
.end_macro

.macro input_integer(%int)
	.text
		li $v0, 5
		syscall
		sw $v0, %int
.end_macro

.macro atoi(%str)
	.data
		overflow_msg: .asciiz "Overflow!\n"
	.text
		# $t0 - s
		# $t1 - The char pointed to by s
		# $t2 - the current sum
		# $t3 - The "sign" of the sum
		# $t4 - Holds the constant '10'
		# $t5 - used to test for overflow
		lw $t0, %str
		li $t2, 0

		get_sign:
			li $t3, 1
			lb $t1, ($t0)
			bne $t1, '-', positive
			li $t3, -1
			addu $t0, $t0, 1
		positive:
			li $t4, 10
		sum_loop:
			lb $t1, ($t0)
			addu $t0, $t0, 1

			beq $t1, 10, end_sum_loop
			blt $t1, '0', end_sum_loop
			bgt $t1, '9', end_sum_loop

			mult $t2, $t4
			mfhi $t5
			bnez $t5, overflow
			mflo $t2
			blt $t2, $0, overflow

			sub $t1, $t1, '0'
			add $t2, $t2, $t1
			blt $t2, $0, overflow

			b sum_loop
		end_sum_loop:
		mul $t2, $t2, $t3
		sw $t2, %str
		b exit

		overflow:
			la $a0, overflow_msg
			li $v0, 4
			syscall
			b exit
		exit:
.end_macro

.macro to_hex(%int)
	.text
		print_string(msg3)
		lw $a0, %int
		li $v0, 34
		syscall
.end_macro

.macro to_one_comp(%int)
	.text
		#Ones compliment is just twos complement minus one if negative
		# $t0 - arg1
		print_string(one)
		lw $t0, arg1
		bltz $t0, negative
		move $a0, $t0
		li $v0, 34
		syscall
		b exit
		negative:
			sub $t0, $t0, 1
			move $a0, $t0
			li $v0, 34
			syscall
		exit:
.end_macro

.macro to_signed_mag(%int)
	.text
		#Signed Magnitude is just flipping the last bit if negative
		# $t0 - arg1
		print_string(sm)
		lw $t0, arg1
		bltz $t0, negative
		move $a0, $t0
		li $v0, 34
		syscall
		b exit
		negative:
			lui $t1, 0x1000
			mul $t0, $t0, -1
			xor $t0, $t0, $t1
			move $a0, $t0
			li $v0, 34
			syscall
		exit:
.end_macro

.macro to_gray_code(%int)
	.data

	.text
		#Signed Magnitude is just flipping the last bit if negative
		# $t0 - arg1
		print_string(gray)
		lw $t0, arg1
		lw $t1, arg1
		move $t1, $t0
		srl $t1, $t1, 16
		xor $t1, $t0, $t1
		move $t1, $t0
		srl $t1, $t1, 8
		xor $t1, $t0, $t1
		move $t1, $t0
		srl $t1, $t1, 4
		xor $t1, $t0, $t1
		move $t1, $t0
		srl $t1, $t1, 2
		xor $t1, $t0, $t1
		move $t1, $t0
		srl $t1, $t1, 1
		xor $t0, $t0, $t1
		move $a0, $t0
		li $v0, 34
		syscall
.end_macro

.macro run_arg(%int, %str)
	.text
		#t0  - int
		#t1 - s
		#t2 - byte of s for comparison
		lw $t0, %int
		lw $t1, %str
		lb $t2, ($t1)
		beq $t2, '1', ones_complement
		beq $t2, 's', signed_magnitude
		beq $t2, 'g', gray_code #Binary coded decimal
		beq $t2, 'd', double_dabble
		
		print_ready_string("\n")
		ones_complement:
			to_one_comp(%int)
			b exit
		signed_magnitude:
			to_signed_mag(%int)
			b exit
		gray_code:
			to_gray_code(%int)
			b exit
		double_dabble:
			to_double_dabble(%int)
			b exit
		exit:
.end_macro

.macro check_input(%str)
	.text
		lw $t1, %str
		lb $t2, ($t1)
		beq $t2, '1', continue
		beq $t2, 's', continue
		beq $t2, 'g', continue
		beq $t2, 'd', continue
		print_string(error)
		exit()
		continue:
.end_macro

.macro exit()
	.text
		li $v0, 10
		syscall
.end_macro

.macro to_double_dabble(%int)

	.text
		lw $s0, %int
		li $s1, 0
		# $s0 - v
		# $s1 - r
		# $t0 - k
		# $t1 - i
		# $t2 - mask
		# $t3 - cmp
		# $t4 - add
		# $t5 - msb
		# $t6 - 1
		# $t7 - mv
		li $t0, 0
		li $t1, 0
		li $t2, 0xf0000000
		li $t3, 0x40000000
		li $t4, 0x30000000
		get_sign($s0, $t5)
		li $t6, 1
		li $t7, 0
		abs $s0, $s0
		back:
		loop1:
			beq $t0, 32, done #while k < 32
			sll $s0, $s0, 1 
			sll $s1, $s1, 1
			sgt $t5, $t5, 0 #sets t5 to 1 if greater than zero, else zero
			beq $t5, 1, add_one
			return:
			blt $t0, 34, check1
			return2:
			addu $t0, $t0, 1 #k++
			b loop1
		loop2:
			beq $t1, 8, return2
			bge $t7, $t3, jump
			addu $s1, $s1, $t4 #ARITHMETIC OVERFLOW -- WHY!?!?!?!?!?
			jump:
			srl $t2, $t2, 4
			srl $t3, $t3, 4
			addu $t1, $t1, 1
			b loop2
		check1:
			li $t1, 0
			bnez $s1, loop2
			b loop1
		add_one:
			addi $s1, $s1, 1
			b return
		negative:
			print_ready_string("-")
			b back
		done:
		move $a0, $s1
		li $v0, 34
		syscall
		exit:
.end_macro

.macro get_length($int, $reg)
	.text
		beqz $int, zero
		abs $t7, $int
		blt $t7, 10, less_than_10
		blt $t7, 100, less_than_100
		blt $t7, 1000, less_than_1000
		blt $t7, 10000, less_than_10000
		ble $t7, 65535, less_than_or_equal_65535
		
		less_than_10:
			li $reg, 4
			b exit
		less_than_100:
			li $reg, 8
			b exit
		less_than_1000:
			li $reg, 12
			b exit
		less_than_10000:
			li $reg, 16
			b exit
		less_than_or_equal_65535:
			li $reg, 20
			b exit
		zero:
			li $reg, 0
			b exit
		exit:
.end_macro

.macro print_bin($reg)
	.text
		move $a0, $reg
		li $v0, 35
		syscall
.end_macro

.macro get_sign($int, $reg)
	.text
		bltz $int, negative
		li $reg, 0
		negative:
			li $reg, 1
		exit:
.end_macro

.globl main

main:
	load_args()
	check_input(arg2)
	atoi(arg1)
	print_string(msg1)
	print_ready_string(" ")
	print_array_string(arg1saved)
	print_ready_string(" ")
	print_string(msg2)
	print_integer(arg1)
	print_ready_string("\n")
	to_hex(arg1)
	print_ready_string("\n")
	run_arg(arg1, arg2)
	exit()
	
	
	

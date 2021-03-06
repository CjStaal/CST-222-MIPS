# Project One
# name: Charles Staal
# sccid: 01040168

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
		lw $t1, 4($a1) # LW and directly after SW for same register is a pipeline hazard in actual hardware. 
		sw $t0, arg1
		sw $t0, arg1saved
		sw $t1, arg2
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
		# Ones compliment is just twos complement minus one if negative
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
		# Signed Magnitude is just flipping the last bit if negative
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
		# Signed Magnitude is just flipping the last bit if negative
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
		# t0  - int
		# t1 - s
		# t2 - byte of s for comparison
		lw $t0, %int
		lw $t1, %str
		lb $t2, ($t1)
		beq $t2, '1', ones_complement
		beq $t2, 's', signed_magnitude
		beq $t2, 'g', gray_code
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
		move $s1, $0
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
		# $s2 - sign bit
		li $t0, 0 # k
		li $t1, 0 # i
		get_sign($s0, $s2) # sign bit
		li $t6, 1 # just 1
		li $t7, 0 # mv
		abs $s0, $s0 # Double dabble only works with positive numbers. So we use the abs value and just use the msb gathered earlier to print out a - or not
		bgt $s0, 99999999, overflow # This algo won't work with a number with an absolute value above 99999999
		back:
		loop1:
		
			li $t2, 0xf0000000 # mask
			li $t3, 0x40000000 # cmp
			li $t4, 0x30000000 # add
			beq $t0, 32, done # while k < 32
			li $t5, 0 # msb = false
			blt $s0, 0, v_less_than_zero # checks msb and toggles if necessary
			returnV_LTZ:
			sll $s0, $s0, 1 # v = v << 1
			sll $s1, $s1, 1 # r = r << 1
			beq $t5, 1, msb_toggled # if MSB==1, r = r+1
			return:
			blt $t0, 31, check1 # if k < 31 [second check in check1]
			return2:
			addi $t0, $t0, 1 # k++
			b loop1
		loop2:
			beq $t1, 8, return2 # if i = 8, return to loop 1
			and $t7, $t2, $s1 # var mv = mask & r
			bgt $t7, $t3 mvcmp # if mv > cmp
			return3:
			srl $t2, $t2, 4 # mask = mask >>> 4
			srl $t3, $t3, 4 # cmp = cmp >>> 4
			srl $t4, $t4, 4 # add = add >>> 4
			addi $t1, $t1, 1 # increment i for loop2\
			b loop2
		check1:
			li $t1, 0 # initialize i to 0 for loop2
			beqz $s1 return2
			b loop2 # else jump to loop2
		v_less_than_zero:
			li $t5, 1 # msb = true
			b returnV_LTZ
		msb_toggled:
			addi $s1, $s1, 1 # r = r + 1
			b return
		mvcmp:
			add $s1, $s1, $t4  # if mv > cmp, r = r + add
			b return3
		negative:
			print_ready_string("-")
			b done2
		overflow:
			print_ready_string("Overflow, this would require more than 32 bits.\n")
			b exit
		done:
			print_string(dbl)
			beq $s2, 1, negative # prints out negative sign if needed
			done2:
			move $a0, $s1
			li $v0, 34
			syscall
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
		li $reg, 0
		bgez $int, exit
		or $reg, $reg, 1
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
	
	
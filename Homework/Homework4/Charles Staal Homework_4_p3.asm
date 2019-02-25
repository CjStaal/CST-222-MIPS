.data
 tInt: .space 4
 yInt: .space 4
 zInt: .space 4
 aInt: .space 4
 bInt: .space 4
 NameStr: .space 128

.macro print_string(%str)
	.data
		Label: .asciiz %str
	.text
		li $v0, 4
		la $a0, Label
		syscall
.end_macro

.macro get_string(%str)
	la $a0, %str
	li, $a1, 128
	li $v0, 8
	syscall
.end_macro

.macro get_int(%int)
	li $v0, 5
	syscall
	sw $v0, %int
.end_macro

.macro print_int(%int)
	li $v0, 1
	lw $a0, %int
	syscall
.end_macro

.macro Eq1()
	lw $t0, zInt($zero)
	lw $t1, yInt($zero)
	lw $t2, tInt($zero)
	
	sub $t1, $t0, $t1
	add $t1, $t1, $t2
	
	sw $t1, aInt($zero)
.end_macro

.macro Eq2()
	lw $t0, zInt($zero)
	lw $t1, yInt($zero)
	lw $t2, tInt($zero)
	
	addi $t0, $t0, 8 #Z + 8
	mul $t0, $t0, 4 # Z * 4
	sub $t0, $t2, $t0 # T - Z
	add $t0, $t0, $t1 # Z +  Y

	sw $t0, bInt($zero)
.end_macro

.macro exit()
	li $v0, 10
	syscall
.end_macro

.text

main:
	print_string("name: ")
	get_string(NameStr)
	print_string("enter value of t : ")
	get_int(tInt)
	print_string("enter value of y : ")
	get_int(yInt)
	print_string("enter value of z : ")
	get_int(zInt)
	print_string("for: a = z - y + t; a = ")
	Eq1()
	print_int(aInt)
	print_string("\nfor: b = t - 4(8 + z) + y; b = ")
	Eq2()
	print_int(bInt)
	exit()

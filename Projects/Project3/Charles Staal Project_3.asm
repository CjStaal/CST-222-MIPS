##############################################################
# Homework #3
# name: Charles Staal
# scccid: 01040168
##############################################################

.text

# Colors
.eqv BLACK_FOREGROUND 0
.eqv RED_FOREGROUND 1
.eqv GREEN_FOREGROUND 2
.eqv BROWN_FOREGROUND 3
.eqv BLUE_FOREGROUND 4
.eqv MAGENTA_FOREGROUND 5
.eqv CYAN_FOREGROUND 6
.eqv GRAY_FOREGROUND 7
.eqv DARK_GRAY_FOREGROUND 8
.eqv BRIGHT_RED_FOREGROUND 9
.eqv BRIGHT_GREEN_FOREGROUND 10
.eqv YELLOW_FOREGROUND 11
.eqv BRIGHT_BLUE_FOREGROUND 12
.eqv BRIGHT_MAGENTA_FOREGROUND 13
.eqv BRIGHT_CYAN_FOREGROUND 14
.eqv WHITE_FOREGROUND 15

.eqv BLACK_BACKGROUND 0
.eqv RED_BACKGROUND 16
.eqv GREEN_BACKGROUND 32
.eqv BROWN_BACKGROUND 48
.eqv BLUE_BACKGROUND 64
.eqv MAGENTA_BACKGROUND 80
.eqv CYAN_BACKGROUND 96
.eqv GRAY_BACKGROUND 112
.eqv DARK_GRAY_BACKGROUND 128
.eqv BRIGHT_RED_BACKGROUND 144
.eqv BRIGHT_GREEN_BACKGROUND 160
.eqv YELLOW_BACKGROUND 176
.eqv BRIGHT_BLUE_BACKGROUND 192
.eqv BRIGHT_MAGENTA_BACKGROUND 208
.eqv BRIGHT_CYAN_BACKGROUND 224
.eqv WHITE_BACKGROUND 240

# Icons
.eqv ZERO_ICON 48
.eqv ONE_ICON 49
.eqv TWO_ICON 50
.eqv THREE_ICON 51
.eqv FOUR_ICON 52
.eqv FIVE_ICON 53
.eqv SIX_ICON 54
.eqv SEVEN_ICON 55
.eqv EIGHT_ICON 56
.eqv BOMB_ICON 66
.eqv EXPLOSION_ICON 69
.eqv FLAG_ICON 70
.eqv NULL_ICON 0

# Starting address for map
.eqv STARTING_ADDRESS 4294901760

# Default cell-state
.eqv DEFAULT_CELL_COLOR 15
.eqv DEFAULT_CELL_ICON 0

# Quantities
.eqv MAX_CELLS 100 
.eqv MAX_BUFFER_SIZE 1024
.eqv CHAR_TO_INT_VALUE -48
# Syscalls
.eqv PRINT_INTEGER 1
.eqv PRINT_STRING 4
.eqv READ_INTEGER 5
.eqv READ_STRING 8
.eqv EXIT_PROGRAM 10
.eqv PRINT_CHARACTER 11
.eqv READ_CHARACTER 12
.eqv OPEN_FILE 13
.eqv READ_FROM_FILE 14
.eqv WRITE_TO_FILE 15
.eqv CLOSE_FILE 16

##############################
# PART 0 MACROS
##############################

# Going by http://www.cs.ucsb.edu/~franklin/64/resources/spim/BookCallConvention.htm
.macro push_all_stack()
	addi $sp $sp, -64					# -(L+R+A+1+1)*4=64 A = maximum # of args (4), R = Preserved Registers (8), L = words of local data (1), FP (1), SP (1), + padding
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $s0, 20($sp)
	sw $s1, 24($sp)
	sw $s2, 28($sp)
	sw $s3, 32($sp)
	sw $s4, 36($sp)
	sw $s5, 40($sp)
	sw $s6, 44($sp)
	sw $s7, 48($sp)
	sw $fp, 54($sp)
	sw $ra, 56($sp)

.macro pop_all_stack()
	lw $ra, 0($sp)
	lw $fp, 4($sp)
	lw $s7, 8($sp)
	lw $s6, 12($sp)
	lw $s5, 16($sp)
	lw $s4, 20($sp)
	lw $s3, 24($sp)
	lw $s2, 28($sp)
	lw $s1, 32($sp)
	lw $s0, 36($sp)
	lw $a3, 44($sp)
	lw $a2, 48($sp)
	lw $a1, 52($sp)
	lw $a0, 56($sp)
	addi $sp, $sp, 64

##############################
# PART 1 FUNCTIONS
##############################
.globl main
main:
	jal smiley
	nop
	li $v0, 10
	syscall
	
smiley:
	# There are no arguments for this function
	# t0 = Starting address
	# t1 = icon of cell
	# t2 = Color of cell background (high bits) and foreground (low bits)
	# t3 = Counter set at MAX_CELLS and will decrement

	# We are setting all cells to default values
	li $t0, STARTING_ADDRESS				# The starting address of the cells
	li $t1, DEFAULT_CELL_ICON				# t1 will be used for icon
	li $t2, DEFAULT_CELL_COLOR				# t2 will be used for color
	li $t3, MAX_CELLS					# Counter will start at MAX_CELLS and go until it reaches 0

	map_default_loop:					#
		beqz $t3, default_map_done			# There are two hundred bytes in the map and we must go through them all
		sb $t1, 0($t0)					# The first byte stores the icon
		sb $t2, 1($t0)					# The second byte stores the color
		addi $t0, $t0, 2				# We must increment by two since we are modifying two bytes each
		addi $t3, $t3, -1				# Same as above
		b map_default_loop				# Return to the start of the map default loop
	default_map_done:					#
	# We are done setting all cells to default values

	li $t0, STARTING_ADDRESS				# t0 will be starting address
	
	# We are setting the eyes
	li $t1, BOMB_ICON					# The eyes will have a bomb icon
	li $t2, YELLOW_BACKGROUND				# The eyes will have a yellow background color
	addi $t2, $t2, GRAY_FOREGROUND				# The eyes will have gray as foreground color

	sb $t1, 46($t0)						# First coord is ((2*20)+(3*2)) + starting address
	sb $t2, 47($t0)						# The byte right after is the color for said cell

	sb $t1, 52($t0)						# First coord is ((2*20)+(6*2)) + starting address
	sb $t2, 53($t0)						# The byte right after is the color for said cell

	sb $t1, 66($t0)						# First coord is ((3*20)+(3*2)) + starting address
	sb $t2, 67($t0)						# The byte right after is the color for said cell

	sb $t1, 72($t0)						# First coord is ((3*20)+(6*2)) + starting address
	sb $t2, 73($t0)						# The byte right after is the color for said cell
	# Finished setting eyes

	# We are setting the mouth
	li $t1, EXPLOSION_ICON					# The smile will have an explosion icon
	li $t2, RED_BACKGROUND					# The smile will have a red background
	addi $t2, $t2, WHITE_FOREGROUND				# The smile will have a white foreground

	sb $t1, 124($t0)					# First coord is ((6*20)+(2*2)) + starting address
	sb $t2, 125($t0)					# The byte right after is the color for said cell

	sb $t1, 134($t0)					# First coord is ((6*20)+(7*2)) + starting address
	sb $t2, 135($t0)					# The byte right after is the color for said cell

	sb $t1, 146($t0)					# First coord is ((7*20)+(3*2)) + starting address
	sb $t2, 147($t0)					# The byte right after is the color for said cell

	sb $t1, 152($t0)					# First coord is ((7*20)+(6*2)) + starting address
	sb $t2, 153($t0)					# The byte right after is the color for said cell

	sb $t1, 168($t0)					# First coord is ((8*20)+(4*2)) + starting address
	sb $t2, 169($t0)					# The byte right after is the color for said cell

	sb $t1, 170($t0)					# First coord is ((8*20)+(5*2)) + starting address
	sb $t2, 171($t0)					# The byte right after is the color for said cell
	# finished setting mouth

	jr $ra							# returns to previous address

##############################
# PART 2 FUNCTIONS
##############################

open_file:
	# a0 = filename3
	li $a1, 0						#
	li $a2, 0						#
	li $v0, OPEN_FILE					#
	syscall							#

	jr $ra							#

close_file:
	# There are no arguments for this function
	li $v0, CLOSE_FILE					#
	syscall							#

	jr $ra							#

load_map:
	# There are no arguments for this functino
	# s0 = Base address of cell_array
	# s1 = cell location/offset for cell array
	# s2 = counter set at MAX_CELLS and will decrement
	# s3 = Address of File_Buffer. Will be incremented
	# s4 = Char from File_Buffer
	# s5 = Toggle to load in to row or column. If 1 by the time we reach EOF we know there is a coord missing

	push_all_stack()					# Push the stack to preserve previous registers

	la $s3, Cell_Array					# s0 will be the base address of the cell array
	li $s1, 0						# s1 will be the cell location/offset of the cell array

	move $a0, $v0						# v0 contains file descriptor, so move to a0
	li $v0, READ_FILE					# Set the syscall to read from file
	la $a1, File_Buffer					# a1 is the address of the input buffer
	li $a2, MAX_BUFFER_SIZE					# Bytes to be read
	syscall							# Calls the function to read the file in to the buffer

	beq $v0, -1, invalid_case				# If syscall returns a -1, we know there was an error

	li $s5, 0						# Initiates row/column toggle to start with row
	load_map_loop:						#
		lb $s4, 0($s3)					# Load byte in to s4 from cell array
		beq $s4, ' ', increment_map_address		# If it's a space, increment and go to next byte
		beq $s4, '\t', increment_map_address		# If it's a tab, increment and go to next byte
		beq $s4, '\r', increment_map_address		# If it's a carraige return, increment and go to next byte
		beq $s4, '\n', increment_map_address		# If it's a newline, increment and go to next byte
		blt $s4, '0', invalid_case			# If it's less than a '0', it's invalid now
		bgt $s4, '9', invalid_case			# If it's higher than a '9' it's invalid now too
		beq $s5, 1, column_load				# If it's toggled 1, we are dealing with a column
		b row_load					# Else we are dealing with a row
		row_load:					#
			beqz $s4, load_map_full_load		# If it's null, and dealing with a row, we are done
			move $a0, $s4				# Move the byte to the register for the row
			addi $a0, $a0, CHAR_TO_INT_VALUE	# Minus the offset to bring it to it's true value
			addi $s5, $s5, 1			# Increment the toggle so we are dealing with a column now
			b increment_map_address			# Go to the part of the loop where we increment the file buffer address
		column_load:					#
			beqz $s4, invalid_case			# If we are at end of file, while dealing with a column, we are missing a coord so it is wrong
			move $a1, $s4				# Move the char to the column register
			addi $a1, $a1, CHAR_TO_INT_VALUE	# Minus the offset to bring it to its true value
			addi $s5, $s5, -1			# Minus 1 from the toggle so it's zero now and we will deal with a row when we are back
			jal set_bomb				# Go to the function to set up the bomb
		increment_map_address:				#
		addi, $s3, $s3, 1				# Increment the address of the file buffer
		b load_map_loop:				# Return to the start of the loop
	load_map_loop_end:					#

	invalid_case:						#
		li $v0, -1					# Load -1 in to return value so on return we know it failed
		b load_file_finished				# Go to the end of the function

	load_map_full_load:					#
		li $v0, 0					# Load 0 in to return value so on return we know it was successful
		b load_file_finished				# Go to the end of the function

	load_file_finished:					#
		pop_all_stack()					# Pop the stack
		jr $ra						# Return to previous address

##############################
# PART 3 FUNCTIONS
##############################

init_display:
	jr $ra

set_cell:
	jr $ra

reveal_map:
	jr $ra


##############################
# PART 4 FUNCTIONS
##############################

perform_action:
	jr $ra

game_status:
	jr $ra

##############################
# PART 5 FUNCTIONS
##############################

search_cells:
	jr $ra

#################################################################
# Student defined data section
#################################################################

.data
.align 2
Cursor_Row: .word -1
Cursor_Col: .word -1
Cell_Array: .byte MAX_CELLS
File_Buffer .byte MAX_BUFFER_SIZE
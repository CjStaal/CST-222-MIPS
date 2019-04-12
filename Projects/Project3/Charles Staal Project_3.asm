#################################################################
# Homework #3
# name: Charles Staal
# scccid: 01040168
#################################################################

.text
#################################################################
#PART -1 .EQV's
#################################################################

# Cell foreground colors
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

# Cell background colors
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

# Cell icons
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

# Icon colors
.eqv EXPLODED_BOMB_COLOR 151
.eqv BOMB_COLOR 7
.eqv NUMBER_COLOR 13
.eqv FLAG_COLOR 124
.eqv CORRECT_FLAG_COLOR 172
.eqv INCORRECT_FLAG_COLOR 28

# Starting address for map
.eqv STARTING_ADDRESS 4294901760

# Default cell display state
.eqv DEFAULT_CELL_COLOR 15
.eqv DEFAULT_CELL_ICON 0

# Cell info
.eqv ADJ_BOMB 1
.eqv CONT_FLAG 16
.eqv CONT_BOMB 32
.eqv CELL_REVEALED 64

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

#################################################################
# PART 0 MACROS
#################################################################

.macro pack_stack()
	subi $sp, $sp, 36
	sw $ra, 0($sp)
	sw $s7, 4($sp)
	sw $s6, 8($sp)
	sw $s5, 12($sp)
	sw $s4, 16($sp)
	sw $s3, 20($sp)
	sw $s2, 24($sp)
	sw $s1, 28($sp)
	sw $s0, 32($sp)
.end_macro

.macro unpack_stack()
	lw $ra, 0($sp)
	lw $s7, 4($sp)
	lw $s6, 8($sp)
	lw $s5, 12($sp)
	lw $s4, 16($sp)
	lw $s3, 20($sp)
	lw $s2, 24($sp)
	lw $s1, 28($sp)
	lw $s0, 32($sp)
	addi $sp, $sp, 36
.end_macro

.macro zero_cell_array()
	li $t0, MAX_CELLS
	la $t1, Cell_Array
	li $t2, 0

	zero_cell_array_loop:
		beqz $t0, zero_cell_array_done
		sb $t2, 0($t1)
		addi $t1, $t1, 1
		addi $t0, $t0, -1
		b zero_cell_array_loop

	zero_cell_array_done:
.end_macro

.macro set_all_cells(%icon, %color)
	li $t0, STARTING_ADDRESS				# The starting address of the cells
	li $t3, MAX_CELLS					# Counter will start at MAX_CELLS and go until it reaches 0

	map_loop:						#
		beqz $t3, map_done				# There are two hundred bytes in the map and we must go through them all
		sb %icon, 0($t0)				# The first byte stores the icon
		sb %color, 1($t0)				# The second byte stores the color
		addi $t0, $t0, 2				# We must increment by two since we are modifying two bytes each
		addi $t3, $t3, -1				# Same as above
		b map_loop					# Return to the start of the map default loop
	map_done:						#
	# We are done setting all cells to $icon and $color values
.end_macro

#################################################################
# PART 1 FUNCTIONS
#################################################################

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

	li $t1, DEFAULT_CELL_ICON				# t1 will be used for icon
	li $t2, DEFAULT_CELL_COLOR				# t2 will be used for color
	set_all_cells($t1, $t2)

	li $t0, STARTING_ADDRESS				# t0 will be starting address

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

	jr $ra							# returns to previous address

#################################################################
# PART 2 FUNCTIONS
#################################################################

open_file:
	# a0 = filename
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
	# There are no arguments for this function
	# s0 = Base address of cell_array
	# s1 = cell location/offset for cell array
	# s2 = counter set at MAX_CELLS and will decrement
	# s3 = Address of File_Buffer. Will be incremented
	# s4 = Char from File_Buffer
	# s5 = Toggle to load in to row or column. If 1 by the time we reach EOF we know there is a coord missing
	# v0 = Returns -1 if error, else returns 0

	push_all_stack()					# Push the stack to preserve previous registers
	zero_cell_array()					# Make sure the cell array is all zero'd
	la $s3, Cell_Array					# s0 will be the base address of the cell array
	li $s1, 0						# s1 will be the cell location/offset of the cell array

	move $a0, $v0						# v0 contains file descriptor, so move to a0
	li $v0, READ_FROM_FILE					# Set the syscall to read from file
	la $a1, File_Buffer					# a1 is the address of the input buffer
	li $a2, MAX_BUFFER_SIZE					# Bytes to be read
	syscall							# Calls the function to read the file in to the buffer

	beq $v0, -1, invalid_case				# If syscall returns a -1, we know there was an error

	li $s5, 0						# Initiates row/column toggle to start with row
	lb $s4, 0($s3)						# Load the byte before we begin to make sure it's not an empty file
	beqz $s4, invalid_case					# If it's EOF, return error

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
			addi, $s3, $s3, 1			# Increment the address of the file buffer
		b load_map_loop					# Return to the start of the loop

	invalid_case:						#
		li $v0, -1					# Load -1 in to return value so on return we know it failed
		b load_file_finished				# Go to the end of the function

	load_map_full_load:					#
		li $v0, 0					# Load 0 in to return value so on return we know it was successful
		b load_file_finished				# Go to the end of the function

	load_file_finished:					#
		pop_all_stack()					# Pop the stack
		jr $ra						# Return to previous address

#################################################################
# PART 3 FUNCTIONS
#################################################################

init_display:
	# This function takes no arguments
	# We do not need to save the stack as there are no nested functions

	li $t1, NULL_ICON					# Loads the null icon to t1
	li $t2, GRAY_BACKGROUND					# Loads a gray background to t2
	addi $t2, $t2, GRAY_FOREGROUND				# Adds a gray foreground to t2
	set_all_cells($t1, $t2)					# Set all cells to t1 and t2

	sb $t1, Cursor_Row					# NULL_ICON is 0 so we can reuse t1 to make cursor be in row 0
	sb $t1, Cursor_Col					# NULL_ICON is 0 so we can reuse t1 to make cursor be in column 0
	li $t2, YELLOW_BACKGROUND				# Set yellow background to t2
	addi $t2, $t2, GRAY_FOREGROUND				# Add gray foreground to t2
	la $t0, STARTING_ADDRESS				# Load starting address of display
	sb $t2, 1($t0)						# Add the color information to the first box, where the cursor is
	jr $ra							# Return to previous address

set_cell:
	# t0/a0 = Row index
	# t1/a1 = Column index
	# t2/a2 = Icon to be displayed
	# t3/a3 = New Foreground color, and then will be background color + foreground color
	# t4 = New backround color
	# t5 = Scrap

	move $t0, $a0						# Move row index to t0
	move $t1, $a1						# Move column index to t1
	move $t2, $a2						# Move Icon to t2
	move $t3, $a3						# Move foreground color to t3
	lw $t4, 0($sp)						# Load background color from stack to t4

	bltz $t0, set_cell_error				# If row is less than zero
	bltz $t1, set_cell_error				# Or row is greater than 9, return error
	bgt $t0, 9, set_cell_error				# If column is less than zero
	bgt $t1, 9, set_cell_error				# Or column is greater than 9, return error
	bltz $t3, set_cell_error				# If foreground color is less than 0
	bgt $t3, 15, set_cell_error				# Or foreground color is greater than 15, return error
	srl $t5, $t4, 4						# Shift background color code right by 4 bits so we can check the color easier
	bltz $t5, set_cell_error				# If background color is less than 0
	bgt $t5, 15, set_cell_error				# Or is background color is greater than 15, return error

	li $t5, 20						# Load 20 in to t5 for multiplication
	mul $t0, $t0, $t5					# Multiply row by 20 to get offset
	sll $t1, $t1, 2						# Shift column by 2 to multiply it by 2
	addi $t5, $t1, STARTING_ADDRESS				# Add column and the display starting address in to t5
	add $t5, $t5, $t0					# Add the row offset in to t5

	add $t3, $t3, $t4					# Add the two colors together

	sb $t2, 0($t5)						# Store the icon in to the address in t5
	sb $t3, 1($t1)						# Store the color in to the address in t5 + 1
	li $v0, 0						# There was no error, load 0 in to the return value
	b set_cell_end						# Go to the end of the function

	set_cell_error:						# Go here if there is any error
	li $v0, -1						# Load -1 in to the return value

	set_cell_end:						# The end of the function
	jr $ra							# Return to previous address

reveal_map:
	jr $ra

#################################################################
# PART 4 FUNCTIONS
#################################################################

perform_action:
	jr $ra

game_status:
	jr $ra

#################################################################
# PART 5 FUNCTIONS
#################################################################

search_cells:
	jr $ra

#################################################################
# PART 6 STUDENT DEFINED FUNCTIONS
#################################################################

set_bomb:
	# This function returns no value
	# t0/a0 = Row coord
	# t1/a1 = Column coord
	# t2 = Offset + address of cell array
	# t3 = Cell information/bomb
	# t4 = 10 for multiplication
	push_all_stack()					# Preserve the stack since there is a nested function

	move $t0, $a0						# Move row coord to t0
	move $t1, $a1						# move column coord to t1
	la $t2, Cell_Array					# Load address of cell array
	li $t3, CONT_BOMB					# Load info for containing a bomb
	li $t4, 10
	mul $t0, $t0, $t4					# Multiply row coord by 10
	add $t2, $t2, $t0					# Add row to cell array address
	add $t2, $t2, $t1					# Add column coord to the cell array address
	sb $t3, 0($t2)						# Store the bomb info to the address
	jal set_adj_bomb					# Set adjacent cells to show distance to bomb

	pop_all_stack()						# Pop the stack
	jr $ra							# Return to previous address

set_adj_bomb:
	# This function returns no value
	# We do not need to push the stack as this function does not nest another
	# t0/a0 = Row coord
	# t1/a1 = Column coord
	# t2 = Address of cell array
	# t3 = Row counter
	# t4 = Column counter
	# t5 = Row coord + row counter
	# t6 = Column coord + column counter
	# t7 = 10 for multiplication
	move $t0, $a0						# Move row coord to t0
	move $t1, $a1						# Move column cord to t1

	addi $t0, $a0, -1					# Start above bomb
	addi $t1, $a1, -1					# Start to left of bomb
	li $t3, 0						# Set row counter to 0
	li $t4, 0						# Set column counter to 0
	row_loop:						#
		beq $t3, 3, set_adj_bomb_finished		# If the row counter = 3, then we are finished
		column_loop:					#
			beq $t4, 3, return_to_row_loop		# If the column counter = 3, reset the column counter and increment row counter
			b add_cell_info				# Branch to add information to cells
			return_to_column_loop:			# This is where the branch returns to
			addi $t4, $t4, 1			# Increment column counter
			b column_loop				# Return to start of column counter loop
		return_to_row_loop:				# This is where we return to when column counter = 3
		addi $t3, $t3, 1				# Increment row counter
		li $t4, 0					# Reset column counter
		b row_loop					# Return to beginning of row loop
	row_loop_end:						#

	add_cell_info:						#
		add $t5, $t0, $t3				# Add row coord and row counter
		add $t6, $t1, $t4				# Add column coord and column counter
		bltz $t5, return_to_row_loop			# If the row coord now is less than 0, we are off the grid
		bltz $t6, return_to_column_loop			# If the column coord now is less than 0, we are off the grid
		bgt $t5, 9, return_to_row_loop			# If the row coord now is more than 9, we are off the grid
		bgt $t6, 9, return_to_column_loop		# If the column coord now is more than 9, we are off the grid
		la $t2, Cell_Array				# Load the cell array address in to t2
		add $t2, $t2, $t6				# Add the cell array address and column coord
		mul $t5, $t5, $t7				# Multiply row by 10
		add $t2, $t2, $t5				# Add to cell array address
		lb $t7, 0($t2)					# Load the byte from the address of cell array
		beq $t7, CONT_BOMB, return_to_column_loop	# If it is equal to a bomb, don't do anything and return to the column loop
		addi $t7, $t7, ADJ_BOMB				# Else increment it by 1
		sb $t7, 0($t2)					# Store the new byte in to the array
		b return_to_column_loop				# Return to the column loop
	add_info_end:						#

	set_adj_bomb_finished:					#
		jr $ra						# Return to previous address

#################################################################
# Student defined data section
#################################################################

.data
.align 2
Cursor_Row: .word -1
Cursor_Col: .word -1
Cell_Array: .space MAX_CELLS
File_Buffer: .space MAX_BUFFER_SIZE
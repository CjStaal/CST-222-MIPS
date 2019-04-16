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
.eqv BLACK_FOREGROUND 0						#
.eqv RED_FOREGROUND 1						#
.eqv GREEN_FOREGROUND 2						#
.eqv BROWN_FOREGROUND 3						#
.eqv BLUE_FOREGROUND 4						#
.eqv MAGENTA_FOREGROUND 5					#
.eqv CYAN_FOREGROUND 6						#
.eqv GRAY_FOREGROUND 7						#
.eqv DARK_GRAY_FOREGROUND 8					#
.eqv BRIGHT_RED_FOREGROUND 9					#
.eqv BRIGHT_GREEN_FOREGROUND 10					#
.eqv YELLOW_FOREGROUND 11					#
.eqv BRIGHT_BLUE_FOREGROUND 12					#
.eqv BRIGHT_MAGENTA_FOREGROUND 13				#
.eqv BRIGHT_CYAN_FOREGROUND 14					#
.eqv WHITE_FOREGROUND 15					#

# Cell background colors
.eqv BLACK_BACKGROUND 0						#
.eqv RED_BACKGROUND 16						#
.eqv GREEN_BACKGROUND 32					#
.eqv BROWN_BACKGROUND 48					#
.eqv BLUE_BACKGROUND 64						#
.eqv MAGENTA_BACKGROUND 80					#
.eqv CYAN_BACKGROUND 96						#
.eqv GRAY_BACKGROUND 112					#
.eqv DARK_GRAY_BACKGROUND 128					#
.eqv BRIGHT_RED_BACKGROUND 144					#
.eqv BRIGHT_GREEN_BACKGROUND 160				#
.eqv YELLOW_BACKGROUND 176					#
.eqv BRIGHT_BLUE_BACKGROUND 192					#
.eqv BRIGHT_MAGENTA_BACKGROUND 208				#
.eqv BRIGHT_CYAN_BACKGROUND 224					#
.eqv WHITE_BACKGROUND 240					#

# Cell icons
.eqv BOMB_ICON 66						#
.eqv EXPLOSION_ICON 69						#
.eqv FLAG_ICON 70						#
.eqv NULL_ICON 0						#

# Starting address for map
.eqv STARTING_ADDRESS 4294901760				#

# Default cell display state
.eqv DEFAULT_CELL_COLOR 15					#
.eqv DEFAULT_CELL_ICON 0					#

# Cell info
.eqv ADJ_BOMB 1							#
.eqv CONT_FLAG 16						#
.eqv CONT_BOMB 32						#
.eqv CELL_REVEALED 64						#
.eqv FLAGGED_BOMB 48						#
.eqv EXPLODED_BOMB 96						#

# Quantities
.eqv MAX_CELLS 100						#
.eqv ROW_SIZE 10						#
.eqv COLUMN_SIZE 10						#
.eqv MAX_BUFFER_SIZE 256					#
.eqv CHAR_TO_INT_VALUE -48					#
.eqv INT_TO_CHAR_VALUE 48					#
.eqv LOWER_TO_UPPER_VALUE 32					#

# Syscalls
.eqv OPEN_FILE 13						#
.eqv READ_FROM_FILE 14						#
.eqv CLOSE_FILE 16						#

#################################################################
# PART 0 MACROS
#################################################################

.macro pack_stack()
	addi $sp, $sp, -36					#
	sw $ra, 0($sp)						#
	sw $s7, 4($sp)						#
	sw $s6, 8($sp)						#
	sw $s5, 12($sp)						#
	sw $s4, 16($sp)						#
	sw $s3, 20($sp)						#
	sw $s2, 24($sp)						#
	sw $s1, 28($sp)						#
	sw $s0, 32($sp)						#
.end_macro

.macro unpack_stack()
	lw $ra, 0($sp)						#
	lw $s7, 4($sp)						#
	lw $s6, 8($sp)						#
	lw $s5, 12($sp)						#
	lw $s4, 16($sp)						#
	lw $s3, 20($sp)						#
	lw $s2, 24($sp)						#
	lw $s1, 28($sp)						#
	lw $s0, 32($sp)						#
	addi $sp, $sp, 36					#
.end_macro

.macro zero_cells_array(%address)
	li $t1, MAX_CELLS					#
	li $t2, 0						#

	zero_cells_array_loop:					#
		beqz $t1, zero_cells_array_done			#
		sb $t2, 0(%address)				#
		addi %address, %address, 1			#
		addi $t1, $t1, -1				#
		b zero_cells_array_loop				#
	zero_cells_array_done:					#
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
.end_macro

.macro push(%reg)
	addi $sp, $sp, -4
	sw %reg,  0($sp)
.end_macro

.macro pop(%reg)
	lw %reg, 0($sp)
	addi $sp, $sp, 4
.end_macro

.macro get_byte(%row, %col, %reg_for_byte, %cells_array)
	li $t9, ROW_SIZE					# Load ROW_SIZE to t9 for multiplication
	mul %reg_for_byte, %row, $t9				# Multiply Cursor_Row by ROW SIZE
	add %reg_for_byte, %reg_for_byte, %col			# Add Cursor_Col and Cursor_Row * ROW_SIZE
	add %reg_for_byte, %cells_array, %reg_for_byte		# Add the cells_array address and now we have the cells cells_array address
	lb %reg_for_byte, 0(%reg_for_byte)			# Load byte in to the return register for the macro
.end_macro
.macro store_byte(%row, %col, %byte_to_store, %cells_array)
	li $t9, ROW_SIZE					# Load ROW_SIZE to t9 for multiplication
	mul $t9, %row, $t9				# Multiply Cursor_Row by ROW SIZE
	add $t9, $t9, %col			# Add Cursor_Col and Cursor_Row * ROW_SIZE
	add $t9, %cells_array, $t9		# Add the cells_array address and now we have the cells cells_array address
	sb %byte_to_store, 0($t9)			# Load byte in to the return register for the macro
.end_macro
#################################################################
# PART 1 FUNCTIONS
#################################################################

smiley:
	# t0 = Starting address
	# t1 = icon of cell
	# t2 = Color of cell background (high bits) and foreground (low bits)
	# t3 = Counter set at MAX_CELLS and will decrement

	li $t1, DEFAULT_CELL_ICON				# t1 will be used for icon
	li $t2, DEFAULT_CELL_COLOR				# t2 will be used for color
	set_all_cells($t1, $t2)					# Sets all cells to default

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

	li $v0, CLOSE_FILE					#
	syscall							#

	jr $ra							#

load_map:
	# a0 = File descriptor
	# a1 = cells_array address
	# s0 = Base address of cells_array
	# s1 = cell location/offset for cells_array
	# s2 = counter set at MAX_CELLS and will decrement
	# s3 = Address of File_Buffer. Will be incremented
	# s4 = Char from File_Buffer
	# s5 = Toggle to load in to row or column. If 1 by the time we reach EOF we know there is a coord missing
	# v0 = Returns -1 if error, else returns 0

	pack_stack()						# Preserve the stack since there is a nested function
	move $s0, $a1						# Move cells_array address to t0
	zero_cells_array($s0)					# Make sure the cells_array is all zero'd 
	move $s0, $a1						# s0 will be the base address of the cells_array (redoing since the macro incremented it)
	li $s1, 0						# s1 will be the cell location/offset of the cells_array
	li $v0, READ_FROM_FILE					# Set the syscall to read from file
	la $a1, File_Buffer					# a1 is the address of the input buffer
	li $a2, MAX_BUFFER_SIZE					# Bytes to be read
	syscall							# Calls the function to read the file in to the buffer

	beq $v0, -1, invalid_case				# If syscall returns a -1, we know there was an error
	move $s3, $a1						# Move the File_Buffer address to s3
	li $s5, 0						# Initiates row/column toggle to start with row
	lb $s4, 0($s3)						# Load the byte before we begin to make sure it's not an empty file
	beqz $s4, invalid_case					# If it's EOF, return error

	load_map_loop:						#
		lb $s4, 0($s3)					# Load byte in to s4 from file buffer
		beq $s4, ' ', increment_map_address		# If it's a space, increment and go to next byte
		beq $s4, '\t', increment_map_address		# If it's a tab, increment and go to next byte
		beq $s4, '\r', increment_map_address		# If it's a carraige return, increment and go to next byte
		beq $s4, '\n', increment_map_address		# If it's a newline, increment and go to next byte
		beqz $s4, end_of_load				# If it's null, we are at the end of the file
		blt $s4, '0', invalid_case			# If it's less than a '0', it's invalid now
		bgt $s4, '9', invalid_case			# If it's higher than a '9' it's invalid now too
		beq $s5, 1, column_load				# If it's toggled 1, we are dealing with a column

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
			move $a2, $s0				# Move cells_arry base address to arg2
			jal set_bomb				# Go to the function to set up the bomb

		increment_map_address:				#
			addi, $s3, $s3, 1			# Increment the address of the file buffer
		b load_map_loop					# Return to the start of the loop

	end_of_load:						#
		beqz $s5, load_map_full_load			# If s5 = 0 and we are at the end of the file, we know we are finished with no errors

	invalid_case:						#
		li $v0, -1					# Load -1 in to return value so on return we know it failed
		b load_file_finished				# Go to the end of the function

	load_map_full_load:					#
		li $v0, 0					# Load 0 in to return value so on return we know it was successful

	load_file_finished:					#
		unpack_stack()					# Restore the stack
		jr $ra						# Return to previous address

#################################################################
# PART 3 FUNCTIONS
#################################################################

init_display:

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

	bltz $t0, set_cell_error				# If row is < 0, return error
	bltz $t1, set_cell_error				# If column is < 0, return error

	bge $t0, ROW_SIZE, set_cell_error			# If row coord is > ROW_SIZE - 1, reteurn error
	bge $t1, COLUMN_SIZE, set_cell_error			# If column coord is > COLUMN_SIZE - 1, return error

	bltz $t3, set_cell_error				# If foreground color is less than 0
	bgt $t3, 15, set_cell_error				# Or foreground color is greater than 15, return error

	srl $t5, $t4, 4						# Shift background color code right by 4 bits so we can check the color easier
	bltz $t5, set_cell_error				# If background color is less than 0
	bgt $t5, 15, set_cell_error				# Or is background color is greater than 15, return error

	li $t5, ROW_SIZE					# Load ROW_SIZE in to t5
	sll $t5, $t5, 1						# Multiply ROW_SIZE by 2 to get true ROW_SIZE
	mul $t0, $t0, $t5					# Multiply row by (ROW_SIZE * 2) to get offset
	sll $t1, $t1, 1						# Shift column by 2 to multiply it by 2
	addi $t5, $t1, STARTING_ADDRESS				# Add column and the display starting address in to t5
	add $t5, $t5, $t0					# Add the row offset in to t5

	add $t3, $t3, $t4					# Add the two colors together

	sb $t2, 0($t5)						# Store the icon in to the address in t5
	sb $t3, 1($t5)						# Store the color in to the address in t5 + 1

	li $v0, 0						# There was no error, load 0 in to the return value
	b set_cell_end						# Go to the end of the function

	set_cell_error:						# Go here if there is any error
		li $v0, -1					# Load -1 in to the return value

	set_cell_end:						# The end of the function
		jr $ra						# Return to previous address

reveal_map:
	# a0 = -1 is lost, 0 is ongoing, 1 is won
	# a1/s1 = cells_array address
	# s0 = Display address
	# s2 = Counter
	# t0 = Byte from cells_array
	# t1 = Icon to be displayed
	# t2 = Color to be displayed

	pack_stack()						# Preserve the stack since there is a nested function
	beq $a0, 0, reveal_map_end				# If it's a 0, the game is still ongoing
	beq $a0, 1, game_won					# If it's a 1, we won the game and we just need to display the smiley, anything else and we lost the game
	
	la $s0, STARTING_ADDRESS				# Load the display starting address in to s0
	move $s1, $a1						# Move the cells_array address in to s1
	li $s2, 0						# Start counter at 0

	reveal_loop:						#
		beq $s2, MAX_CELLS, game_lost			# If the counter = MAX_CELLS, we are done
		lb $t0, 0($s1)					# Load the byte from the cells_array in to t0

		andi $t0, $t0, 63				# AND the byte with 63 to clear out the 6th bit
		beq $t0, CONT_BOMB, reveal_bomb			# If the byte = CONT_BOMB, then reveal a bomb
		beq $t0, FLAGGED_BOMB, draw_correct_flag	# If the byte contains a flagged bomb, reveal a correct flag
		beqz $t0, draw_empty_cell			# If the array is just 0, draw a default cell
		ble $t0, 8, draw_number				# If the array is between 1 and 8, draw a bright magenta number
		b draw_incorrect_flag				# Else we know there is an incorrect flag there (by exhausting all other options)

		return_to_reveal_loop:				#
		addi $s0, $s0, 2				# Increment the display address by 2
		addi $s1, $s1, 1				# Increment the cells_array address by 1
		addi $s2, $s2, 1				# Increment counter by 1
		b reveal_loop					# Return to loop

	reveal_bomb:						#
		li $t1, BOMB_ICON				# Load bomb icon to t1
		li $t2, GRAY_FOREGROUND				# Load foreground color to t2, it is black background so we don't need to add it
		b draw						#

	draw_correct_flag:					#
		li $t1, FLAG_ICON				# Load flag icon to t1
		li $t2, BRIGHT_BLUE_FOREGROUND			# Load foreground color to t2
		addi $t2, $t2, BRIGHT_GREEN_BACKGROUND		# Add background color to t2
		b draw						#

	draw_empty_cell:					#
		li $t1, DEFAULT_CELL_ICON			# Load default cell icon to t1
		li $t2 DEFAULT_CELL_COLOR			# Load default color to t2
		b draw						#

	draw_number:						#
		addi $t1, $t0, INT_TO_CHAR_VALUE		# Add INT_TO_CHAT_VALUE to int value to obtain the number icon
		li $t2, BRIGHT_MAGENTA_FOREGROUND		# Load foreground color to t2, it is a black background so we don't need to add it
		b draw						#

	draw_incorrect_flag:					#
		li $t1, FLAG_ICON				# Load flag icon to t1
		li $t2, BRIGHT_BLUE_FOREGROUND			# Load foreground color to t2
		addi $t2, $t2, BRIGHT_RED_BACKGROUND		# Add background color to t2
		b draw						#

	game_lost:						#
		lb $a0, Cursor_Row				# Load the cursors row value in to a0
		lb $a1, Cursor_Col				# Load the cursors column value to a1
		li $a2, EXPLOSION_ICON				# Load explosion icon to a2
		li $a3, WHITE_FOREGROUND			# Load white foreground to a3
		li $t0, BRIGHT_RED_BACKGROUND			# Load bright red background to t0

		addi $sp, $sp, -8				# Go in to the stack by 8
		sw $t0, 0($sp)					# Store t0 in to the stack
		sw $ra, 4($sp)					# Save return address on stack
		jal set_cell					# Call set_cell to draw the exploded bomb
		lw $ra, 0($sp)					# Restore return address from stack
		addi $sp, $sp, 8				# Come back up the stack

		b reveal_map_end				# Go to end of function

	draw:							#
		sb $t1, 0($s0)					# Store the icon
		sb $t2, 1($s0)					# Store the color
		b return_to_reveal_loop				# Return to loop

	game_won:						#
		jal smiley					# We won, display a smiley

	reveal_map_end:						#
		unpack_stack()					# Restore the stack
		jr $ra						# Return to previous address

#################################################################
# PART 4 FUNCTIONS
#################################################################

perform_action:
	# s0/a0 = cells_array address
	# s1/a1 = Input (char)
	# s2 = Cursor_Row
	# s3 = Cursor_Col
	# s4 = cells_array address of cell
	# s5 = Display address of cell
	# s6 = New Cursor_Row
	# s7 = New Cursor_Col
	# t0 = Scrap
	# v0 = 0 for valid move, -1 for invalid

	pack_stack()						# Preserve the stack

	move $s1, $a1						# Move the char in to s1
	move $s0, $a0						# Move cells_array address to s0

	lb $s2, Cursor_Row					# Load up Cursor_Row to s2
	lb $s3, Cursor_Col					# Load up Cursor_Col to s3

	move $s6, $s2						# Copy Cursor_Row to s6
	move $s7, $s3						# Copy Cursor_Col to s7

	li $t0, ROW_SIZE					# Load ROW_SIZE to t0 for multiplication
	mul $s4, $s2, $t0					# Multiply Cursor_Row bt ROW SIZE
	add $s4, $s4, $s3					# Add Cursor_Col and Cursor_Row * ROW_SIZE
	add $s4, $s0, $s4					# Add the cells_array address and now we have the cells cells_array address

	mul $s5, $s2, $t0					# Multiply Cursor_Row by ROW_SIZE
	sll $s5, $s5, 1						# Multiply it by 2
	sll $t0, $s3, 1						# Multiply Cursor_Col by 2
	add $s5, $s5, $t0					# Add them together
	addi $s5, $s5, STARTING_ADDRESS				# Add the Display STARTING_ADDRESS and now we have the display address

	lb $t0, 0($s4)						# Load the byte from cells_array

	andi $s1, $s1, '_'					# Will make sure the case is uppercase
	beq $s1, 'R', reveal					# If R, then reveal
	beq $s1, 'F', flag					# If F, then flag
	beq $s1, 'W' move_up					# If W, move up
	beq $s1, 'A', move_left					# If A, move left
	beq $s1, 'S', move_down					# If S, move down
	beq $s1, 'D', move_right				# If D, move right
	b erronous_input					# Else it's erronous input

	reveal:							#
		andi $t1, $t0, CONT_FLAG			# First we need to make sure it doesn't contain a flag
		bne $t1, CONT_FLAG, skip_remove_flag		# If it doesn't, skip removing it
		xori $t0, $t0, CONT_FLAG			# If it does, xor the bit to toggle it
		skip_remove_flag:				# Go here if there is not a flag
		ori $t0, $t0, CELL_REVEALED			# Toggle CELL_REVEALED bit to 1
		sb $t0, 0($s4)					# Store the bit to cells_array
		move $a1, $s2					# Move Cursor_Row to arg1
		move $a2, $s3					# Move Cursor_Col to arg2
		jal draw_current_cell				# Draw the current cell
		move $a0, $s0					# Load cells_array address in a0
		move $a1, $s2					# Move Cursor_Row to arg1
		move $a2, $s3					# Move Cursor_Col to arg2
		jal search_cells				# Search the adjacent cells to reveal others
		li $v0, 0					# Since we don't go to draw_cursor, we need to set it here
		b perform_action_end				# End action

	flag:							#
		andi $t1, $t0, CELL_REVEALED			# Make sure the cell is not revealed
		beq $t1, CELL_REVEALED, perform_action_end	# If it is, do nothing and end the function
		xori $t0, $t0, CONT_FLAG			# Toggle the flag
		sb $t0, 0($s4)					# Store the byte in to cells_array
		move $a1, $s2					# Move Cursor_Row to arg1
		move $a2, $s3					# Move Cursor_Col to arg2
		jal draw_current_cell				# Draw the current cell
		b draw_cursor					# Draw the cursor on the cell

	move_up:						#
		addi $s6, $s2, -1				# Subtract 1 from the new Cursor_Row
		bltz $s6, erronous_input			# If its < 0, we know it's erronous input
		li $t0, ROW_SIZE				# Load up ROW_SIZE to t0 for negation
		sll $t0, $t0, 1					# Multiply ROW_SIZE by 2
		sub $s5, $s5, $t0				# Subtract ROW_SIZE from Display address
		move $a1, $s2					# Move Cursor_Row to arg1
		move $a2, $s3					# Move Cursor_Col to arg2
		jal draw_current_cell				# Draw the current cell
		b draw_cursor					# Draw the cursor on the new cell

	move_left:						#
		addi $s7, $s3, -1				# Subtract 1 from the new Cursor_Col
		bltz $s7, erronous_input			# If its < 0, we know it's erronous input
		li $t0, 2					# Load 2 in to t0 for subtraction
		sub $s5, $s5, $t0				# Minus 2 from Display address
		move $a1, $s2					# Move Cursor_Row to arg1
		move $a2, $s3					# Move Cursor_Col to arg2
		jal draw_current_cell				# Draw the current cell
		b draw_cursor					# Draw the cursor on the new cell

	move_down:						#
		addi $s6, $s2, 1				# Add 1 to the new Cursor_Row
		bge $s6, ROW_SIZE, erronous_input		# If it's larger or equal to ROW_SIZE, we know it's erronous
		li $t0, ROW_SIZE				# Load up ROW_SIZE to t0 for additon 
		sll $t0, $t0, 1					# Multiply ROW_SIZE by 2
		add $s5, $s5, $t0				# Add it to display address
		move $a1, $s2					# Move Cursor_Row to arg1
		move $a2, $s3					# Move Cursor_Col to arg2
		jal draw_current_cell				# Draw the current cell
		b draw_cursor					# Draw the cursor on the new cell

	move_right:						#
		addi $s7, $s3, 1				# Add 1 to the new Cursor_Row
		bge $s7, COLUMN_SIZE, erronous_input		# If it's larger or equal to COLUMN_SIZE, we know it's erronous
		addi $s5, $s5, 2				# Add 2 to display address
		move $a1, $s2					# Move Cursor_Row to arg1
		move $a2, $s3					# Move Cursor_Col to arg2
		jal draw_current_cell				# Draw the current cell
		b draw_cursor					# Draw the cursor on the new cell

	draw_cursor:
		lb $t2, 1($s5)					# Load the color byte from display address
		andi $t2, $t2, 15				# AND it with 15 to save the right most 4 bits and zero our the 4 MSBs
		addi $t2, $t2, YELLOW_BACKGROUND		# Add the new background color
		sb $t2, 1($s5)					# Store the new color combo
		sb $s6, Cursor_Row				# Store the new Cursor_Row
		sb $s7, Cursor_Col				# Store the new Cursor_Col
		li $v0, 0					# Load up v0 for return
		b perform_action_end				# Go to the end of the function

	erronous_input:						#
		li $v0, -1					# Load -1 for return

	perform_action_end:					#
	unpack_stack()						# Restore the stack
	jr $ra							# Return to previous address


game_status:
	# s0/a0 = cells_array address
	# v0 = -1 if lost, 0 if ongoing, 1 if won
	# t0 = Counter
	# t1 = Byte from cells_array
	# t2 = Number of boxes revealed
	# t3 = Number of bombs
	# t4 = Number of correct flags
	# t5 = Scrap

	move $s0, $a0						# Move cells_array address in to s0
	li $t2, 0						# Set revealed counter to 0
	li $t3, 0						# Set bomb counter to 0
	li $t4, 0						# Set correct flag counter to 0

	game_status_loop:					#
		beq $t0, MAX_CELLS, check_win_condition		# If we are done going through the map, check the win condition
		lb $t1, 0($s0)					# Load byte from cells_array to t1

		beq $t1, EXPLODED_BOMB, game_lost_exploded_bomb	# If it's equal to the exploded bomb, we lost

		andi $t5, $t1, CELL_REVEALED			# AND the byte with CELL_REVEALED to check the 5th bit
		beq $t5, CELL_REVEALED, log_revealed_cell	# If it's equal to itself, we know it's a revealed cell, now we must check if it's a bomb

		andi $t5, $t1, CONT_FLAG			# AND the byte with CONT_FLAG to see if it's flagged
		beq $t5, CONT_FLAG, check_flagged_cell		# If it's equal to itself, we know it contains a flag, we must check if that flag is correct

		return_to_game_status_loop:			#
		addi $s0, $s0, 1				# Increment the cells_array address by 1
		addi $t0, $t0, 1				# Increment the counter by 1
		b game_status_loop				#

	log_revealed_cell:					#
		addi $t2, $t2, 1				# Add 1 to number of boxes revealed
		b return_to_game_status_loop			# Return to game loop by the end of it

	check_flagged_cell:					#
		andi $t5, $t1, CONT_BOMB			# Check to see if the flagged cell is correctly flagged
		bne $t5, CONT_BOMB, game_ongoing		# If it is not correctly flagged, the game is stil on
		addi $t4, $t4, 1				# If it is correctly flagged, increment the correct flag counter by 1
		b return_to_game_status_loop			# Return to the status loop

	check_win_condition:					#
		add $t5, $t2, $t4				# Add the revealed cells and the correct flags together
		bne $t5, MAX_CELLS, game_ongoing		# If it is not equal to MAX_CELLS, we know the game is still going

	game_won_status:					#
		li $v0, 1					# If the game is won, return 1
		b game_status_end				# Go to the end of game_status

	game_ongoing:						#
		li $v0, 0					# If the game is ongoing, return 0
		b game_status_end				# Go to the end of game status

	game_lost_exploded_bomb:				#
		li $v0, -1					# If we revealed a bomb, we lost the game

	game_status_end:					#
	jr $ra							# Return to previous address

#################################################################
# PART 5 FUNCTIONS
#################################################################

search_cells:
	# a0 = cells_array address
	# a1 = Row coord
	# a2 = Column coord
	# s1 = row
	# t1 = modified row
	# s2 = col
	# t2 = modified col
	# s3 = byte from cells_array
	# t3 = modified byte
	# s7 = ROW_SIZE for mult
	pack_stack()						# Lets save the stack
	move $fp, $sp						# fp = sp
	push($a1)						# sp.push(row)
	push($a2)						# sp.push(col)

	search_cells_loop:					# The loop
		beq $fp, $sp, search_cells_done			# While(sp != fp)
		pop($s2)
		pop($s1)
		# if (!cell[row][col].isFlag())
		get_byte($s1, $s2, $s3, $a0)			# 
		andi $t4, $s3, CONT_FLAG			#
		beq $t4, CONT_FLAG, skip_reveal			# if (!cell[row][col].isFlag())

		move $a1, $s1					#
		move $a2, $s2					#
		ori $s3, $s3, CELL_REVEALED
		store_byte($s1, $s2, $s3, $a0)
		jal draw_current_cell				# cell[row][col].reveal()
		skip_reveal:

		# if (cell[row][col].getNumber() == 0)
		andi $t3, $s3, 15
		bnez $t3, search_cells_loop

			# if (row + 1 < 10 && cell[row + 1][col].isHidden() && !cell[row + 1][col].isFlag())
			addi $t1, $s1, 1
			bge $t1, ROW_SIZE, if2		# row + 1 < ROW_SIZE
			get_byte($t1, $s2, $s3, $a0)			# cell[row + 1][col]
			andi $t3, $s3, CELL_REVEALED
			beq $t3, CELL_REVEALED, if2	# && cell[row + 1][col] is hidden

			andi $t3, $s3, CONT_FLAG
			beq $t3, CONT_FLAG, if2		# && cell[row + 1][col] !flag

			push($t1)
			push($s2)

			if2:
			# if (row + 1 < 10 && cell[row][col + 1].isHidden() && !cell[row][col + 1].isFlag())
			addi $t1, $s1, 1
			bge $t1, ROW_SIZE, if3		# row + 1 < ROW_SIZE

			addi $t2, $s2, 1
			get_byte($s1, $t2, $s3, $a0)			# cell[row][col + 1]
			andi $t3, $s3, CELL_REVEALED
			beq $t3, CELL_REVEALED, if3	# && cell[row][col + 1] is hidden

			andi $t3, $s3, CONT_FLAG
			beq $t3, CONT_FLAG, if3		# && cell[row][col + 1] !flag

			push($s1)
			push($t2)

			if3:
			# if (row - 1 >= 0 && cell[row - 1][col].isHidden() && !cell[row - 1][col].isFlag())
			addi $t1, $s1, -1
			bltz $t1, if4			# row - 1 >= 0
			get_byte($t1, $s2, $s3, $a0)			# cell [row - 1][col]
			andi $t3, $s3, CELL_REVEALED
			beq $t3, CELL_REVEALED, if4	# && cell[row - 1][col] is hidden

			andi $t3, $s3, CONT_FLAG
			beq $t3, CONT_FLAG, if4		# && cell[row - 1][col] !flag

			push($t1)
			push($s2)

			if4:
			# if (row - 1 >= 0 && cell[row][col - 1].isHidden() && !cell[row][col - 1].isFlag())
			addi $t1, $s1, -1
			bltz $t1, if5			# row - 1 >= 0

			addi $t2, $s2, -1
			get_byte($s1, $t2, $s3, $a0)
			andi $t3, $s3, CELL_REVEALED
			beq $t3, CELL_REVEALED, if5	# && cell[row][col - 1] is hidden

			andi $t3, $s3, CONT_FLAG
			beq $t3, CONT_FLAG, if5		# && cell[row][col - 1] !flag

			push($s1)
			push($t2)

			if5:
			# if (row - 1 >= 0 && col - 1 >= 0) && cell[row - 1][col - 1].isHidden() && !cell[row - 1][col - 1].isFlag())
			addi $t1, $s1, -1
			addi $t2, $s2, -1
			bltz $t1, if6
			bltz $t2, if6
			get_byte($t1, $t2, $s3, $a0)
			andi $t3, $s3, CELL_REVEALED
			beq $t3, CELL_REVEALED, if6	# && cell[row - 1][col - 1] is hidden

			andi $t3, $s3, CONT_FLAG
			beq $t3, CONT_FLAG, if6		# && cell[row - 1][col - 1] !flag
			push($t1)
			push($t2)

			if6:
			# if (row - 1 >= 0 && col + 1 < 10 && cell[row - 1][col + 1].isHidden() && !cell[row - 1][col + 1].isFlag())
			addi $t1, $s1, -1
			addi $t2, $s2, 1
			bltz $t1, if7
			bge $t2, COLUMN_SIZE, if7
			get_byte($t1, $t2, $s3, $a0)
			andi $t3, $s3, CELL_REVEALED
			beq $t3, CELL_REVEALED, if7	# && cell[row - 1][col + 1] is hidden

			andi $t3, $s3, CONT_FLAG
			beq $t3, CONT_FLAG, if7		# && cell[row - 1][col + 1] !flag
			push($t1)
			push($t2)

			if7:
			# if (row + 1 < 10 && col - 1 >= 0 && cell[row + 1][col - 1].isHidden() && !cell[row + 1][col - 1].isFlag())
			addi $t1, $s1, 1
			addi $t2, $s2, -1
			bge $t1, ROW_SIZE, if8
			bltz $t2, if8
			get_byte($t1, $t2, $s3, $a0)
			andi $t3, $s3, CELL_REVEALED
			beq $t3, CELL_REVEALED, if8	# && cell[row + 1][col - 1] is hidden

			andi $t3, $s3, CONT_FLAG
			beq $t3, CONT_FLAG, if8		# && cell[row + 1][col - 1] !flag
			push($t1)
			push($t2)

			if8:
			# if (row + 1 < 10 && col + 1 < 10 && cell[row + 1][col + 1].isHidden() && !cell[row + 1][col + 1].isFlag())
			addi $t1, $s1, 1
			addi $t2, $s2, 1
			bge $t1, ROW_SIZE, search_cells_loop
			bge $t2, COLUMN_SIZE, search_cells_loop
			get_byte($t1, $t2, $s3, $a0)
			andi $t3, $s3, CELL_REVEALED
			beq $t3, CELL_REVEALED, search_cells_loop	# && cell[row + 1][col + 1] is hidden

			andi $t3, $s3, CONT_FLAG
			beq $t3, CONT_FLAG, search_cells_loop		# && cell[row + 1][col + 1] !flag
			push($t1)
			push($t2)
			b search_cells_loop
	search_cells_done:
	unpack_stack()
	jr $ra
#################################################################
# PART 6 STUDENT DEFINED FUNCTIONS
#################################################################
draw_current_cell:
	# a0 = cells_array address
	# t0/a1 = Cursor row
	# t1/a2 = Cursor Column
	# t2 = Display address + offset
	# t3 = cells_array address + offset
	# t4 = Byte from cells_array
	# t5 = Scrap

	move $t0, $a1						# Load Cursor_Row to t0
	move $t1, $a2						# Load Cursor_Col to t1

	li $t5, ROW_SIZE					# Load ROW_SIZE to t5
	mul $t2, $t0, $t5					# Multiply Cursor_Row by ROW_SIZE
	sll $t2, $t2, 1						# Multiply new Cursor_Row by 2
	sll $t3, $t1, 1						# Multiply Cursor_Col by 2
	add $t2, $t2, $t3					# Add the two together
	addi $t2, $t2, STARTING_ADDRESS				# Add the display starting address

	mul $t3, $t0, $t5					# Multiply Cursor_Row by ROW_SIZE
	add $t3, $t3, $t1					# Add Cursor_Row and Cursor_Col
	add $t3, $t3, $a0					# Add cells_array starting address

	lb $t4, 0($t3)						# Load byte from cells_array
	beq $t5, EXPLODED_BOMB, draw_explosion			# If it's an exploded bomb, draw explosion

	andi $t5, $t4, CONT_FLAG				# AND the byte with CONT_FLAG
	beq $t5, CONT_FLAG, draw_flag				# If it equals CONT_FLAG, draw a flag

	andi $t5, $t4, CELL_REVEALED				# AND the byte with CELL_REVEALED
	bne $t5, CELL_REVEALED, set_cell_to_hidden		# If it does not equal CELL_REVEALED, set cell to hidden

	andi $t5, $t4, 15					# AND the byte with 15 to clear out the 4 MSB's
	beqz $t5, set_cell_black				# If it's equal to 0, we know it's null, draw null cell
	blt $t5, 9, set_cell_num				# If it's 1-8, draw a numbered cell
	bge $t5, 9, set_cell_black				# If its > 8, draw a null cell, but honestly wtf we don't know whats in here

	set_cell_black:						#
		li $t5, NULL_ICON				# Load null icon
		li $t6, BLACK_BACKGROUND			# Load black background
		b draw_the_cell					# Draw the cell

	draw_explosion:						#
		li $t5, EXPLOSION_ICON				# Load explosion icon
		li $t6, WHITE_FOREGROUND			# Load white foreground
		addi $t6, $t6, BRIGHT_RED_BACKGROUND		# Add bright red background
		b draw_the_cell					# Draw the cell

	set_cell_num:						#
		addi $t5, $t5, INT_TO_CHAR_VALUE		# Add the INT_TO_CHAR value to load the number icon value
		li $t6, BRIGHT_MAGENTA_FOREGROUND		# Load bright magenta foreground
		addi $t6, $t6, BLACK_BACKGROUND			# Add black background
		b draw_the_cell					# Draw the cell
	
	draw_flag:						#
		li $t5, FLAG_ICON				# Load the flag icon
		li $t6, BRIGHT_MAGENTA_FOREGROUND		# Load bright magenta foreground
		addi $t6, $t6, GRAY_BACKGROUND			# Add gray background
		b draw_the_cell					# Draw the cell

	set_cell_to_hidden:					#
		li $t5, NULL_ICON				# Load null icon
		li $t6, GRAY_FOREGROUND				# Load gray foreground
		addi $t6, $t6, GRAY_BACKGROUND			# Add gray background
		b draw_the_cell					# Draw the cell

	draw_the_cell:						#
		sb $t5, 0($t2)					# Store icon in first byte
		sb $t6, 1($t2)					# Store color info in second byte

	jr $ra							# Return to previous address
	
set_bomb:
	# t0/a0 = Row coord
	# t1/a1 = Column coord
	# t2/a2 = cells_array address	(Will then be cells_array address + offset)
	# t3 = Cell information/bomb
	# t4 = Row size for multiplication

	pack_stack()						# Preserve the stack since there is a nested function
	move $t0, $a0						# Move row coord to t0
	move $t1, $a1						# move column coord to t1
	move $t2, $a2						# move address of cells_array in to t2

	li $t3, CONT_BOMB					# Load info for containing a bomb
	li $t4, ROW_SIZE					# Load ROW_SIZE in to t4 to multiply

	mul $t0, $t0, $t4					# Multiply row coord by ROW_SIZE
	add $t2, $t2, $t0					# Add row to cells_array address
	add $t2, $t2, $t1					# Add column coord to the cells_array address

	sb $t3, 0($t2)						# Store the bomb info to the address
	jal set_adj_bomb					# Set adjacent cells to show distance to bomb

	unpack_stack()						# Restore the stack
	jr $ra							# Return to previous address

set_adj_bomb:
	# t0/a0 = Row coord
	# t1/a1 = Column coord
	# t2/a2 = cells_array address
	# t3 = Row counter
	# t4 = Column counter
	# t5 = Row coord + row counter
	# t6 = Column coord + column counter
	# t7 = ROW_SIZE for multiplication

	move $t0, $a0						# Move row coord to t0
	move $t1, $a1						# Move column cord to t1
	li $t3, 0						# Set row counter to 0
	li $t4, 0						# Set column counter to 0

	addi $t0, $a0, -1					# Start above bomb
	addi $t1, $a1, -1					# Start to left of bomb

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

	add_cell_info:						#
		add $t5, $t0, $t3				# Add row coord and row counter
		add $t6, $t1, $t4				# Add column coord and column counter

		bltz $t5, return_to_row_loop			# If the row coord now is less than 0, we are off the grid
		bltz $t6, return_to_column_loop			# If the column coord now is less than 0, we are off the grid

		bge $t5, ROW_SIZE, return_to_row_loop		# If the row coord now is more than (ROW_SIZE - 1), we are off the grid
		bgt $t6, COLUMN_SIZE, return_to_column_loop	# If the column coord now is more than (COLUMN_SIZE - 1), we are off the grid

		move $t2, $a2					# Move the cells_array address in to t2
		add $t2, $t2, $t6				# Add the cells_array address and column coord

		li $t7, ROW_SIZE				# Load ROW_SIZE to t7 for multiplication
		mul $t5, $t5, $t7				# Multiply row by ROW_SIZE
		add $t2, $t2, $t5				# Add to cells_array address

		lb $t7, 0($t2)					# Load the byte from the address of cells_array
		beq $t7, CONT_BOMB, return_to_column_loop	# If it is equal to a bomb, don't do anything and return to the column loop
		addi $t7, $t7, ADJ_BOMB				# Else increment it by 1
		sb $t7, 0($t2)					# Store the new byte in to the array
		b return_to_column_loop				# Return to the column loop

	set_adj_bomb_finished:					#
		jr $ra						# Return to previous address

#################################################################
# Student defined data section
#################################################################

.data
.align 2
Cursor_Row: .word -1
Cursor_Col: .word -1
File_Buffer: .space MAX_BUFFER_SIZE

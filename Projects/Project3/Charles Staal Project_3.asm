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
.eqv REVEALED_BOMB 96						#

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
	move $t0, $a1						#
	zero_cells_array($t0)					# Make sure the cells_array is all zero'd
	move $s0, $a1						# s0 Will be the base address of the cells_array
	li $s1, 0						# s1 will be the cell location/offset of the cells_array
	li $v0, READ_FROM_FILE					# Set the syscall to read from file
	la $a1, File_Buffer					# a1 is the address of the input buffer
	li $a2, MAX_BUFFER_SIZE					# Bytes to be read
	syscall							# Calls the function to read the file in to the buffer

	beq $v0, -1, invalid_case				# If syscall returns a -1, we know there was an error
	move $s3, $a1
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
			move $a2, $s0
			jal set_bomb				# Go to the function to set up the bomb

		increment_map_address:				#
			addi, $s3, $s3, 1			# Increment the address of the file buffer
		b load_map_loop					# Return to the start of the loop

	end_of_load:						#
		beqz $s5, load_map_full_load			#

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
		sw $ra, 4($sp)					#
		jal set_cell					# Call set_cell to draw the exploded bomb
		lw $ra, 0($sp)					#
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

	pack_stack()
	li $v0, 0
	move $s1, $a1
	move $s0, $a0
	lb $s2, Cursor_Row
	lb $s3, Cursor_Col

	li $t0, ROW_SIZE
	mul $s4, $s2, $t0
	add $s4, $s4, $s3
	add $s4, $s0, $s4

	mul $s5, $s2, $t0
	sll $s5, $s5, 1
	sll $t0, $s3, 1
	add $s5, $s5, $t0
	addi $s5, $s5, STARTING_ADDRESS

	andi $s1, $s1, '_'			# Will make sure the case is uppercase
	beq $s1, 'R', reveal
	beq $s1, 'F', flag
	beq $s1, 'W' move_up
	beq $s1, 'A', move_left
	beq $s1, 'S', move_down
	beq $s1, 'D', move_right
	b erronous_input

	reveal:
		lb $t0, 0($s4)
		ori $t0, $t0, CELL_REVEALED
		andi $t1, $t0, CONT_BOMB
		beq $t1, CONT_BOMB, reveal_action_bomb
		andi $t1, $t0, CONT_FLAG
		bne $t1, CONT_FLAG, skip_reveal_flag
		xori $t0, $t0, CONT_FLAG
		skip_reveal_flag:
		sb $t0, 0($s4)
		andi $t0, $t0, 15
		beqz $t0, draw_default_cell
		blt $t0, 9, draw_number_cell
		bge $t0, 9, erronous_input

	reveal_action_bomb:
		sb $t0, 0($s4)
		li $t1, BRIGHT_RED_BACKGROUND
		addi $t1, $t1, WHITE_FOREGROUND
		li $t2, EXPLOSION_ICON
		sb $t1, 0($s5)
		sb $t2, 1($s5)
		b perform_action_valid_input

		
	draw_default_cell:
		li $t1, DEFAULT_CELL_ICON
		li $t2, DEFAULT_CELL_COLOR
		sb $t1, 0($s5)
		sb $t2, 1($s5)
		b perform_action_valid_input

	draw_number_cell:
		addi $t1, $t1, INT_TO_CHAR_VALUE
		li $t2, BRIGHT_MAGENTA_FOREGROUND
		sb $t1, 0($s5)
		sb $t2, 1($s5)
		b perform_action_valid_input

	skip_explosion:
		andi $t1, $t0, CONT_FLAG
		beq $t1, CONT_FLAG, erronous_input
		andi $t1, $t0, 15
		beqz $t1, draw_default_cell
		ble, $t1, 8, draw_number_cell
		bgt $t1, 8, erronous_input
	flag:
		lb $t0, 0($s4)
		andi $t1, $t0, CONT_FLAG
		beq, $t1, CONT_FLAG, remove_flag
		ori $t0, $t0, CONT_FLAG
		sb $t0, 0($s4)
		li $t1, GRAY_BACKGROUND
		addi $t1, $t1, BRIGHT_BLUE_FOREGROUND
		li $t2, FLAG_ICON
		sb $t1, 0($s5)
		sb $t2, 1($s5)
		b perform_action_valid_input

	remove_flag:
		xori $t0, $t0, CONT_FLAG
		sb $t0, 0($s4)
		move $a1, $s2
		move $a2, $s3
		jal reset_current_cell
		b perform_action_valid_input

	move_up:
		addi $s6, $s2, -1
		bltz $s6, erronous_input
		move $a1, $s2
		move $a2, $s3
		jal reset_current_cell
		sb $s6, Cursor_Row
		li $t0, ROW_SIZE
		sll $t0, $t0, 1
		sub $s5, $s5, $t0
		b draw_cursor
		
	move_left:
		addi $s7, $s3, -1
		bltz $s7, erronous_input
		move $a1, $s2
		move $a2, $s3
		jal reset_current_cell
		sb $s7, Cursor_Row
		li $t0, 2
		sub $s5, $s5, $t0
		b draw_cursor

	move_down:
		addi $s6, $s2, 1
		bge $s6, ROW_SIZE, erronous_input
		move $a1, $s2
		move $a2, $s3
		jal reset_current_cell
		sb $s6, Cursor_Row
		li $t0, ROW_SIZE
		sll $t0, $t0, 1
		add $s5, $s5, $t0
		b draw_cursor

	move_right:
		addi $s7, $s3, 1
		bge $s7, COLUMN_SIZE, erronous_input
		jal reset_current_cell
		sb $s7, Cursor_Row
		addi $s5, $s5, 1
		b draw_cursor

	draw_cursor:
		lb $t2, 1($s5)
		andi $t2, $t2, 15
		addi $t2, $t2, YELLOW_BACKGROUND
		sb $t2, 1($s5)
		b perform_action_valid_input

	perform_action_valid_input:
		li $v0, 0
		b perform_action_end
	erronous_input:
		li $v0, -1
		b perform_action_end

	perform_action_end:
	unpack_stack()
	jr $ra


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
		andi $t5, $t1, CELL_REVEALED			# AND the byte with CELL_REVEALED to check the 5th bit
		beq $t5, CELL_REVEALED, check_revealed_cell	# If it's equal to itself, we know it's a revealed cell, now we must check if it's a bomb
		andi $t5, $t1, CONT_FLAG			# AND the byte with CONT_FLAG to see if it's flagged
		beq $t5, CONT_FLAG, check_flagged_cell		# If it's equal to itself, we know it contains a flag, we must check if that flag is correct
		andi $t5, $t1, CONT_BOMB			# AND the byte with CONT_BOMB to see if it's a bomb
		beq $t5, CONT_BOMB, game_ongoing		# If it is a bomb, we know it is not revealed, and not flagged, so the game is still on
		return_to_game_status_loop:			#
		addi $s0, $s0, 1				# Increment the cells_array address by 1
		addi $t0, $t0, 1				# Increment the counter by 1
		b game_status_loop				#

	check_revealed_cell:					#
		andi $t5, $t1, CONT_BOMB			# Check to see if we revealed a bomb
		beq $t5, CONT_BOMB, game_lost_revealed_bomb	# If we did reveal a bomb, we lost the game
		addi $t2, $t2, 1				# Increment the revealed counter by 1
		b return_to_game_status_loop			# Return to the status loop

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

	game_lost_revealed_bomb:				#
		li $v0, -1					# If we revealed a bomb, we lost the game

	game_status_end:					#
	jr $ra							# Return to previous address

#################################################################
# PART 5 FUNCTIONS
#################################################################

search_cells:
    jr $ra


#################################################################
# PART 6 STUDENT DEFINED FUNCTIONS
#################################################################
reset_current_cell:
	# a0 = cells_array address
	# t0 = Cursor row
	# t1 = Cursor Column
	# t2 = Display address + offset
	# t3 = cells_array address + offset
	# t4 = Byte from cells_array
	# t5 = Scrap

	lb $t0, Cursor_Row
	lb $t1, Cursor_Col

	li $t5, ROW_SIZE
	mul $t2, $t0, $t5
	sll $t2, $t2, 1
	sll $t3, $t1, 1
	add $t2, $t2, $t3
	addi $t2, $t2, STARTING_ADDRESS

	mul $t3, $t0, $t5
	add $t3, $t3, $t1
	add $t3, $t3, $a0

	lb $t4, 0($t3)

	andi $t5, $t4, CONT_FLAG
	beq $t5, CONT_FLAG, draw_flag

	andi $t5, $t4, CELL_REVEALED
	bne $t5, CELL_REVEALED, set_cell_to_hidden

	andi $t5, $t4, 15
	beqz $t5, set_cell_black
	blt $t5, 9, set_cell_num
	bge $t5, 9, set_cell_black

	set_cell_black:
		li $t5, NULL_ICON
		li $t6, BLACK_BACKGROUND
		b draw_current_cell

	set_cell_num:
		addi $t5, $t5, INT_TO_CHAR_VALUE
		li $t6, BRIGHT_MAGENTA_FOREGROUND
		addi $t6, $t6, BLACK_BACKGROUND
		b draw_current_cell
	
	draw_flag:
		li $t5, FLAG_ICON
		li $t6, BRIGHT_MAGENTA_FOREGROUND
		addi $t6, $t6, GRAY_BACKGROUND
		b draw_current_cell
	set_cell_to_hidden:
		li $t5, NULL_ICON
		li $t6, GRAY_FOREGROUND
		addi $t6, $t6, GRAY_BACKGROUND
		b draw_current_cell
	draw_current_cell:
		sb $t5, 0($t2)
		sb $t6, 1($t2)
	reset_current_cell_end:
	jr $ra
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

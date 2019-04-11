##############################################################
# Homework #3
# name: Charles Staal
# scccid: 01040168
##############################################################
.text

# Colors
.eqv BLACK 0x0000
.eqv RED 0x0001
.eqv GREEN 0x0010
.eqv BROWN 0x0011
.eqv BLUE 0x0100
.eqv MAGENTA 0x0101
.eqv CYAN 0x0110
.eqv GRAY 0x0111
.eqv DARK_GRAY 0x1000
.eqv BRIGHT_RED 0x1001
.eqv BRIGHT_GREEN 0x1010
.eqv YELLOW 0x1011
.eqv BRIGHT_BLUE 0x1100
.eqv BRIGHT_MAGENTA 0x1101
.eqv BRIGHT_CYAN 0x1110
.eqv WHITE 0x1111

# Icons
.eqv ZERO '0'
.eqv ONE '1'
.eqv TWO '2'
.eqv THREE '3'
.eqv FOUR '4'
.eqv FIVE '5'
.eqv SIX '6'
.eqv SEVEN '7'
.eqv EIGHT '8'
.eqv BOMB 'B'
.eqv EXPLOSION 'E'
.eqv FLAG 'F'
.eqv NULL '\0'

# Starting address for map
.eqv STARTING_ADDRESS 0xffff0000

# Default cell-state
.eqv DEFAULT_CELL_COLOR 0x00001111
.eqv DEFAULT_CELL_ICON '\0'

##############################
# PART 1 FUNCTIONS
##############################

set_map_default:
	# There are no arguments. This function merely resets all icons to their default state

	# t0 = starting address
	# t1 = default cell colors
	# t2 = default cell icon
	# t3 = counter

	la $t0, STARTING_ADDRESS			# The starting address of the cells
	li $t1, DEFAULT_CELL_COLOR			# t1 will be used for color
	li $t2, DEFAULT_CELL_ICON			# t2 will be used for icon
	li $t3, 0					# Counter will start at zero and go until it reaches 200

	map_default_loop:
		beq $t3, 200, default_map_done		# There are two hundred bytes in the map and we must go through them all
		sb $t1, 0($t0)				# The first byte stores the color
		sb $t2, 1($t1)				# The second byte stores the icon
		addi $t0, $t0, 2			# We must increment by two since we are modifying two bytes each
		addi $t3, $t3, 2			# Same as above
		b map_default_loop

	default_map_done:
	jr $ra

smiley:
	# t0 = Starting address
	# t1 = Color of cell background (high bits) and foreground (low bits)
	# t2 = icon of cell

	pack_stack()					# We are calling a function inside this function, so we need to pack the stack

	jal set_map_default				# Will set all cells to their default state

	li $t0, STARTING_ADDRESS			# t0 will be starting address

	# We are setting the eyes
	lui $t1, YELLOW					# The eyes will have a yellow background color
	addi $t1, $t1, GRAY				# The eyes will have gray as foreground color
	li $t2, BOMB					# The eyes will have a bomb icon

	sb $t0, 46($t0)					# First coord is ((2*20)+(3*2)) + starting address	
	sb $t1, 47($t0)					# The byte right after is the icon for said cell

	sb $t0, 52($t0)					# First coord is ((2*20)+(6*2)) + starting address	
	sb $t1, 53($t0)					# The byte right after is the icon for said cell

	sb $t0, 66($t0)					# First coord is ((3*20)+(3*2)) + starting address	
	sb $t1, 67($t0)					# The byte right after is the icon for said cell

	sb $t0, 72($t0)					# First coord is ((3*20)+(6*2)) + starting address	
	sb $t1, 73($t0)					# The byte right after is the icon for said cell
	# Finished setting eyes

	# We are setting the mouth
	lui $t1, RED					# The smile will have a red background
	addi $t1, $t1, WHITE				# The smile will have a white foreground
	li $t2, EXPLOSION				# The smile will have an explosion icon

	sb $t0, 124($t0)				# First coord is ((6*20)+(2*2)) + starting address	
	sb $t1, 125($t0)				# The byte right after is the icon for said cell

	sb $t0, 134($t0)				# First coord is ((6*20)+(7*2)) + starting address	
	sb $t1, 135($t0)				# The byte right after is the icon for said cell

	sb $t0, 146($t0)				# First coord is ((7*20)+(3*2)) + starting address	
	sb $t1, 147($t0)				# The byte right after is the icon for said cell

	sb $t0, 152($t0)				# First coord is ((7*20)+(6*2)) + starting address	
	sb $t1, 153($t0)				# The byte right after is the icon for said cell

	sb $t0, 168($t0)				# First coord is ((8*20)+(4*2)) + starting address	
	sb $t1, 169($t0)				# The byte right after is the icon for said cell

	sb $t0, 170($t0)				# First coord is ((8*20)+(5*2)) + starting address	
	sb $t1, 171($t0)				# The byte right after is the icon for said cell
	# finished setting mouth

	unpack_stack()					# The stack must be unpacked before returning
	jr $ra						# returns to previous address

##############################
# PART 2 FUNCTIONS
##############################

open_file:
	# a0 = filename
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall

	jr $ra

close_file:
	li $v0, 16
	syscall

	jr $ra

load_map:
	jr $ra

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
cursor_row: .word -1
cursor_col: .word -1


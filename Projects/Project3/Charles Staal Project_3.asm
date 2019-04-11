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
.eqv ZERO 48
.eqv ONE 49
.eqv TWO 50
.eqv THREE 51
.eqv FOUR 52
.eqv FIVE 53
.eqv SIX 54
.eqv SEVEN 55
.eqv EIGHT 56
.eqv BOMB 66
.eqv EXPLOSION 69
.eqv FLAG 70
.eqv NULL 0

# Starting address for map
.eqv STARTING_ADDRESS 4294901760

# Default cell-state
.eqv DEFAULT_CELL_COLOR 15
.eqv DEFAULT_CELL_ICON 0

##############################
# PART 1 FUNCTIONS
##############################

smiley:
	# t0 = Starting address
	# t1 = icon of cell
	# t2 = Color of cell background (high bits) and foreground (low bits)

	li $t0, STARTING_ADDRESS			# The starting address of the cells
	li $t1, '\0'			# t1 will be used for icon
	li $t2, 15			# t2 will be used for color
	li $t3, 0					# Counter will start at zero and go until it reaches 200

	map_default_loop:
		beq $t3, 200, default_map_done		# There are two hundred bytes in the map and we must go through them all
		sb $t1, 0($t0)				# The first byte stores the icon
		sb $t2, 1($t0)
		addi $t0, $t0, 2			# We must increment by two since we are modifying two bytes each
		addi $t3, $t3, 2			# Same as above
		b map_default_loop

	default_map_done:

	li $t0, STARTING_ADDRESS			# t0 will be starting address
	
	# We are setting the eyes
	li $t2, YELLOW_BACKGROUND			# The eyes will have a yellow background color
	addi $t2, $t2, GRAY_FOREGROUND			# The eyes will have gray as foreground color
	li $t1, BOMB					# The eyes will have a bomb icon

	sb $t1, 46($t0)					# First coord is ((2*20)+(3*2)) + starting address
	sb $t2, 47($t0)					# The byte right after is the color for said cell

	sb $t1, 52($t0)					# First coord is ((2*20)+(6*2)) + starting address
	sb $t2, 53($t0)					# The byte right after is the color for said cell

	sb $t1, 66($t0)					# First coord is ((3*20)+(3*2)) + starting address
	sb $t2, 67($t0)					# The byte right after is the color for said cell

	sb $t1, 72($t0)					# First coord is ((3*20)+(6*2)) + starting address
	sb $t2, 73($t0)					# The byte right after is the color for said cell
	# Finished setting eyes

	# We are setting the mouth
	li $t2, RED_BACKGROUND				# The smile will have a red background
	addi $t2, $t2, WHITE_FOREGROUND			# The smile will have a white foreground
	li $t1, EXPLOSION				# The smile will have an explosion icon

	sb $t1, 124($t0)				# First coord is ((6*20)+(2*2)) + starting address
	sb $t2, 125($t0)				# The byte right after is the color for said cell

	sb $t1, 134($t0)				# First coord is ((6*20)+(7*2)) + starting address
	sb $t2, 135($t0)				# The byte right after is the color for said cell

	sb $t1, 146($t0)				# First coord is ((7*20)+(3*2)) + starting address
	sb $t2, 147($t0)				# The byte right after is the color for said cell

	sb $t1, 152($t0)				# First coord is ((7*20)+(6*2)) + starting address
	sb $t2, 153($t0)				# The byte right after is the color for said cell

	sb $t1, 168($t0)				# First coord is ((8*20)+(4*2)) + starting address
	sb $t2, 169($t0)				# The byte right after is the color for said cell

	sb $t1, 170($t0)				# First coord is ((8*20)+(5*2)) + starting address
	sb $t2, 171($t0)				# The byte right after is the color for said cell
	# finished setting mouth

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
main:
	jal smiley
	li $v0, 10
	syscall
.data
.align 2
cursor_row: .word -1
cursor_col: .word -1


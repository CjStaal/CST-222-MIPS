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
.eqv STARTING_ADDRESS 0xffff0000

# Default cell-state
.eqv DEFAULT_CELL_COLOR 0x00001111
.eqv DEFAULT_CELL_ICON 0

.macro pack_stack()
	addi $sp, $sp, -36
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

##############################
# PART 1 FUNCTIONS
##############################

smiley:
	# t0 = Starting address
	# t1 = Color of cell background (high bits) and foreground (low bits)
	# t2 = icon of cell

	li $t0, STARTING_ADDRESS			# The starting address of the cells
	li $t1, DEFAULT_CELL_COLOR			# t1 will be used for color
	li $t2, DEFAULT_CELL_ICON			# t2 will be used for icon
	li $t3, 0					# Counter will start at zero and go until it reaches 200

	map_default_loop:
		beq $t3, 400, default_map_done		# There are two hundred bytes in the map and we must go through them all
		sb $t1, 0($t0)				# The first byte stores the color
		sb $t2, 1($t0)				# The second byte stores the icon
		addi $t0, $t0, 2			# We must increment by two since we are modifying two bytes each
		addi $t3, $t3, 2			# Same as above
		b map_default_loop

	default_map_done:

	li $t0, STARTING_ADDRESS			# t0 will be starting address

	# We are setting the eyes
	lui $t1, YELLOW					# The eyes will have a yellow background color
	addi $t1, $t1, GRAY				# The eyes will have gray as foreground color
	li $t2, BOMB					# The eyes will have a bomb icon

	sb $t1, 46($t0)					# First coord is ((2*20)+(3*2)) + starting address	
	sb $t2, 47($t0)					# The byte right after is the icon for said cell

	sb $t1, 52($t0)					# First coord is ((2*20)+(6*2)) + starting address	
	sb $t2, 53($t0)					# The byte right after is the icon for said cell

	sb $t1, 66($t0)					# First coord is ((3*20)+(3*2)) + starting address	
	sb $t2, 67($t0)					# The byte right after is the icon for said cell

	sb $t1, 72($t0)					# First coord is ((3*20)+(6*2)) + starting address	
	sb $t2, 73($t0)					# The byte right after is the icon for said cell
	# Finished setting eyes

	# We are setting the mouth
	lui $t1, RED					# The smile will have a red background
	addi $t1, $t1, WHITE				# The smile will have a white foreground
	li $t2, EXPLOSION				# The smile will have an explosion icon

	sb $t1, 124($t0)				# First coord is ((6*20)+(2*2)) + starting address	
	sb $t2, 125($t0)				# The byte right after is the icon for said cell

	sb $t1, 134($t0)				# First coord is ((6*20)+(7*2)) + starting address	
	sb $t2, 135($t0)				# The byte right after is the icon for said cell

	sb $t1, 146($t0)				# First coord is ((7*20)+(3*2)) + starting address	
	sb $t2, 147($t0)				# The byte right after is the icon for said cell

	sb $t1, 152($t0)				# First coord is ((7*20)+(6*2)) + starting address	
	sb $t2, 153($t0)				# The byte right after is the icon for said cell

	sb $t1, 168($t0)				# First coord is ((8*20)+(4*2)) + starting address	
	sb $t2, 169($t0)				# The byte right after is the icon for said cell

	sb $t1, 170($t0)				# First coord is ((8*20)+(5*2)) + starting address	
	sb $t2, 171($t0)				# The byte right after is the icon for said cell
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

main:
	jal smiley

.data
.align 2
cursor_row: .word -1
cursor_col: .word -1


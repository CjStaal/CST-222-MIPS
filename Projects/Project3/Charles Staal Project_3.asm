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
.eqv BOMB 'B'
.eqv EXPLOSION 'E'
.eqv FLAG 'F'
.eqv NULL '\0'

##############################
# PART 1 FUNCTIONS
##############################

smiley:
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

open_file:
	jr $ra

close_file:
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


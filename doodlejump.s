#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Student: Tony Hong, 1005109482
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Completed Milestones:
# - Milestone 1
# - Milestone 2
# - Milestone 3
# - Milestone 4 (score and game over screen)
#
# Which approved additional features have been implemented?
# For Milestone 4, the 2 game features implemented were the Game over / retry and the score count
# Milestone 5 was not completed
#####################################################################



# 0xffff0000: keyboard detection
# 0xffff0004: what key is pressed

.data
	displayAddress: .word 0x10008000 #memory location of the first unit on bitmap display
	platformColor: .word 0x00ffffff #store white as platform color
	doodleColor: .word 0x00aaff00 #store light green as doodle sprite color
	backgroundColor: .word 0x00aaccff #store light blue as background (sky) color
	
	doodlerLocation: .space 24 #store the location of a 5 unit doodler
	platformLocations: .space 24 #store the location of the leftmost unit of an 8 unit platforms (4 platforms on screen at a time)
	speed: .word -32 #store the speed of the doodler
	jumpcount: .word 16

.text   
	lw $s0, displayAddress # $s0 stores the base address for display
	lw $s1, platformColor # $s1 stores the platform color code
	lw $s2, doodleColor # $s2 stores the doodle color code
	lw $s3, backgroundColor # $s3 stores the Background color code
	lw $s4, speed #$s4 stores the vertical speed of doodler
	lw $s5, jumpcount 
	add $s6, $zero, $zero #value 1 indicates a restart
	add $s7, $zero, $zero #score
initial_locations: jal doodler_initial #initialize the doodler location
		   jal platform_initial #initialize the platform locations
		   j initial_render #initialize the bitmap display

#initializes location of the doodler on the screen during first render
doodler_initial:	la $t4, doodlerLocation #t4 holds the address of first unit of doodle character 
			addi $t1, $zero, 976 #t1 stores the value of first unit of doodle character
			sw $t1, 0($t4)
			addi $t1, $zero, 944 #t1 stores the value of first unit of doodle character
			sw $t1, 4($t4)
			addi $t1, $zero, 943 #t1 stores the value of first unit of doodle character
			sw $t1, 8($t4)
			addi $t1, $zero, 911 #t1 stores the value of first unit of doodle character
			sw $t1, 12($t4)
			addi $t1, $zero, 945 #t1 stores the value of first unit of doodle character
			sw $t1, 16($t4)		
			addi $t1, $zero, 913 #t1 stores the value of first unit of doodle character
			sw $t1, 20($t4)	
			jr $ra
			
#initializes the locations of the platforms during first render
platform_initial: la $t4, platformLocations
		  addi $t1, $zero, 1005 #$t1 stores the offset of first platform
		  addi $t2, $zero, 700 #$t2 stores the offset of the second platform 
		  addi $t3, $zero, 300 #$t3 stores the offset of the third platform
		  addi $t5, $zero, 550 #t5 stores the offset of the fourth platform
		  addi $t6, $zero, 440 #$t3 stores the offset of the third platform
		  addi $t7, $zero, 850 #t5 stores the offset of the fourth platform
		  sw $t1, 0($t4)
		  sw $t2, 4($t4)
		  sw $t3, 8($t4) #these three lines store the offset of the platforms into the designated memory locations
		  sw $t5, 12($t4) #these three lines store the offset of the platforms into the designated memory locations
		  sw $t6, 16($t4) #these three lines store the offset of the platforms into the designated memory locations
		  sw $t7, 20($t4) #these three lines store the offset of the platforms into the designated memory locations
		  jr $ra
		  

#initialize the contents of the bitmap display
initial_render:	la $t8, platformLocations
	la $t9, doodlerLocation	
	add $t0, $zero, $zero #counter initialized to zero
	add $t1, $zero, 1024 #counter max set at 1024
initial_background_render:	bge $t0, $t1, initial_platform_render
				sll $t2, $t0, 2 #multiply counter value by 4
				add $t3, $s0, $t2 #t3 stores addr(pixel i)
				sw $s3, 0($t3)
				addi $t0, $t0, 1
				j initial_background_render		
initial_platform_render: add $t0, $zero, $zero #counter initialized to zero
			 add $t1, $zero, 8 #counter max set at 8
			 lw $t2, 0($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal initial_platform_render_loop	
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 4($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal initial_platform_render_loop
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 8($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal initial_platform_render_loop
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 12($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal initial_platform_render_loop
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 16($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal initial_platform_render_loop
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 20($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal initial_platform_render_loop
			 j initial_doodler_render
initial_platform_render_loop:	 bge $t0, $t1, initial_platform_render_loop_end
			 sll $t5, $t0, 2
			 add $t6, $t3, $t5
			 sw $s1, 0($t6)
			 addi $t0, $t0, 1
			 j initial_platform_render_loop
			 
initial_platform_render_loop_end: jr $ra

initial_doodler_render: add $t0, $zero, $zero #counter initialized to zero
			add $t1, $zero, 6 #counter max set at 5
initial_doodler_loop:	bge $t0, $t1, check_new_game
			sll $t2, $t0, 2 #multiply counter value by 4
			add $t3, $t9, $t2 #t3 stores addr(doodler unit i)
			lw $t5, 0($t3) 
			sll $t5, $t5, 2
			add $t6, $s0, $t5
			sw $s2, 0($t6)
			addi $t0, $t0, 1
			j initial_doodler_loop		
#before the user presses s to start the game

check_new_game: beq $s6, 1, game_over_render
		j start
start: lw $t8,  0xffff0000 #loads the value of the address where keystrokes are detected
       addi $s5, $zero, 16
       addi $s7, $zero, 0
       beq $t8, 1, start_detect # branch to input_detected if a keystroke is detected
       li $v0, 32 #syscall 32 to sleep
       li $a0, 30 #sleep for 30 seconds
       syscall #sleep for 30 seconds
       j start
start_detect:  lw $t8, 0xffff0004
       	       beq $t8, 0x73, main
       	       beq $t8, 0x61, Exit
       	       j start
       	       
       	       
#central processing loop for gameplay	
main:	addi $s6, $zero, 1
	lw $t8,  0xffff0000 #loads the value of the address where keystrokes are detected	
  	beq $t8, 1, input_detected # branch to input_detected if a keystroke is detected
after_input_detection: j update_doodle_vertical 
after_doodle_vertical:	j render
after_render: li $v0, 32 #syscall 32 to sleep
  	li $a0, 40 #sleep for 40 milliseconds
  	syscall #sleep for 40 milliseconds
	j main
input_detected: lw $t8, 0xffff0004
		beq $t8, 0x6a, j_pressed
		beq $t8, 0x6b, k_pressed
		beq $t8, 0x61, Exit
		j after_input_detection
		
update_doodle_vertical:la $t4, doodlerLocation #t4 holds the address of first unit of doodle character 
		lw $t5, 0($t4) 
		bne $s5, -1, decrementJumpCounter
		j jumpCounter
decrementJumpCounter: addi $s5, $s5, -1
		
jumpCounter:	beq $s5, -1, goDown
		addi $s4, $zero, -32
		j goUp
goDown:         addi $s4, $zero, 32
		j check_impact
after_check_impact:
		
goUp: 		bge $t5, 992, initial_locations
		bgt $t5, 400, else
		bne $s4, -32, else
		
		j shift_platforms_down
else:		add $t5, $t5, $s4
		sw $t5, 0($t4)
		lw $t5, 4($t4) 
		add $t5, $t5, $s4
		sw $t5, 4($t4)
		lw $t5, 8($t4) 
		add $t5, $t5, $s4
		sw $t5, 8($t4)
		lw $t5, 12($t4) 
		add $t5, $t5, $s4
		sw $t5, 12($t4)
		lw $t5, 16($t4) 
		add $t5, $t5, $s4
		sw $t5, 16($t4)
		lw $t5, 20($t4) 
		add $t5, $t5, $s4
		sw $t5, 20($t4)
		j after_doodle_vertical
		
check_impact: 	lw $t9, doodlerLocation
		la $t8, platformLocations
		addi $t3, $t9, 33
		add $t0, $zero, $zero #counter initialized to zero
		add $t1, $zero, 8 #counter max set at 8
		lw $t2, 0($t8)
		jal platform_check_loop	
		add $t0, $zero, $zero #counter initialized to zero
 		lw $t2, 4($t8)
		jal platform_check_loop
		add $t0, $zero, $zero #counter initialized to zero
 		lw $t2, 8($t8)
		jal platform_check_loop
		add $t0, $zero, $zero #counter initialized to zero
 		lw $t2, 12($t8)
		jal platform_check_loop
		add $t0, $zero, $zero #counter initialized to zero
 		lw $t2, 16($t8)
		jal platform_check_loop
		add $t0, $zero, $zero #counter initialized to zero
 		lw $t2, 20($t8)
		jal platform_check_loop
		j after_check_impact
platform_check_loop:	 bge $t0, $t1, platform_check_loop_end
			 addi $t2, $t2, 1
			 beq $t2, $t3, collision_detected
			 j no_collision
collision_detected:      addi $s5, $zero, 16
			 addi $s4, $zero, -32
			 addi $s7, $s7, 1
			 
no_collision:		addi $t0, $t0 , 1 
			j platform_check_loop
			 
platform_check_loop_end: jr $ra


shift_platforms_down: la $t4, platformLocations
		  add $t0, $zero, $zero
		  addi $t1, $zero, 6
platform_update_loop: bge $t0, $t1, after_doodle_vertical
		  sll $t2, $t0, 2 
		  add $t8, $t4, $t2
		  lw $t5, 0($t8) 
		  bge $t5, 960, create_new_platform
after_create_platform:	addi $t5, $t5, 32
		  sw $t5, 0($t8)
		  addi $t0, $t0, 1
		  j platform_update_loop
		  
create_new_platform:  li $v0, 42
		li $a0, 0
		li $a1, 500
		syscall
		add $t5, $a0, $zero
		j after_create_platform	
		
		  
j_pressed:	la $t4, doodlerLocation #t4 holds the address of first unit of doodle character 
		lw $t5, 0($t4) 
		addi $t5, $t5, -2
		sw $t5, 0($t4)
		lw $t5, 4($t4) 
		addi $t5, $t5, -2
		sw $t5, 4($t4)
		lw $t5, 8($t4) 
		addi $t5, $t5, -2
		sw $t5, 8($t4)
		lw $t5, 12($t4) 
		addi $t5, $t5, -2
		sw $t5, 12($t4)
		lw $t5, 16($t4) 
		addi $t5, $t5, -2
		sw $t5, 16($t4)
		lw $t5, 20($t4) 
		addi $t5, $t5, -2
		sw $t5, 20($t4)
		j after_input_detection
		
k_pressed:	la $t4, doodlerLocation #t4 holds the address of first unit of doodle character 
		lw $t5, 0($t4) 
		addi $t5, $t5, 2
		sw $t5, 0($t4)
		lw $t5, 4($t4) 
		addi $t5, $t5, 2
		sw $t5, 4($t4)
		lw $t5, 8($t4) 
		addi $t5, $t5, 2
		sw $t5, 8($t4)
		lw $t5, 12($t4) 
		addi $t5, $t5, 2
		sw $t5, 12($t4)
		lw $t5, 16($t4) 
		addi $t5, $t5, 2
		sw $t5, 16($t4)
		lw $t5, 20($t4) 
		addi $t5, $t5, 2
		sw $t5, 20($t4)
		j after_input_detection

render:	la $t8, platformLocations
	la $t9, doodlerLocation	
	add $t0, $zero, $zero #counter initialized to zero
	add $t1, $zero, 1024 #counter max set at 1024
background_render:	bge $t0, $t1, platform_render
				sll $t2, $t0, 2 #multiply counter value by 4
				add $t3, $s0, $t2 #t3 stores addr(pixel i)
				sw $s3, 0($t3)
				addi $t0, $t0, 1
				j background_render		
platform_render: add $t0, $zero, $zero #counter initialized to zero
			 add $t1, $zero, 8 #counter max set at 8
			 lw $t2, 0($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal platform_render_loop	
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 4($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal platform_render_loop
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 8($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal platform_render_loop
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 12($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal platform_render_loop
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 16($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal platform_render_loop
			 add $t0, $zero, $zero #counter initialized to zero
 			 lw $t2, 20($t8)
			 sll $t2, $t2, 2 #t2 stores offset of platform 1
			 add $t3, $s0, $t2 #t3 stores location of first unit of platform 1 
			 jal platform_render_loop
			 j doodler_render
platform_render_loop:	 bge $t0, $t1, platform_render_loop_end
			 sll $t5, $t0, 2
			 add $t6, $t3, $t5
			 sw $s1, 0($t6)
			 addi $t0, $t0, 1
			 j platform_render_loop
			 
platform_render_loop_end: jr $ra

doodler_render: add $t0, $zero, $zero #counter initialized to zero
		add $t1, $zero, 6 #counter max set at 5
doodler_loop:	bge $t0, $t1, render_score
		sll $t2, $t0, 2 #multiply counter value by 4
		add $t3, $t9, $t2 #t3 stores addr(doodler unit i)
		lw $t5, 0($t3) 
		sll $t5, $t5, 2
		add $t6, $s0, $t5
		sw $s2, 0($t6)
		addi $t0, $t0, 1
		j doodler_loop		

	 
render_score :  addi $t0, $zero, 10
		div $s7, $t0
		mfhi $t1
		beq $t1, 0, render0
		beq $t1, 1, render1
		beq $t1, 2, render2
		beq $t1, 3, render3
		beq $t1, 4, render4
		beq $t1, 5, render5
		beq $t1, 6, render6
		beq $t1, 7, render7
		beq $t1, 8, render8
		beq $t1, 9, render9
render0:	addi $t3, $s0, 20
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 28
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 148
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,276
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 284
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 412
	     	sw $s1, 0($t3)	
	        addi $t3, $s0, 532
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, 0($t3)	
		j done_ones_render
render1:	addi $t3, $s0, 20
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,148
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 532
	     	sw $s1, 0($t3)	
		j done_ones_render
render2:	addi $t3, $s0, 20
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, 0($t3)		
	     	addi $t3, $s0, 152
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 532
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, 0($t3)	
		j done_ones_render
render3:	addi $t3, $s0, 20
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, 0($t3)		
	     	addi $t3, $s0, 152
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 408
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 532
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, 0($t3)	
		j done_ones_render		
render4:	addi $t3, $s0, 28
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,152
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 280
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,284
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 412
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, 0($t3)	
		j done_ones_render	
render5:	addi $t3, $s0, 20
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, 0($t3)		
	     	addi $t3, $s0, 148
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 408
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 532
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, 0($t3)	
		j done_ones_render		
render6:	addi $t3, $s0, 20
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, 0($t3)		
	     	addi $t3, $s0, 148
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, 0($t3)	
	        addi $t3, $s0,284
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, 0($t3)
	        addi $t3, $s0, 412
	     	sw $s1, 0($t3)		
	     	addi $t3, $s0, 532
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, 0($t3)
		j done_ones_render	
render7:	addi $t3, $s0, 20
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, 0($t3)		
	     	addi $t3, $s0, 28
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,284
	     	sw $s1, 0($t3)	
	        addi $t3, $s0,412
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, 0($t3)
		j done_ones_render
render8:	addi $t3, $s0, 20
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 28
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 148
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,276
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, 0($t3)
	     	addi $t3, $s0, 284
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 412
	     	sw $s1, 0($t3)	
	        addi $t3, $s0, 532
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, 0($t3)	
		j done_ones_render
render9:	addi $t3, $s0, 20
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 28
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 148
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,276
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, 0($t3)
	     	addi $t3, $s0, 284
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 412
	     	sw $s1, 0($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, 0($t3)	
		j done_ones_render
		
		
done_ones_render:mflo $t1
		beq $t1, 0, render00
		beq $t1, 1, render10
		beq $t1, 2, render20
		beq $t1, 3, render30
		beq $t1, 4, render40
		beq $t1, 5, render50
		beq $t1, 6, render60
		beq $t1, 7, render70
		beq $t1, 8, render80
		beq $t1, 9, render90
render00:	addi $t3, $s0, 20
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 28
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 148
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,276
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 284
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 412
	     	sw $s1, -16($t3)	
	        addi $t3, $s0, 532
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, -16($t3)	
		j done_tens_render
render10:	addi $t3, $s0, 20
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,148
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 532
	     	sw $s1, -16($t3)	
		j done_tens_render
render20:	addi $t3, $s0, 20
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, -16($t3)		
	     	addi $t3, $s0, 152
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 532
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, -16($t3)	
		j done_tens_render
render30:	addi $t3, $s0, 20
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, -16($t3)		
	     	addi $t3, $s0, 152
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 408
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 532
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, -16($t3)	
		j done_tens_render		
render40:	addi $t3, $s0, 28
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,152
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 280
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,284
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 412
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, -16($t3)	
		j done_tens_render	
render50:	addi $t3, $s0, 20
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, -16($t3)		
	     	addi $t3, $s0, 148
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 408
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 532
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, -16($t3)	
		j done_tens_render		
render60:	addi $t3, $s0, 20
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, -16($t3)		
	     	addi $t3, $s0, 148
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 276
	     	sw $s1,-16($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, -16($t3)	
	        addi $t3, $s0,284
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, -16($t3)
	        addi $t3, $s0, 412
	     	sw $s1, -16($t3)		
	     	addi $t3, $s0, 532
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, -16($t3)
		j done_tens_render	
render70:	addi $t3, $s0, 20
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, -16($t3)		
	     	addi $t3, $s0, 28
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,284
	     	sw $s1, -16($t3)	
	        addi $t3, $s0,412
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, -16($t3)
		j done_tens_render
render80:	addi $t3, $s0, 20
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 28
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 148
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,276
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, -16($t3)
	     	addi $t3, $s0, 284
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 404
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 412
	     	sw $s1, -16($t3)	
	        addi $t3, $s0, 532
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 536
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, -16($t3)	
		j done_tens_render
render90:	addi $t3, $s0, 20
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,24
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 28
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 148
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 156
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,276
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0,280
	     	sw $s1, -16($t3)
	     	addi $t3, $s0, 284
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 412
	     	sw $s1, -16($t3)	
	     	addi $t3, $s0, 540
	     	sw $s1, -16($t3)	
		j done_tens_render 	



done_tens_render:	j after_render

	 
	 	 
	  	 
game_over_render:add $t0, $zero, $zero #counter initialized to zero
	  add $t1, $zero, 1024 #counter max set at 1024
game_over_background_render:	bge $t0, $t1, text_render
				sll $t2, $t0, 2 #multiply counter value by 4
				add $t3, $s0, $t2 #t3 stores addr(pixel i)
				sw $s3, 0($t3)
				addi $t0, $t0, 1
				j game_over_background_render
				
					
text_render: addi $t3, $s0, 1552 
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1556 
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1560
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1568
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1572
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1580 
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1584
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1588 
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1596
	     sw $s1, 0($t3)
	      addi $t3, $s0, 1600
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1604
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1612
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1628
	     sw $s1, 0($t3)
	         addi $t3, $s0, 1636
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1640
	     sw $s1, 0($t3)
	     
	     addi $t3, $s0, 1680
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1688
	     sw $s1, 0($t3)
	     
	     addi $t3, $s0, 1696
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1712
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1724
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1732
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1744
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1752
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1768
	     sw $s1, 0($t3)
	     
	     
	     
	     addi $t3, $s0, 1808
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1812
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1816
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1824
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1828
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1840
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1852
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1856
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1860
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1876
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1892
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1896
	     sw $s1, 0($t3)
	     
	     addi $t3, $s0, 1936
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1940
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1952
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1968
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1980
	     sw $s1, 0($t3)
	     addi $t3, $s0, 1984
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2004
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2020
	     sw $s1, 0($t3)
		
		
	     addi $t3, $s0, 2064
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2072
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2080
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2084
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2096
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2108
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2116
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2132
	     sw $s1, 0($t3)
	     addi $t3, $s0, 2276
	     sw $s1, 0($t3)
	
	     j start
Exit:
	li $v0, 10 # terminate the program
	syscall

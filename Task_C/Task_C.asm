.data
prompt: .asciiz "Please input your 5 digit pin: \n"
result: .asciiz "Result of division by 3.3: "
divisor: .float 3.3
input_string_length: .space 5 #user will input 5 digits

.text
################## START ######################################
main:
#output text to screen
la $a0, prompt
li $v0, 4
syscall

#get user input
li $v0, 8
la $a1, input_string_length
la $a0, input_string_length ##apply buffer (a0) and max input len (a1) -> the buffer is needed otherwise the (prompt) string is overwritten by data inputted by user
syscall

#check if input 5 digits long - this is complicated. lots of comments


################### STRLEN - COMPLICATED ######################

move $t7, $a0 #first things first, preserve the input string

li $t0, 1 #this is our counter for strlen (t0) - contains the amount of chars in the string
strlen: #initialize loop
	lb $t1, 0($a0) #load the next byte entered by user into t1. a0 keeps being incremented to address of next char.
	beqz $t1, digits_counted #if next byte is null, all digits have been counted. counter holds adigits entered (count is stored in t0)
	addi $t0, $t0, 1 #increment counter
	addi $a0, $a0, 1 #increment program pointer to point to next byte in address
	j strlen #back to start of loop


########### COUNTED CHARS - CHECK IF INPUT IS CORRECT #########
digits_counted:
subi $t0, $t0, 2  # MARS applies carriage return to end of string ("\n"). minus character count by 2 to get actual char count.
beq $t0, 5, convert_to_int #if user has entered 5 numbers, divide numbers!
bgt $t0, 5 main #user entered more than 5 digits, back to start!
blt $t0, 5, main #user entered less than 5 digits, back to start!


##################### CONVERT STRING TO INT  ##################
convert_to_int:
move $a2, $t7 ## grab the string address currently stored in t7
li $t5, 1 #counter
li $a1, 0 #reset a1

convert_to_int_loop:
	lb $t1, 0($a2) #same as strlen, get address of string and store in t1
	subi $t3, $t1, 48 ##cheap fix to convert from ascii to digit. store byte in t
	blt $t3, 0, main ##Char was entered, Back to start!
	bgt $t3, 9, main ##Char was entered, Back to start!
	
	jal power_of #we need to work out what "column" this digit is in i.e tens, hundreds, thousands etc.

	add $a1, $a1, $t3 ##accumulate digits
	beq $t5, 5, divide ##if all 5 digits have been converted, divide!
	addi $t5, $t5, 1 ##increment counter
	addi $a2, $a2, 1 ##increment address pointer
	j convert_to_int_loop
	
power_of:
li $t6, 0 #reset our counter
subi $t6, $t5, 5 #reverse_counter (we're counting the digits the wrong way)

power_of_loop:
	beq $t6, 0, return_to_process ##return
	mul $t3, $t3, 10 ##multiply by 10. if this is the the first digit, multiply by 10^5. last digit, not at all
	addi $t6, $t6, 1
	j power_of_loop
		
return_to_process:
	jr $ra



####################### DIVIDE!!! #####################################

divide:
#store string in co-processor & convert string to float (we used a string to count length)
mtc1 $a1, $f0
cvt.s.w $f0, $f0

l.s $f2, divisor

#divide by 3.3 in co processor
div.s $f12, $f0, $f2



####################### OUTPUT RESULT #################################
#output result string
la $a0, result
li $v0, 4
syscall

#output result
li $v0, 2
syscall

#end

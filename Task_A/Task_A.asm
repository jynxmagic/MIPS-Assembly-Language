.data
prompt_name: .asciiz "Please enter your name: \n"
prompt_pin: .asciiz "Please enter your 5 digit pin: \n"

output: .asciiz "Name and Pin: \n"
separator: .asciiz " - \n"


.text

#Display prompt name
la $a0, prompt_name
li $v0, 4
syscall


#Store name input
li $v0, 8
li $a1, 35 #allocate space for input (35 bytes - 35 Chars)
syscall

move $t1, $a0

##Probably could do some verification here (no numbers in name input) ####

#Display prompt pin
la $a0, prompt_pin
li $v0, 4
syscall

#Store prompt pin
li $v0, 5
syscall

move $t2, $v0

#Output output
la $a0, output
li $v0, 4
syscall

#Output stored name
move $a0, $t1
li $v0, 4
syscall

#Output Seperator ("-")
la $a0, separator
li $v0, 4
syscall

#Output stored pin
move $a0, $t2
li $v0, 1
syscall

#end
li $v0, 10
syscall
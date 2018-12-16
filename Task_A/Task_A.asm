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

add $a1, $a1, $a0

##Probably could do some validation here (no numbers) ####

syscall

#Display prompt pin
la $a0, prompt_pin
li $v0, 4
syscall

#Store prompt pin
li $v0, 5
syscall

add $a2, $a2, $v0

#Output output
la $a0, output
li $v0, 4
syscall

#Output stored name
la $a0, ($a1)
li $v0, 4
syscall

#Output Seperator ("-")
la $a0, separator
li $v0, 4
syscall

#Output stored pin
la $a0, ($a2)
li $v0, 1
syscall

#end
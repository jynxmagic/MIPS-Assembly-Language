.data
question: .asciiz "Please input a 2 digit number: \n"

.text
#Display Question
la $a0, question
li $v0, 4
syscall 

#Store user input
li $v0, 5
syscall
move $a1, $v0

#divide input by 2
div $a2, $a1, 2

#output integer result
output:
move $a0, $a2
li $v0, 1
syscall

#end
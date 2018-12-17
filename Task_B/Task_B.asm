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
la $a1, ($v0)

#divide input by 2
div $a2, $a1, 2

#Check if integer needs to be rounded up (mfhi contains any remainder), branch to relevant function
mfhi $a3
bgtz $a3, round
beqz $a3, output

#round integer result (we cheat and just add 1)
round:
add $a2, $a2, 1

#output integer result
output:
la $a0, ($a2)
li $v0, 1
syscall

#end
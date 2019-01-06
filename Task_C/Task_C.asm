.data
prompt: .asciiz "Please input your 5 digit pin: \n"
result: .asciiz "Result of division by 3.3: "
divisor: .float 3.3

.text
## User input ##
#output text to screen
la $a0, prompt
li $v0, 4
syscall

#get user input
li $v0, 6
syscall



## Division ##
l.s $f2, divisor

#divide by 3.3 in co processor
div.s $f12, $f0, $f2



## Output ##
#output result string
la $a0, result
li $v0, 4
syscall

#output result
li $v0, 2
syscall

#end
li $v0, 10
syscall

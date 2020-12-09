.data
      newLine:        .asciiz "\n"
      userInput:  .space  1001
      invalidWrong: .asciiz "NaN"
      output: .asciiz ""
.text
       main:
           #Getting User's Input
           li $v0, 8
           la $a0, userInput
           li $a1, 1001
           syscall 

       SubC:
           addi $t2, $zero, 1 
           add $v0, $zero, $zero
       SecondLoop:
           add $s6, $a0, $zero
           slti $t1, $s6, 58
           beq $t1, $t2, Handlerof0to9
           j UppercaseHandler
       Return_here: 
           add $v0, $v0, $t1
           jr $ra
       Handlerof0to9:
           slti $t1, $s6, 48
           beq $t1, $t2, WrongInput
           addi $s6, $s6, -48
           j BaseConverter
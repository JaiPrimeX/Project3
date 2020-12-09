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
       UppercaseHandler:
           slti $t1, $s6, 65
           beq $t1, $t2, WrongInput
           slti $t1, $s6, 86
           beq $t1, $zero, LowercaseHandler
           addi $s6, $s6, -55
           j BaseConverter
       LowercaseHandler:
           slti $t1, $s6, 97
           beq $t1, $t2, WrongInput
           slti $t1, $s6, 118
           beq $t1, $zero, WrongInput
           addi $s6, $s6, -87
           j BaseConverter
       WrongInput:
           addi $v0, $v0, -100    #-100 is flag for NaN Input
           jr $ra
       BaseConverter:
           addi $t7, $zero, 31
           addi $t3, $zero, 31
           add $s7, $zero, $zero
           beqz $a1, IfZero
           beq $a1, $t2, MultiplyNumber
           addi $s7, $s7, 1
        MultiplyBase:
           mult $t7, $t3
           mflo $t6
           mfhi $t5
           addu $t7, $t6, $t5
           addi $s7, $s7, 1
           bne $s7, $a1, MultiplyBase
       MultiplyNumber:
           mult $t7, $s6
           mflo $t6
           mfhi $t5
           addu $t1, $t6, $t5
           j Return_here
       IfZero:
           addu $t1, $zero, $s6
           j Return_here
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
	   addi $t4, $zero, $a0
           addi $t7, $zero, 31
           addi $s3, $zero, 31
           add $s7, $zero, $zero
           beqz $t4, IfZero
           beq $t4, $t2, MultiplyNumber
           addi $s7, $s7, 1
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
      MultiplyBase:
           mult $t7, $s3
           mflo $t6
           mfhi $t5
           addu $t7, $t6, $t5
           addi $s7, $s7, 1
           bne $s7, $t4, MultiplyBase
.data
      newLine:        .asciiz "\n"
      userInput:  .space  1001
      invalidWrong: .asciiz "NaN"
      commaaa: .asciiz ","
.text
       main:
           #Getting User's Input
           li $v0, 8
           la $a0, userInput
           li $a1, 1001
           syscall 

       #Return value counter, Incrementing number, Closing loop condition, Character counter
           addi $s0, $zero, 1
           add $t0, $zero, $zero
           addi $s1, $zero, 1000
           addi $t1, $zero, -1
           addi $t2, $zero, 44 
       #Count each chracter and comma to get total of bits to save 
       counter:
           lb $s2, userInput($t0)
           beqz $s2, Skip
           beq $s2, $t2, CommaCount
           addi $t1, $t1, 1
           j Skip
       CommaCount:
           addi $s0, $s0, 1
       Skip:
           addi $t0, $t0, 1
           bne $t0, $s1, counter
           
           # s0 has value of how many return values
           # t1 has the amount of characters
        #Reserve frame pointer
           addi $sp, $sp, -4
           sw $fp, 0($sp)
           add $fp, $sp, $zero
           
           #Manipulate stack to fit characters and return values
           addi $s3, $zero, 4
           mult $s0, $s3
           mfhi $t9
           mflo $t8
           addu $t3, $t9, $t8
           sub $sp, $sp, $t3
           addi $sp, $sp, -1000
           
           #Storing bits into previously destined spaces
           add $s5, $sp, $zero #saving sp value before it gets manipulated
           add $t0, $zero, $zero 
       Storebits:
           lb $s2, userInput($t0)
           sb $s2, 0($sp)
           addi $sp, $sp, 1
           addi $t0, $t0, 1
           bne $t0, $s1, Storebits
           add $sp, $zero, $s5      #restoring sp to position needed before calling
           addi $sp, $sp, -4
           sw $s0, 0($sp) 
           jal SubA
           li $v0, 10
           syscall
       
         SubA:
           lw $a3, 0($sp)
           addi $sp, $sp, 4
          # la $a0, output
          # add $s0, $a0, $zero
           add $a2, $zero, $zero
           add $t9, $zero, $ra
           add $t0, $sp, $zero  #stores previous sp
           #add $t0, $fp, $zero  #stores previous fp 
           #addi $t2, $zero, 44  #Comma value
           add $t5, $zero, $zero, #counter of how many characters in each substring

           
           #Reserve frame pointer
           addi $sp, $sp, -4
           sw $fp, 0($sp)
           add $fp, $sp, $zero
           
           #Manipulate stack to fit characters and return values
           addi $sp, $sp, -8000
           #add $s2, $sp,$zero
           addi $t3, $sp, 0

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
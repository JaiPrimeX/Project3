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
       Begin:
           addi $t2, $zero, 44
           lb $t6, 0($t0)
           beq $t6, $t2, comma
           beqz $t6, comma
           sb $t6, 0($t3)
           addi $t3, $t3,1
           addi $t0, $t0, 1
           addi $t5, $t5, 1
           j Begin
       comma:
           beq $a2, $a3, end
           addi $s5, $zero, 4
           slti $s7, $t5, 5
           beqz $t5, NaNHandler
           beqz $s7, NaNHandler
           sub $s6, $s5, $t5
           bne $s6, $zero, ZeroAdder
       continue:
           addi $t3, $t3, 4
           sw $t5, 0($t3)
           add $sp, $t3, $zero
           jal SubB 
           lw $s7, -4($fp)
           slti $s4, $s7, -1
           addi $t2, $zero, 1 
           beq $s4, $t2, NaNHandler
           move $a0, $s7
           li $v0, 1
           syscall
          # addi $t0, $t0, -4
           #sw $s7, 0($t0)
          # addi $fp, $fp, -4
           #sw $s7, 0($s0)
          # addi $s0, $s0, 4
           addi $a2, $a2, 1
           beq $a2, $a3, end
           la $a0, commaaa
           li $v0, 4
           syscall
           add $t5, $zero, $zero
           j Begin
        NaNHandler:
           la $a0, invalidWrong
           li $v0, 4
           syscall
           addi $a2, $a2, 1
           beq $a2, $a3, end
           j Begin
        ZeroAdder:
           addi $t3, $t3, 1
           sb $zero, 0($t3)
           addi $s6, $s6, -1
           beqz $s6, continue
           j ZeroAdder
        end:
           jr $t9
       SubB:
           addi $t2, $zero, 1 
           add $s3, $zero, $ra
           add $t4, $zero, $zero
           add $s1, $sp, $zero
           lw $s0, 0($s1)
           addi $s1, $s1, -8
           add $s5, $zero, $zero
           addi $a1, $s0, -1
       loop:
           lb $s2, 0($s1)
           beqz $s2, skip2
           jal SubC
           slti $t8, $v0, -1
           beq $t8, $t2, NaNexit
       continue2:  
           add $t4, $t4, $v0
           addi $s1, $s1, 1
           addi $s5, $s5, 1
           addi $a1, $a1, -1
           beq $s0, $s5, Exit2
           j loop
       Exit2:
           move $a0, $t4
           li $v0, 1
           syscall
           la $a0, newLine
           li $v0, 4
           syscall
           sw $t4, -4($fp)
           jr $s3
       skip2:
           addi $s1, $s1, 1
           j loop
           
       NaNexit:
           sw $v0, -4($fp)
           jr $s3
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
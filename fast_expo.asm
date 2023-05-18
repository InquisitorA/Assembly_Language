# Compute x^n recursively

.data
prompt_x: .asciiz "Enter x: "
prompt_n: .asciiz "\nEnter n: "
result: .asciiz "\nResult: "

.text
.globl main



# main program
main:
  # ask user for x
  li $v0, 4
  la $a0, prompt_x
  syscall
  
  # take user input x
  li $v0, 5
  syscall
  move $s0, $v0
  
  # ask user for n
  li $v0, 4
  la $a0, prompt_n
  syscall
  
  # take user input n
  li $v0, 5
  syscall
  move $s1, $v0

  # a0 stores the value of x
  # a1 stores the value of n
  move $a0, $s0
  move $a1, $s1

  addi $sp, $sp, -4
  sw $ra, 0($sp)

  # call power function
  jal power
  
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  
  # using an extra register to store the v0 value returned after the power function completes
  # since v0 will be used again and will be updated and the return value stored will be lost
  move $t4, $v0

  # display result i.e a0
  li $v0, 4
  la $a0, result
  syscall
  
  # a0 takes the value t4 which is the return value of the power function call
  li $v0, 1
  move $a0, $t4
  syscall
  
  # exit program
  li $v0, 10
  syscall



  # Recursive function to compute x^n

power:
  # base case
  # if n == 0, return 1, meaning v0 is 1

  beq $a1, $zero, return_one 

  addi $sp, $sp, -16              
  sw $a0, 0($sp)                  
  sw $a1, 4($sp)                  
  sw $ra, 8($sp)
  
  
  # recursive case
  # compute x^(n/2)
  # t3 is a fixed value of 2
  addi $t3, $zero, 2
  div $a1, $t3

  # mfhi stores the remainder when a1 is divided by t3
  # mflo stores the quotient when a1 is divided by t3
  mfhi $t0
  mflo $a1
  
  # t0 needs to be stored
  sw $t0, 12($sp)

  jal power

  lw $a0, 0($sp)                 
  lw $a1, 4($sp)                  
  lw $ra, 8($sp) 
  lw $t0, 12($sp)                 
  addi $sp, $sp, 16
  
  move $t1, $v0
  
  # computing x^n
  mul $t2, $t1, $t1
  move $v0, $t2

  # if the power is even meaning the remainder t0 is 0 then go to even_power
  beq $t0, $zero, even_power
  
  # else power must be odd in which case multiply by a0 once and then go to return address
  mul $v0, $t2, $a0
  jr $ra

  # v0 takes the value 1 and then returns
return_one:
  li $v0, 1 
  jr $ra

  # if even then go to return address
even_power:
  jr $ra
# MIPS assembly program to perform an iterative binary search to check if an element exists in a sorted array

.data
    array: .space 120 # allocate space for an array of up to 30 integers
    n_prompt: .asciiz "Enter the length of the array (up to 30): "
    array_prompt: .asciiz "\nEnter the element of the array: "
    x_prompt: .asciiz "\nEnter the target element: "
    yes: .asciiz "\nYes at index "
    not_found: .asciiz "\nNot Found"


.text
.globl main

main:
    # print the prompt for the length of the array and read the input
    li $v0, 4
    la $a0, n_prompt
    syscall
    
    li $v0, 5
    syscall
    move $s0 , $v0          # store the length in $s0
    
    # allocate memory for the array
    sll $t0, $s0, 2         # multiply the length by 4 to get the byte size
    move $a0, $t0
    li $v0, 9
    syscall
    move $s1, $v0               # starting address
    
    # read the elements of the array from the user
    li $t1, 0                   # counter of array elements 
    move $s2, $s1           # end address of array


read_loop:
    bge $t1, $s0, read_done         # if all elements are read, exit the loop

    li $v0, 4
    la $a0, array_prompt
    syscall

    li $v0, 5
    syscall
    sw $v0, ($s2)

    addi $s2, $s2, 4 # increment the array address by 4 bytes
    addi $t1, $t1, 1 # increment the index

    j read_loop

read_done:
    # read the target element from the user
    li $v0, 4
    la $a0, x_prompt
    syscall

    li $v0, 5
    syscall
    move $s3, $v0       # store the target element in $s3


    # set the initial values of the lower and upper bounds of the search range
    li $t2, 0                   # lower bound
    addi $t3, $s0, -1           # upper bound


# start the binary search loop
loop:
    bgt $t2, $t3, not_found_label
    
    # calculate the middle index of the search range
    add $t4, $t2, $t3
    srl $t5, $t4, 1         # divide by 2 using shift-right logical
    
    # load the middle element of the search range into a register
    sll $t6, $t5, 2 # multiply by 4 to get the byte offset
    add $t7, $s1, $t6
    lw $s4, ($t7)
    
    # compare the middle element with the target element
    beq $s4, $s3, found_label           # if they are equal, the element is found
    
    # the middle element is greater than the target element, search the left half
    bgt $s4, $s3, left_half
    
    # the middle element is less than the target element, search the right half
    blt $s4, $s3, right_half
    
    # none of the above conditions are true, repeat the loop with the new search range
    j loop
    
left_half:
    addi $t3, $t5, -1 # set the new upper bound to the middle index - 1
    j loop

right_half:
    addi $t2, $t5, 1 # set the new lower bound to the middle index + 1
    j loop

found_label:
    # calculate the index of the target element and print the output
    li $v0, 4
    la $a0, yes
    syscall
    move $a0, $t5
    li $v0, 1
    syscall
    j end_label

not_found_label:
    # print the output for when the element is not found
    li $v0, 4
    la $a0, not_found
    syscall

end_label:
    # exit the program
    li $v0, 10
    syscall

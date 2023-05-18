.data
input_str: .space 100     # allocate space for the input string on the heap
output_str: .asciiz ""    # initialize an empty string for the output

.text
.globl main
main:
    li $v0, 8              # syscall 8 reads a string from input
    la $a0, input_str      # read the input string into the allocated space on the heap
    li $a1, 100            # set the maximum length of the input string to 100
    syscall

    move $t0, $a0          # save the address of the input string in $t0
    la $t1, output_str     # load the address of the output string into $t1

copy_loop:
    lb $t2, ($t0)          # load a byte from the input string
    beq $t2, $zero, done   # if the byte is null, we're done copying
    sb $t2, ($t1)          # store the byte in the output string
    addi $t0, $t0, 1       # increment the input string pointer
    addi $t1, $t1, 1       # increment the output string pointer
    j copy_loop

done:
    li $v0, 4              # syscall 4 prints a string
    la $a0, output_str     # print the output string
    syscall

    li $v0, 10             # syscall 10 exits the program
    syscall

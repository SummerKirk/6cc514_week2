.code16                         # Assemble for 16-bit mode
.globl start
start:
    jmp     real_start

real_start:
# put stuff here ((COMMENTS NEED TO BE UP AGAINST EDGE OR AFTER CODE)
    movw $read_part2_message, %si
    call cons_writeline
    call check_boot_location

endless_loop:                   # Loop forever more
    jmp     endless_loop   

check_boot_location:
# checks value passed from first stage (in: DL)
# 1 or 0 for floppy, 0x80 or more it's hard disk drive
    CMP $0, %dl
    jz result_floppy_disk
    CMP $1, %dl
    je result_floppy_disk
    CMP $0x80, %dl
    jge result_hard_disk
finish_boot_check:
    call cons_writeline
    ret

result_hard_disk:
    movw    $read_hard_disk_msg, %si
    jmp finish_boot_check

result_floppy_disk:
    movw    $read_floppy_disk_msg, %si
    jmp finish_boot_check

read_part2_message:     
    .string "seccond stage has been reached" # movw $message_location, %si before the writeline call

cons_write:
    movb    $0x0e, %ah           # 0x0e is the INT 10h BIOS call to output the value contained in AL to screen

cons_write_rpt:
    movb    (%si), %al          # Load the byte at the location contained in the SI register into AL   
    inc     %si                 # Add 1 to the value in SI
    cmp     $0, %al             # Compare the value in AL with 0
    jz      cons_write_done     # If it is zero, then we are done
    int     $0x10               # Output the character in AL to the screen
    jmp     cons_write_rpt      # and continue

cons_write_done:                # Something that is called will never return 
    ret                         # until a 'ret' instruction is encountered.  Labels do 
                                # not give a program any structure.  They just give a 
                                # memory location a name that we can use in our code. 

cons_write_crlf:
    movb    $0x0e, %ah          # Output CR
    movb    $0x0d, %al
    int     $0x10
    movb    $0x0a, %al          # Output LF
    int     $0x10
    ret

cons_writeline:
    call    cons_write
    call    cons_write_crlf
    ret  

read_hard_disk_msg:
    .string "hard disk"

read_floppy_disk_msg:
    .string "floppy disk"
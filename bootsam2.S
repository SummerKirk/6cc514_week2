.code16                         # Assemble for 16-bit mode
.globl start
start:
    jmp     real_start

real_start:
# put stuff here ((COMMENTS NEED TO BE UP AGAINST EDGE OR AFTER CODE)

check_boot_location:
# checks value passed from first stage (in: DL)
# 1 or 0 for floppy, 0x80 or more it's hard disk drive

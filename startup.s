### **Startup Assembly Code (`startup.s`)**
.section .isr_vector, "a", %progbits
.global __isr_vector
.type __isr_vector, %object

/* Interrupt table */
__isr_vector:
.word   __stack_pointer     /* Stack pointer */
.word   Reset_Handler       /* Reset Handler */
.word   NMI_Handler         /* NMI Handler */
.word   MemManage_Handler   /* Memory Fault Handler */
.word   SysTick_Handler     /* SysTick Handler */

/* Default Handlers */
.weak Default_Handler
.set Default_Handler, __Default_Handler

.size __isr_vector, .-__isr_vector

/* Exception Handlers */
.global Reset_Handler
.global NMI_Handler
.global MemManage_Handler
.global SysTick_Handler

    /* Reset Handler */
Reset_Handler:
    /* Initialize Stack Pointer */
    ldr r0, =__stack_pointer /* Set stack pointer to the end of RAM */
    mov sp,r0

    /* Copy .data section from FLASH to RAM */
    ldr   r0, =_sfdata        /* Address of .data in FLASH */
    ldr   r1, =_sdata         /* Address of .data in RAM */
    ldr   r2, =_edata         /* End address of .data in RAM */
copy_data:
    cmp   r1, r2
    bge   zero_bss
    ldr   r3, [r0]           /* Load data from FLASH */
    add   r0, r0, #4
    str   r3, [r1]           /* Store it in RAM */
    add   r1, r1, #4
    b     copy_data          /* Continue until the end of .data section */
    
    
zero_bss:
    /* Zero out .bss section */
    ldr   r0, =_sbss          /* Start address of .bss */
    ldr   r1, =_ebss          /* End address of .bss */
zero_loop:
    cmp   r0, r1
    bge call_main
    movs   r2, #0
    str   r2, [r0]
    add   r0, r0, #4
    b   zero_loop

call_main:
    /* Jump to main() */
    bl    main

    /* Infinite loop if main returns */
    b     .

    /* Default Handler */
__Default_Handler:
    b     __Default_Handler   /* Infinite loop */

    /* Exception Handlers */
NMI_Handler:
    b     __Default_Handler

MemManage_Handler:
    b     __Default_Handler

SysTick_Handler:
    b     __Default_Handler


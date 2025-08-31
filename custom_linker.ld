/* Microcontroller determines where to start execution after RESET */

ENTRY(Reset_Handler)


/* Memory sections 
RAM Start (low addr)
0x20020000 ──► Top of RAM (high addr)
             ├── Stack starts here (SP initialized here)
             │   Stack grows downward ↓
             │
             │   (free space in the middle)
             │
             ├── Heap grows upward ↑
             ├── .bss
             └── .data
0x20000000 ──► Start of RAM (low addr)
*/

MEMORY { 
  /* Flash memory with read and execute permission */
  FLASH (rx) : ORIGIN =  0x08000000, LENGTH = 128K
  
  /* Ram memory with read, write and execute permission */
  RAM (rwx) : ORIGIN =  0x20000000, LENGTH = 16K
}

/* Stack pointer iniitalisation - End of RAM (stack grows doownwords high-> low address ) */
__stack_pointer =  ORIGIN(RAM) + LENGTH(RAM);

SECTIONS {

    /* place the inerrupt vector table at start of the flash */
    .isr_vector : {

      /* Retain the table */
      KEEP(*(.isr_vector))
         
    } > FLASH

    /* start of text section */
    .text : 
    {
      *(.text*)
       
      *(.rodata*) /* Read-only data (eg: const)*/


    } > FLASH


    /* start of Data section */
    .data :
    {
       /* Source the Flash address of .data */
       _sfdata = LOADADDR(.data);
       
       _sdata = .;
     
       /* Global/ Static variables with iniitial value (int x = 10)*/
       *(.data*)

       _edata = .;
    
    } > RAM

    .bss : 
    {
       _sbss = .;
 
       /* Global/static vaiables without initial values (int y)*/ 
       *(.bss*)
    
       _ebss = .;
    }

    /* dont load this section into final image */
   .heap (NOLOAD) :
    { 
       _sheap = .;

        /* 4KB of Heap space */
       . = . + 0x1000;      
       
       _eheap = .;
     
    } > RAM
    
 
    /* Optional: Stack section (stack grows downward) */
    .stack : 
    {
        _sstack = .;   
      
        /* 4KB of Stack space */
        . = . + 0x1000;  
               
        _estack = .;   
        
    } > RAM

    /* End of BSS section, not strictly needed but useful for some setups */
    end = .;  /* Marks the end of the BSS section (optional) */
}

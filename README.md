# arm-mcu-baremetal-starter

Minimal bare-metal ARM Cortex-M template for learning and starting MCU projects.

## Demonstrates 

- startup initialization
- vector table
- `.data` and `.bss` setup
- `main()` entry without any operating system.


## Directory Structure

├── custom_linker.ld   # Linker script: controls memory layout (Flash, RAM, stack, etc.
├── main.c             # Your main application code
└── startup.s          # Assembly startup (vector table, low-level reset handler)
└── Makefiles          # BUild System
└── build              # Output Ditectory(.elf, .s, .lst etc)


## Build Instructions

### Prerequisites

- ARM GNU Toolchain (Refer: ARM website)

###  Clone Repository

```bash
git clone git@github.com:divyabhaskaran20/arm-mcu-baremetaln-starter.git
cd arm-mcu-baremetal-starter
```

### Build

```bash
make 

Outputs: 
- build/bare_metal_firmware_template.elf
- build/bare_metal_firmware_template.bin
```

### Disassembly

```bash
make disasm-full   # Creates Full disassmenly
make disasm-code   # Creates only Code section

Outputs: 
- build/bare_metal_firmware_template.lst 
- build/bare_metal_firmware_template.s
```

### Clean

```bash
make clean

Outputs:
- Removes all files in build/
```


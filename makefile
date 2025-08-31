# ===============================
# Bare-Metal ARM Cortex-M Makefile
# ===============================


# Create build directory if it doesn't exist
BUILD_DIR = build
$(shell mkdir -p $(BUILD_DIR))

# Toolchain prefix
CROSS   = arm-none-eabi

CC      = $(CROSS)-gcc
AS      = $(CROSS)-as
LD      = $(CROSS)-ld
OBJCOPY = $(CROSS)-objcopy
OBJDUMP = $(CROSS)-objdump

START_UP_FLAGS = -nostdlib -nodefaultlibs

# CPU architecture (change if needed)
CPU     = -mcpu=cortex-m3 -mthumb

# Project name
TARGET  = bare_metal_firmware_template

# Source files
SRCS    = main.c startup.s

# Object files in build/ directory
OBJS    = $(patsubst %.c,build/%.o,$(SRCS))
OBJS    := $(patsubst %.s,build/%.o,$(OBJS))

# Linker script
LDSCRIPT = custom_linker.ld

# ===============================
# Build rules
# ===============================

all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin

# Compile C files target CPU
$(BUILD_DIR)/%.o: %.c
	$(CC) $(CPU) -c $< -o $@

# Assemble startup.s
$(BUILD_DIR)/%.o: %.s
	$(AS) $(CPU) $< -o $@

# Link objects into ELF
# -T linker.id : Tells the GCC to use custom linker script
# -o *.elf : Output in .elf file
$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	$(CC) ${CPU} $(START_UP_FLAGS) -T $(LDSCRIPT) $(OBJS) -o $@
	@echo "ELF built: $@"

# Convert ELF to raw binary
# -O : strip the the ELF metadata, leave out raw binary output
 $(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@
	@echo "BIN built: $@"

# Disassembly for debugging
disasm-full: $(BUILD_DIR)/$(TARGET).elf
	$(OBJDUMP) -D $(BUILD_DIR)/$(TARGET).elf > $(BUILD_DIR)/$(TARGET).lst
	@echo "Disassembly written to  $(BUILD_DIR)/$(TARGET).lst"

disasm-code: $(BUILD_DIR)/$(TARGET).elf
	$(OBJDUMP) -d $(BUILD_DIR)/$(TARGET).elf > $(BUILD_DIR)/$(TARGET).s
	@echo "Disassembly of code section written to $(BUILD_DIR)/$(TARGET).s"


# Clean build artifacts
clean: 
	rm -rf $(BUILD_DIR) 
	
.PHONY: all clean disasm-full disasm-code 

# The ARM toolchain prefix
ARMGNU = arm-none-eabi

# Directory to put the intermediate build files
BUILD = build/

# Directory where the source files are
SOURCE = src/

# Name of the target
TARGET_NAME = kernel

# Name of the file to output
TARGET = kernel.img

# Name of the listing file to output
LIST = kernel.list

# Name of the linker script to use
LINK_SCRIPT = kernel.ld

# Rule to build everything (creates the target image and listing)
all: $(TARGET) $(LIST)

# Rule to create the image file
$(TARGET): $(BUILD)kernel.elf
	$(ARMGNU)-objcopy $(BUILD)kernel.elf -O binary $(TARGET) 

# Rule to make the ELF file
$(BUILD)kernel.elf: $(BUILD)kernel.o $(LINK_SCRIPT)
	$(ARMGNU)-ld $< -o $(BUILD)kernel.elf -T $(LINK_SCRIPT)

# Rule to make the object files
$(BUILD)kernel.o: $(SOURCE)kernel.s $(BUILD)
	$(ARMGNU)-as $< -o $@

# Rule to make the listing file.
$(LIST): $(BUILD)kernel.elf
	$(ARMGNU)-objdump -D $(BUILD)kernel.elf > $(LIST)

# Create the build directory
$(BUILD):
	mkdir $@

# Clean all the intermediate and output files
clean:
	rm -rf build/
	rm -f $(LIST)
	rm -f $(TARGET)

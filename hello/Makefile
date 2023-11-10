# Copyright (c) 2016 Spinal HDL contributors
# SPDX-License-Identifier: MIT

PROJ_NAME=gcd_world
DEBUG=no
BENCH=no
MULDIV=no

SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp)  \
		$(wildcard src/*.S)

OBJDIR = build

INC  =
LIBS =
LIBSINC = -L$(OBJDIR)
LDSCRIPT = ./src/linker.ld
MABI = ilp32f
MARCH_LIB := rv32imafc
MARCH := $(MARCH_LIB)_zicsr

CFLAGS += -march=$(MARCH)  -mabi=$(MABI) -DNDEBUG
LDFLAGS += -march=$(MARCH)  -mabi=$(MABI)


ifeq ($(MULTILIB_HACK),yes)
	CFLAGS += -I$(RISCV_PATH)/riscv32/include
	LDFLAGS += -L$(RISCV_PATH)/riscv32/lib/$(MARCH_LIB)
	LDFLAGS += -L$(RISCV_PATH)/riscv32/lib/$(MARCH_LIB)/$(MABI)
	LDFLAGS += -L$(RISCV_PATH)/riscv32/lib/$(MARCH_LIB)/$(MABI)/except
endif

ifeq ($(DEBUG),yes)
	CFLAGS += -g3 -O0
else
	CFLAGS += -g -Os
endif

RISCV_NAME ?= riscv32-none-elf
RISCV_OBJCOPY ?= $(RISCV_NAME)-objcopy
RISCV_OBJDUMP ?= $(RISCV_NAME)-objdump
CC = clang
RISCV_CC?=$(RISCV_PATH)/bin/$(CC)

# CFLAGS +=  -MD -fstrict-volatile-bitfields -fno-strict-aliasing
# LDFLAGS +=  -nostdlib -lgcc -mcmodel=medany -nostartfiles -ffreestanding 
CFLAGS += -ffunction-sections -fdata-sections
LDFLAGS += -Wl,-Bstatic,-T,$(LDSCRIPT),-Map,$(OBJDIR)/$(PROJ_NAME).map,--print-memory-usage -Wl,--gc-sections
#LDFLAGS += -lgcc -lc -lg -nostdlib  -lgcc  -msave-restore    --strip-debug,

OBJS := $(SRCS)
OBJS := $(OBJS:.c=.o)
OBJS := $(OBJS:.cpp=.o)
OBJS := $(OBJS:.S=.o)
OBJS := $(addprefix $(OBJDIR)/,$(OBJS))


all: $(OBJDIR)/$(PROJ_NAME).elf $(OBJDIR)/$(PROJ_NAME).hex $(OBJDIR)/$(PROJ_NAME).asm $(OBJDIR)/$(PROJ_NAME).v

$(OBJDIR)/%.elf: $(OBJS) | $(OBJDIR)
	$(RISCV_CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LIBSINC) $(LIBS)

%.hex: %.elf
	$(RISCV_OBJCOPY) -O ihex $^ $@

%.bin: %.elf
	$(RISCV_OBJCOPY) -O binary $^ $@

%.v: %.elf
	$(RISCV_OBJCOPY) -O verilog $^ $@

%.asm: %.elf
	$(RISCV_OBJDUMP) -S -d $^ > $@

$(OBJDIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(RISCV_CC) -c $(CFLAGS)  $(INC) -o $@ $^
	$(RISCV_CC) -S $(CFLAGS)  $(INC) -o $@.disasm $^

$(OBJDIR)/%.o: %.cpp
	mkdir -p $(dir $@)
	$(RISCV_CC) -c $(CFLAGS)  $(INC) -o $@ $^

$(OBJDIR)/%.o: %.S
	mkdir -p $(dir $@)
	$(RISCV_CC) -c $(CFLAGS) -o $@ $^ -D__ASSEMBLY__=1

$(OBJDIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(OBJDIR)/src
	rm -f $(OBJDIR)/$(PROJ_NAME).elf
	rm -f $(OBJDIR)/$(PROJ_NAME).hex
	rm -f $(OBJDIR)/$(PROJ_NAME).map
	rm -f $(OBJDIR)/$(PROJ_NAME).v
	rm -f $(OBJDIR)/$(PROJ_NAME).asm
	find $(OBJDIR) -type f -name '*.o' -print0 | xargs -0 -r rm
	find $(OBJDIR) -type f -name '*.d' -print0 | xargs -0 -r rm

clean-all : clean 

.SECONDARY: $(OBJS)

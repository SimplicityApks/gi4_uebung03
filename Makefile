# Simple Makefile to compile the assembler code

CC ?= gcc

TARGET := calculator

.PHONY: all clean

.INTERMEDIATE: $(TARGET).o

all: $(TARGET)

calculator: calculator.o
	$(CC) -m32 -o $@ $^

%.o: %.asm
	nasm -f elf32 -g -F dwarf -l calculator.lst -o $@ $^

clean:
	rm -f $(TARGET)

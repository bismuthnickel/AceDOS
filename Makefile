ASSEMBLY_SOURCES=src/boot.asm src/kernel.asm src/functions.asm
ASSEMBLY_BINARIES=$(patsubst src/%.asm,build/%.bin,$(ASSEMBLY_SOURCES))

IMAGE=build/OS.img

.PHONY: all always test clean

all: always $(IMAGE) test

always: clean
	mkdir -p build

build/OS.bin: $(ASSEMBLY_BINARIES)
	cat $^ > $@

build/%.bin: src/%.asm
	nasm -f bin $< -o $@

$(IMAGE): build/OS.bin
	cp $< $@
	truncate -s 1440k $@

clean:
	rm -rf build

test:
	qemu-system-i386 -drive file=build/OS.img,if=floppy,format=raw -name AceDOS
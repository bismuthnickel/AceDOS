ASSEMBLY_SOURCES=src/boot.asm src/stage2boot.asm src/kernel.asm
ASSEMBLY_BINARIES=$(patsubst src/%.asm,build/%.bin,$(ASSEMBLY_SOURCES))

IMAGE=build/OS.img
PROGRAM=build/PROGRAM.img

.PHONY: all always test clean

all: always clean $(IMAGE) $(PROGRAM) test

always:
	@clear
	@mkdir -p build

build/OS.bin: $(ASSEMBLY_BINARIES)
	cat $^ > $@

build/%.bin: src/%.asm
	nasm -f bin $< -o $@

$(IMAGE): build/OS.bin
	cp $< $@
	truncate -s 1440k $@

$(PROGRAM): build/program.bin
	cp $< $@
	truncate -s 1440k $@

build/program.bin: src/program.asm

clean:
	@rm -rf build/*

test:
	qemu-system-i386 -device sb16 -drive file=build/OS.img,if=floppy,format=raw -drive file=build/PROGRAM.img,if=floppy,format=raw -name AceDOS
	@clear
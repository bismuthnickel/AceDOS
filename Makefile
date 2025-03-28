ASSEMBLY_SOURCES=src/boot.asm src/stage2boot.asm src/kernel.asm
ASSEMBLY_BINARIES=$(patsubst src/%.asm,build/%.bin,$(ASSEMBLY_SOURCES))

PROGRAM_SOURCES=$(wildcard programs/*.asm)
PROGRAM_BINARIES=$(patsubst programs/%.asm,programs/build/%.bin,$(PROGRAM_SOURCES))
PROGRAM_IMAGES=$(patsubst programs/build/%.bin,programs/build/%.img,$(PROGRAM_BINARIES))

IMAGE=build/OS.img
PROGRAM=helloworld

.PHONY: default all always test clean cleanprograms programs run getprograms

default: test

all: always clean $(IMAGE)

programs: always cleanprograms $(PROGRAM_BINARIES) $(PROGRAM_IMAGES) getprograms

always:
	clear
	mkdir -p build
	mkdir -p programs/build

build/OS.bin: $(ASSEMBLY_BINARIES)
	cat $^ > $@

build/%.bin: src/%.asm
	nasm -f bin $< -o $@

programs/build/%.img: programs/build/%.bin
	cp $< $@
	truncate -s 1440k $@
	rm -f $<

programs/build/%.bin: programs/%.asm
	nasm -f bin $< -o $@

$(IMAGE): build/OS.bin
	cp $< $@
	truncate -s 1440k $@

clean: cleanprograms
	rm -rf build/*

cleanprograms:
	rm -rf programs/build/*
	rm -f programs.txt

test: all programs run

run:
	qemu-system-i386 -device sb16 -drive file=$(IMAGE),if=floppy,format=raw -drive file=programs/build/$(PROGRAM).img,if=floppy,format=raw -name AceDOS

getprograms:
	/usr/bin/env bash tools/getfiles.sh $(abspath programs) > programs.txt
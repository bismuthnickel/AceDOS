gcc -Ignu-efi/inc -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args -c src/main.c -o build/main.o
ld -shared -Bsymbolic -Lgnu-efi/x86_64/lib -Lgnu-efi/x86_64/gnuefi -Tgnu-efi/gnuefi/elf_x86_64_efi.lds gnu-efi/x86_64/gnuefi/crt0-efi-x86_64.o build/main.o -o build/main.so -lgnuefi -lefi
objcopy -j .text -j .sdata -j .data -j .rodata -j .dynamic -j .dynsym  -j .rel -j .rela -j .rel.* -j .rela.* -j .reloc --target efi-app-x86_64 --subsystem=10 build/main.so BOOTX64.efi
./write_gpt -i disk.img -ae /EFI/BOOT/ BOOTX64.efi

qemu-system-x86_64 -drive format=raw,file=disk.img -bios bios64.bin -m 256M -vga std -display sdl -name AceDOS -machine q35 -usb -device usb-mouse -rtc base=localtime -net none
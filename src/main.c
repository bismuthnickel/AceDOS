#include <efi.h>
#include <efilib.h>
#include "gnuefisucks.h"

EFI_STATUS
EFIAPI
efi_main(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable) {
    InitializeLib(ImageHandle, SystemTable);

    ClearScreen();

    Print(L"AceDOS Rewrite #2: Electric Boogaloo\n\nwill it actually be good this time??\n");

    asm volatile("cli;hlt");

    return EFI_SUCCESS;
}

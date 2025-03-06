#pragma once

#define ClearScreen() uefi_call_wrapper(SystemTable->ConOut->ClearScreen,1,SystemTable->ConOut)

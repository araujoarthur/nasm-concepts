# Build Process

The build process, composed by assembling/compiling + linking.

This is built in x86 ELF

## 1. Assembling/Compiling

`nasm -f elf stars.asm`

- `-f` is used to specify the format NASM should output. In this case, an Executable and Linkable Format (`elf`).
- `stars.asm` is the source file.

Should generate `stars.o` if everything runs smoothly.


## 2. Linking

`ld -m elf_i386 -s -o stars stars.o`

- `-m` for "emulation". It's for the target architecture. Here the target is `elf_i386`. Tells the linker to link in `elf-i386` mode. (Without this, on a 64-bit system, ld defaults to elf_x86_64 and will refuse to link a 32-bit object.)
- `-s` Strip all symbol and relocation information from the output, effectively making the executable smaller (by removing debug information).
- `-o` specifies the output name, `stars` here.
- `stars.o` is a positional parameter which is the input for the linker.
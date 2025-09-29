# Build Process

The build process, composed by assembling/compiling + linking.

This is built in x86 ELF

## 1. Assembling/Compiling

`nasm -f elf reading.asm`

- `-f` is used to specify the format NASM should output. In this case, an Executable and Linkable Format (`elf`).
- `reading.asm` is the source file.

Should generate `reading.o` if everything runs smoothly.


## 2. Linking

`ld -m elf_i386 -s -o reading reading.o`

- `-m` for "emulation". It's for the target architecture. Here the target is `elf_i386`. Tells the linker to link in `elf-i386` mode. (Without this, on a 64-bit system, ld defaults to elf_x86_64 and will refuse to link a 32-bit object.)
- `-s` Strip all symbol and relocation information from the output, effectively making the executable smaller (by removing debug information).
- `-o` specifies the output name, `reading` here.
- `reading.o` is a positional parameter which is the input for the linker.

## 3. Interesting Tests:

    1. Try to input a number that needs more than 5 bytes to be stored. (In this example, numbers are stored as characters so effectively it means a number with 6 or more characters)
    
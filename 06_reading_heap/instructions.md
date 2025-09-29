# Description
    Requests memory in the heap to store the data that will be read.

# Build Process

The build process, composed by assembling/compiling + linking.

This is built and linked as x86_64 ELF

## 1. Assembling/Compiling

`nasm -f elf64 reading.asm`

- `-f` is used to specify the format NASM should output. In this case, an Executable and Linkable Format (`elf`).
- `reading.asm` is the source file.

Should generate `reading.o` if everything runs smoothly.


## 2. Linking

`ld -m elf_x86_64 -s -o reading reading.o`

- `-m` for "emulation". It's for the target architecture. Here the target is `elf_x86_64`. Tells the linker to link in `elf_x86_64` mode. (Can be removed. It does this by default.)
- `-s` Strip all symbol and relocation information from the output, effectively making the executable smaller (by removing debug information).
- `-o` specifies the output name, `reading` here.
- `reading.o` is a positional parameter which is the input for the linker.

## 3. Interesting Tests:

    1. Try to input a text that needs more than 15 bytes to be stored. (In this example, numbers are stored as characters so effectively it means a number with 6 or more characters)
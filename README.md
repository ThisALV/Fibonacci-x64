# Fibonacci suite for x64 using Microsoft C Runtime Library

## Usage

Just start precompiled `fibonacci.exe` from CMD. Program will asks for N limit.

## Install (Build)

Requires Microsoft SDK, Nasm and Git.

### Clone repository

Type command :

```
git clone https://github.com/ThisALV/Fibonacci-x64
```

### Build executable

Go to "x64 Native Tools Command Prompt for VS *(Your SDK version)*", change directory to cloned repo, then type commands :

```
nasm -f win64 -o fibonacci.obj fibonacci.asm
link fibonacci.obj /Fe:fibonacci.exe msvcrt.lib legacy_stdio_definitions.lib
```

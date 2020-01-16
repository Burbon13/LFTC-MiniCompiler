# Mini-Compiler

ASM 8086 compiler for self defined programming language (see language specifications below).

## Requirements

- Windows 32/64 bit.
- gcc compiler

## How to use

- Write the desired input program inside `in.in` file.
- Run `run.bat` to compile the program.
- The compiled program (ASM) will be placed in the `out.out` file.

## Language specifications

### Structure

```
begin_program
{DATA SEGMENT}
begin_block
	{CODE SEGMENT}
end_block
end_program
```

**{DATA SEGMENT}** will be replaced with variable declarations

**{CODE SEGMENT}** will be replaced with mathematical expressions or I/O operations.

### Variable declarations

Only int variables, 32 bit size. They must be declared in the data segment. The initial value will be 0.

```c
int a;
int b;
```

### Mathematical expressions

They support only one binary operator.
```c
a = 3 + 2;
a = 3 - 2;
b = a * 3;
c = b / 4;
```
Please note that the variables used (a, b, c) need to be declared in the data segment.

### I/O operations

```c
read(a);
write(b);
```
Variables used with read and write (a , b) need to be declared in the data segment.

### Sample program
The program reads three integers from the console, calculates their sum and prints the result on the console.
```c
begin_program
int a;
int b;
int c;
begin_block
	read(a);
	read(b);
	read(c);
    c = c + a;
    c = c + b;
    write(c);
end_block
end_program
```

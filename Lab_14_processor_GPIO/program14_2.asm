movi 4, 01
movi 1, E7
addi 1, 1, 01
jnz 1, 02
movi 4, 02
andi 0, 5, 01
jz 0, 0A
andi 0, 5, 01
jnz 0, 07
jumpi 0C
andi 0, 5, 01
jz 0, 0A
movi 4, 04
movi 1, E7
addi 1, 1, 01
jnz 1, 0E
movi 4, 08
andi 0, 5, 02
jz 0, 16
andi 0, 5, 02
jnz 0, 13
jumpi 18
andi 0, 5, 02
jz 0, 16
jumpi 00
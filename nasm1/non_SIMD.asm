
section .data
A dq 0
B dq 0
sdot dq 0
section .text
bits 64
default rel

global main
main:
    XOR RSI, RSI    ;initialize RSI (which will be used to index the arrays) to 0
    XOR R14, R14    ;initialize R14 (which is the dot product accumulator) to 0
    MOV R15, count   
    MOV [A], RCX    ;save array pointer of 1st array in A
    MOV [B], RDX    ;save array pointer of 2nd array in B
    
    MOV RAX, [A]
    MOV RBX, [B]
    
DOTPRODUCT:
    MOV R12, [RAX + 8*RSI]
    MOV R13, [RBX + 8*RSI]
    
    IMUL R12, R13
    
    ADD R14, R12
    INC RSI
    DEC R15
    JNZ DOTPRODUCT
    
    MOV [sdot], R14
    MOV R8, [sdot]
    
    xor rax, rax
    ret

section .data
sdot dq 0
section .text
bits 64
default rel
global nonavx
nonavx:
 
    ;for getting dot product
    XOR RSI, RSI
    XOR R14, R14
    MOV R15, [count]
    
DOTPRODUCT:
    MOV RBX, RSI
    IMUL RBX, 8
    MOV RAX, [A]
    ADD RAX, RBX
    MOV R12, [RAX]
    MOV RBX, RSI
    IMUL RBX, 8
    MOV RAX, [B]
    ADD RAX, RBX
    MOV R13, [RAX]
    
    IMUL R12, R13
    
    ADD R14, R12
    INC RSI
    DEC R15
    JNZ DOTPRODUCT
    
    MOV [sdot], R14
    
    xor rax, rax
    ret
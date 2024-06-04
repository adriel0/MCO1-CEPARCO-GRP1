
section .data
sdot dq 0
section .text
bits 64
default rel

global main
main:
 
    ;for getting dot product
    XOR RSI, RSI
    XOR R14, R14
    MOV R15, count
    
DOTPRODUCT:
    MOV R12, [A + 8*RSI]
    MOV R13, [B + 8*RSI]
    
    IMUL R12, R13
    
    ADD R14, R12
    INC RSI
    DEC R15
    JNZ DOTPRODUCT
    
    MOV [sdot], R14
    MOV R8, [sdot]
    
    xor rax, rax
    ret
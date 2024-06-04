section .data
A dq 0
B dq 0
sdot dq 0
message db "Dot product = %lld", 13,10,0
section .text
bits 64
default rel
extern printf
global nonavx
nonavx:
 
    ;for getting dot product
    XOR RSI, RSI
    XOR R14, R14
    MOV R15, RCX
    MOV [A], RDX
    MOV [B], R8
    
DOTPRODUCT:
    MOV RAX, [A]
    MOV R12, [RAX + 8*RSI]

    SUB RSP, 8*5
    LEA RCX, [message]
    MOV RDX, R12
    CALL printf
    ADD RSP, 8*5


    MOV RAX, [B]
    MOV R13, [RAX + 8*RSI]
    
    IMUL R12, R13
    
    ADD R14, R12
    INC RSI
    DEC R15
    JNZ DOTPRODUCT
    
    MOV [sdot], R14
    MOV RAX, [sdot]
    ret
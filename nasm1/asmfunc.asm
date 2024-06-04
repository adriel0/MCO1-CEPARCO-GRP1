section .data
A dq 0
B dq 0
sdot dq 0
message db "dereferenced = %lld", 13,10,0
section .text
bits 64
default rel
extern printf
global nonavx
global xmm
global ymm
nonavx:
 
    ;for getting dot product
    XOR RSI, RSI
    XOR R14, R14
    MOV R15, RCX
    MOV [A], RDX
    MOV [B], R8
    

    
DOTPRODUCT1:
    MOV RAX, [A]
    MOV R12, [RAX + 8*RSI]

    MOV RAX, [B]
    MOV R13, [RAX + 8*RSI]


    IMUL R12, R13
    
    ADD R14, R12
    INC RSI
    DEC R15
    JNZ DOTPRODUCT1
    
    MOV [sdot], R14
    MOV RAX, [sdot]
    ret


    xmm:
 
    ;for getting dot product
    XOR RSI, RSI
    XOR R14, R14
    XORPS XMM4,XMM4
    MOV R15, RCX
    MOV [A], RDX
    MOV [B], R8
    INC R15
    SHR R15, 1

DOTPRODUCT2:

    MOV RAX, [A]
    MOVDQA XMM1, [RAX + 8*RSI]
    MOV RAX, [B]
    MOVDQA XMM2, [RAX + 8*RSI]

    PMULLD XMM1, XMM2


    XORPS xmm3,xmm3
    pshufd xmm3, xmm1, 0b01_00_11_10

    

    VPADDQ xmm1,xmm3
    VPADDQ xmm4,xmm1


    INC RSI
    INC RSI
    DEC R15
    JNZ DOTPRODUCT2
    
    MOVDQA [sdot], xmm4
    ;MOVSD [sdot], xmm4
    MOV RAX, [sdot]
    ret



ymm:
 
    ;for getting dot product
    XOR RSI, RSI
    XOR R14, R14
    MOV R15, RCX
    MOV [A], RDX
    MOV [B], R8
    

    
DOTPRODUCT3:
    MOV RAX, [A]
    MOV R12, [RAX + 8*RSI]

    MOV RAX, [B]
    MOV R13, [RAX + 8*RSI]
    
    IMUL R12, R13
    
    ADD R14, R12
    INC RSI
    DEC R15
    JNZ DOTPRODUCT3
    
    MOV [sdot], R14
    MOV RAX, [sdot]
    ret
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
    PUSH RSI
    PUSH R14
    PUSH R15
    PUSH RCX
    PUSH RDX
    PUSH R8
    PUSH R12
    PUSH R13
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


    
    
    POP R13
    POP R12
    POP R8
    POP RDX
    POP RCX
    POP R15
    POP R14
    POP RSI
    ret


    xmm:
 
    ;for getting dot product
    
    PUSH RSI
    PUSH R14
    PUSH R15
    PUSH RCX
    PUSH RDX
    PUSH R8
    PUSH R12
    PUSH R13
    XOR RSI, RSI
    XOR R14, R14
    MOV R15, RCX
    MOV [A], RDX
    MOV [B], R8
    MOV R14, R15
    AND R14, 1
    SHR R15, 1
    XORPS XMM4,XMM4

DOTPRODUCT2:

    MOV RAX, [A]
    MOVDQU XMM1, [RAX + 8*RSI]
    MOV RAX, [B]
    MOVDQU XMM2, [RAX + 8*RSI]

    VPMULUDQ  XMM1, XMM1, XMM2


    
    VPADDQ xmm4,xmm1


    INC RSI
    INC RSI
    DEC R15
    JNZ DOTPRODUCT2
    XORPS xmm3,xmm3
    pshufd xmm3, xmm4, 0b01_00_11_10

    

    VPADDQ xmm4,xmm3

    DEC R14
    JNZ Done
    MOV RAX, [A]
    MOVDQU XMM1, [RAX + 8*RSI]
    MOV RAX, [B]
    MOVDQU XMM2, [RAX + 8*RSI]

    VPMULUDQ  XMM1, XMM1, XMM2
    VPADDQ xmm4,xmm1


Done:
    MOVDQU [sdot], xmm4
    ;MOVSD [sdot], xmm4
    MOV RAX, [sdot]
    POP R13
    POP R12
    POP R8
    POP RDX
    POP RCX
    POP R15
    POP R14
    POP RSI
    ret



ymm:
 
    ;for getting dot 
    
    PUSH RSI
    PUSH R14
    PUSH R15
    PUSH RCX
    PUSH RDX
    PUSH R8
    PUSH R12
    PUSH R13
    PUSH RBX
    XOR RSI, RSI
    XOR R14, R14
    MOV R15, RCX
    MOV [A], RDX
    MOV [B], R8
    MOV R14, R15
    AND R14, 3
    SHR R15, 2
    

    
    VXORPS YMM4,YMM4
DOTPRODUCT3:
    MOV RBX, RSI
    IMUL RBX, 8
    MOV RAX, [A]
    ADD RAX, RBX 
    vmovdqu YMM1, [RAX]
    MOV RBX, RSI
    IMUL RBX, 8
    MOV RAX, [B]
    ADD RAX, RBX
    vmovdqu YMM2, [RAX]

    VPMULUDQ  YMM1,YMM1, YMM2

    VPADDQ YMM4,YMM1
    
    
    ADD RSI,4
    DEC R15
    JNZ DOTPRODUCT3

    VXORPS YMM3, YMM3,YMM3
    VPSHUFD YMM3, YMM4, 0b01_00_11_10
    VPADDQ YMM4,YMM3
    VEXTRACTF128 xmm11, ymm4, 0
    VEXTRACTF128 xmm12, ymm4, 1 
    PADDQ XMM11, XMM12
     
     
    vmovdqu XMM4,XMM11

    MOV R15, R14
    SHR R15, 1
    DEC R15
    JNZ LAST
    MOV RBX, RSI
    IMUL RBX, 8
    MOV RAX, [A]
    ADD RAX, RBX
    MOVDQU XMM1, [RAX]
    MOV RBX, RSI
    IMUL RBX, 8
    MOV RAX, [B]
    ADD RAX, RBX
    MOVDQU XMM2, [RAX]

    VPMULUDQ  XMM1, XMM1, XMM2


    XORPS xmm3,xmm3
    pshufd xmm3, xmm1, 0b01_00_11_10

    

    VPADDQ xmm1,xmm3
    VPADDQ xmm4,xmm1


    INC RSI
    INC RSI


LAST:
    AND R14, 1
    DEC R14
    JNZ END
    MOV RBX, RSI
    IMUL RBX, 8
    MOV RAX, [A]
    ADD RAX, RBX
    MOVDQU XMM1, [RAX]
    MOV RBX, RSI
    IMUL RBX, 8
    MOV RAX, [B]
    ADD RAX, RBX
    MOVDQU XMM2, [RAX]

    VPMULUDQ  XMM1, XMM1, XMM2
    VPADDQ xmm4,xmm1

END:
    VMOVDQU [sdot], xmm4
    ;MOVSD [sdot], xmm4
    MOV RAX, [sdot]
    POP RBX
    POP R13
    POP R12
    POP R8
    POP RDX
    POP RCX
    POP R15
    POP R14
    POP RSI
    ret
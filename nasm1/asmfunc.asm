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
    MOV R14, R15
    AND R14, 1
    SHR R15, 1

DOTPRODUCT2:

    MOV RAX, [A]
    MOVDQU XMM1, [RAX + 8*RSI]
    MOV RAX, [B]
    MOVDQU XMM2, [RAX + 8*RSI]

    PMULLD XMM1, XMM2


    XORPS xmm3,xmm3
    pshufd xmm3, xmm1, 0b01_00_11_10

    

    VPADDQ xmm1,xmm3
    VPADDQ xmm4,xmm1


    INC RSI
    INC RSI
    DEC R15
    JNZ DOTPRODUCT2
    

    DEC R14
    JNZ Done
    MOV RAX, [A]
    MOVDQU XMM1, [RAX + 8*RSI]
    MOV RAX, [B]
    MOVDQU XMM2, [RAX + 8*RSI]

    PMULLD XMM1, XMM2
    VPADDQ xmm4,xmm1


Done:
    MOVDQU [sdot], xmm4
    ;MOVSD [sdot], xmm4
    MOV RAX, [sdot]
    ret



ymm:
 
    ;for getting dot 
    XOR RSI, RSI
    XOR R14, R14
    XORPS XMM4,XMM4
    MOV R15, RCX
    MOV [A], RDX
    MOV [B], R8
    MOV R14, R15
    AND R14, 3
    SHR R15, 2
    

    
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

    VPMULLD YMM1,YMM1, YMM2


    VXORPS YMM3, YMM3,YMM3
    VPSHUFD YMM3, YMM1, 0b01_00_11_10
    VPADDQ YMM1,YMM3
    VEXTRACTF128 xmm11, ymm1, 0
    VEXTRACTF128 xmm12, ymm1, 1 
    PADDQ XMM11, XMM12
     
     
    PADDQ XMM4,XMM11
    
    
    ADD RSI,4
    DEC R15
    JNZ DOTPRODUCT3



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

    PMULLD XMM1, XMM2


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

    PMULLD XMM1, XMM2
    VPADDQ xmm4,xmm1

END:
    VMOVDQU [sdot], xmm4
    ;MOVSD [sdot], xmm4
    MOV RAX, [sdot]
    ret
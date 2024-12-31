    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

base:    
    .byte 0xFF,0x03,0x3A,0xAA,0xF2
    .align
    .section .text
    .global reset
reset:
        LDR R0,=base
        ADD R0,R0,#1 //Para cargar en R0=base+1
        LDRB R1,[R0],#1 //Cargo la longitud del bloque en R1

        LDRB R2,[R0],#1 //Cargo el primer elemento ||Actualmente el mayor elemento
        MOV R3,#0
lazo:   //Pregunta del lazo
        CMP R1,#0x00
        BLS finLAZO
        //-----
        CMP R3,R2 //R3 mayor o igual que R2
        IT GE
        MOVGE R2,R3 //Reemplazo el mayor

        LDRB R3,[R0],#1 //Cargo el sgte numero
        SUB R1,#1
        B lazo

finLAZO:
        LDR R0,=base
        STRB R2,[R0] 


final: b final
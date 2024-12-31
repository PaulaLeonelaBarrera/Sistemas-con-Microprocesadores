            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

base:       .byte 0xA1, 0x07, 0xBB, 0x7C //le tengo que agregar 0x00 para base+4 como buena práctica
            .space 1

            .section .text
            .global reset

reset:      MOV R0, #4
            MOV R3, #4
     
            LDR R1, =base

lazo:       
            CMP R3, #0
            BEQ final
            LDRB R2, [R1], #1 //Cargo en R2 lo contenido en R1 Y hago R1=R1+1 (postindexado)
            ADDS R4, R4, R2 //R4=R4+R2 Acumulo la suma
            AND R4, R4, #0xFF    // Enmascarar para considerar solo los 8 bits menos
            SUB R3, #1
            B lazo

final:      STRB R4, [R1] //guardo en base+4

stop:       B stop
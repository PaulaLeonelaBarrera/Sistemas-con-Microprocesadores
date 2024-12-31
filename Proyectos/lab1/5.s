            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

base:      
            .byte 0x00, 0x03, 0x3A, 0xAA, 0xF2 

            .section .text
            .global reset

reset:      LDR R0, =base       //apunta a base //puedo hacer R2-4 para no usar 2 punteros
            LDRB R1, [R0, #1]   //carga 0x03 en R1. LONGUITUD DEL BLOQUE
            LDR R2, =base       //apunta a base
            LDRB R3, [R2, #2]!  //cargo en R3 el primer elemento y muevo el puntero.//Preindexado
            MOV R4, #1          //contador de elementos del vector

lazo:       CMP R1, R4
            BEQ final
            LDRB R5, [R2, #1]!
            CMP R5,R3 //R5 mayor o igual que R3
            IT GE
            MOVGE R3,R5 //Reemplazo el mayor
            ADD R4, #1
            B lazo

final:      STR R3, [R2, #-4]  //  La instrucción STRB R3, [R0] simplemente almacena 
                          //  el valor de 8 bits de R3 en la dirección de memoria apuntada por R0
                          // R0 no cambia su valor para igualarse a R3
stop:       B stop
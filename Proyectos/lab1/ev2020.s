// Escriba un programa en lenguaje ensamblador para el ARM Cortex-M4 que procesa un vector
//de bytes ubicado a partir de la dirección base, lee todos los elementos del vector hasta
//encontrar el valor cero y en ese momento finalice devolviendo el resultado.  
    //a) El programa debe almacenar en la dirección resultado la cantidad de números pares y en
    //la dirección resultado+1 la cantidad de números impares que contiene el vector.

    //b) Modifique el programa anterior para que además almacene en la dirección resultado+2
    //la cantidad de números positivos y en la dirección resultado+3 la cantidad de números
    //negativos que contiene el vector.
            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

base:       .byte 0x2, 0x16, 0x7, 0xA1, 0xFF, 0x00

resultado:  .space 4, 0x00

            .section .text
            .global reset

reset:      LDR R0, =base
            LDR R1, =resultado
            MOV R3, #0          //registro de IMPAR
            MOV R4, #0          //registro PAR
            MOV R5, #0          //registro NEGATIVOS
            MOV R6, #0          //registro POSITIVOS

lazo:       LDRB R2, [R0], #1   //R2=R0 y R0=R0+1
            CMP R2, #0
            BEQ final
            LSRS R2, #1         //muevo para ver si el carry es 0 o 1
            ITE HS
            ADDHS R3, #1        //R3 + 1 porq el numero es impar
            ADDLO R4, #1        //R4 + 1 porq el numero es par
            LSRS R2, #7
            ITE HS 
            ADDHS R5, #1        //R5 + 1 porq el numero es negativo
            ADDLO R6, #1        //R6 + 1 porq el numero es positivo
            B lazo

final:      STRB R4, [R1]       //guardo los pares en resultado
            STRB R3, [R1, #1]   //los impares en resultado+1
            STRB R5, [R1, #3]   //negativos en resultado+3
            STRB R6, [R1, #2]   //positivos en resultado+2

stop:       B stop
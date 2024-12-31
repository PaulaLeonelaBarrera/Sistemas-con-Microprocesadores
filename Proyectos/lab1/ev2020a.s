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

resultado: .space 4
base:
        .byte 0x01,0x20,0x06,0xF0,0x00
        .align
        .section .text
        .global reset

reset:
        LDR R0,=base
        MOV R5,#0 //CAntidad pares
        MOV R6,#0 //CAntidad impares
        MOV R7,#0 //Cantidad positivos
        MOV R8,#0 //CAntidad negativos
        LDRB R1,[R0],#1
lazo: 
        //while
        CMP R1, 0x00
        BEQ Finlazo
        //---

        //Pregunta paridad
        TST  R1,0x01
        ITE EQ
        ADDEQ R5,#1
        ADDNE R6,#1

        TST R1, 0x80
        //PreguntaSigno
        ITE EQ
        ADDEQ R7,#1
        ADDNE R8,#1

        LDRB R1,[R0],#1
        B lazo
Finlazo:
        LDR R0,=resultado
        STRB R5,[R0],#1
        STRB R6,[R0],#1
        STRB R7,[R0],#1
        STRB R8,[R0]


stop: B stop
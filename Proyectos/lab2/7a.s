/*7) [Profundización] Escriba una subrutina que invierta una cadena de caracteres ASCII se encuentra 
almacenada en memoria. Esta subrutina recibe el puntero al inicio de la cadena en R0
y un puntero al final en R1.
a) Diseñe una subrutina cambiar que invierta el primer y el último caracter de la cadena. Esta
subrutina recibe el puntero al primer elemento en R0 y al último en R1.
b) Diseñe ahora una subrutina recursiva invertir que utiliza la rutina anterior para intercambiar 
los elementos del extremo de la cadena y a si misma para invertir el resto. */
                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data


cadena:         .asciz "paula"


                .section .text
                .global reset

reset:          LDR R0,=cadena          //Paso por referencia en registros
                LDR R1,=cadena          //Paso por referencia en registros
                BL puntero              //Subrutina para posicionar el puntero al final de la cadena
                //o poner directamente ADD R1,R0,#4 ????
                BL cambiar  //Subrutina que invierte el primer y el último caracter de la cadena,
                            //recibe por referencia en registros R0 y R1.

stop: B stop

puntero:        LDRB R2,[R1],#1         //Guardo un caracter en R2 y R1=R1+1
                CMP R2,0X00             //Comparo con 0x00 para saber si es el final del string
                ITT EQ                  //Si llega al final
                SUBEQ R1,#2             //Muevo R1 hacia el último caracter
                BXEQ LR                 
                B puntero

cambiar:        LDRB R2,[R0]            //Guarda en R2 el caracter al que apunta R0
                LDRB R3,[R1]            //Guarda en R3 el caracter al que apunta R1
                STRB R2,[R1]            //Guarda en M(R1) el caracter al que apuntaba R0
                STRB R3,[R0]            //Guarda en M(R0) el char al que apuntaba R1
                BX LR




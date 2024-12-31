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
                .func main

reset:          LDR R0,=cadena          //Paso por referencia en registros
                ADD R1,R0,#4            //Posicionar el puntero al final de la cadena
                BL invertir             //Subrutina para invertir la cadena

stop:   B stop
        .pool
        .endfunc

    .func cambiar
cambiar:        LDRB R2,[R0]            //Guarda en R2 el caracter al que apunta R0
                LDRB R3,[R1]            //Guarda en R3 el caracter al que apunta R1
                STRB R2,[R1]            //Guarda en M(R1) el caracter al que apuntaba R0
                STRB R3,[R0]            //Guarda en M(R0) el char al que apuntaba R1
                BX LR
                .endfunc

    .func invertir
invertir:       PUSH {LR}               //Almaceno la dirección de retorno
                BL cambiar              //Llama a la subrutina para intercambiar caract
                ADD R0,#1               //Mueve el puntero R0 un lugar (hacia la der)
                ADD R1,#-1              //Mueve el puntero R1 un lugar (hacia la izq)
                CMP R0,R1               
                IT EQ                   //Si R0 y R1 apuntan a la misma dirección
                POPEQ {PC}              //Vuelvo a la rutina principal                
                POP {LR}                //Recupero el valor que tenía LR al hacer 'BL invertir' en la rutina principal
                B invertir              //Llamada recursiva
                .endfunc



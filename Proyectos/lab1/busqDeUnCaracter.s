            .cpu cortex-m4
            .syntax unified
            .thumb

            .section .data 
cadena:     .asciz "SISTEMAS CON MICROPROCESADORES"
caracter:   .ascii "S"

            .section .text 
            .global reset 
reset:      MOV R0,#0x00 // Resultado es cero ocurrencias 
            LDR R1,=caracter // Apunta al carácter 
            LDRB R1,[R1] // Carga el carácter a buscar 
            LDR R2,=cadena // Apunta a la cadena 
lazo:       LDRB R3,[R2],#1 // Carga el carácter actual 
            CMP R3,R1 // Compara los caracteres 
            IT EQ // Si los registros son iguales 
            ADDEQ R0,#1 // Entonces incrementa resultado 
            CMP R3,#0x00 // Si el carácter no es igual a 0 
            BNE lazo // Entonces repite el lazo 
stop: B stop
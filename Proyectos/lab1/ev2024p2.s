        .cpu cortex-m4
        .syntax unified
        .thumb
        .section .data

base:       .byte 0x12,0x1,0x7
            .space 6, 0x00

            .section .text
            .global reset

reset:      LDR R0, =base       //Cargar la dirección base
            LDRB R1, [R0]       // Cargar el primer número (BCD compactado) en R1
            LDRB R2, [R0, #1]   // Cargar el segundo número (BCD no compactado) en R2//1
            LDRB R4, [R0, #2]   // Cargar el segundo número (BCD no compactado) en R2//7

            //Convertir el segundo número a BCD compactado
            MOV R3, R2          // Copiar el segundo número a R3
            AND R3, R3, #0x0F   // Obtener los 4 bits menos significativos
            MOV R5, R4          // Copiar el segundo número a R3
            AND R5, R4, #0x0F   // Obtener los 4 bits menos significativos

            BFI R5, R3, #4, #4

            //ORR R3, R3, R2, LSL #4 //Compactar el BCD
            STRB R5, [R0, #4]   // Guardar el resultado en base + 4

            ADDS R6, R5, R1
            STRB R6, [R0, #6]   // Guardar el resultado en base + 6
//c)
            MOVS R5, R6         //Copiar el resultado de la suma a R5

            //Separar los dígitos BCD
            ANDS R6, R5, #0x0F  //Obtener los 4 bits menos significativos (dígito menos significativo)
            LSRS R5, R5, #4     //Desplazar los 4 bits más significativos a la posición de los menos significativos
            ANDS R5, R5, #0x0F  //Obtener los 4 bits más significativos (dígito más significativo)

            //Convertir a binario
            MOVS R7, #10        //Cargar el valor 10 en R7
            MULS R5, R5, R7     // Multiplicar el dígito más significativo por 10
            ADDS R5, R5, R6     //Sumar el dígito menos significativo

            //Guardar el resultado en base + 8
            STRB R5, [R0, #8]   //Guardar el resultado en base + 8


stop: B stop
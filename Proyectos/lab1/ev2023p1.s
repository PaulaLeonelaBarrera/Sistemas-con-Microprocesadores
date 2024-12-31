        .cpu cortex-m4
        .syntax unified
        .thumb
        .section .data
base:       .byte 0x00, 0x00, 0x04, 0x8A, 0xFA, 0xEF, 0x12  // Ejemplo de datos

            .section .text
            .global reset


reset:      LDR R0, =base        // Cargar la dirección base en R0
            LDR R4, =base        // Cargar la dirección base en R4 para usarla para guardar resultado
            LDRB R1, [R0, #2]     // Cargar la longitud del bloque desde base+2
            ADD R0, R0, #3       // Apuntar al inicio del bloque de datos (base+3)
            MOV R2, #0           // Inicializar el acumulador de la suma en 0


lazo:       LDRB R3, [R0], #1    // Cargar el byte actual y avanzar al siguiente
            ADD R2, R2, R3       // Sumar el byte al acumulador
            SUBS R1, R1, #1      // Decrementar el contador de elementos
            BNE lazo         // Repetir hasta que R1 sea 0

final:      //MOV R5,R2 //recupero el valor de R2 en un registro auxiliar (R5)
            //AND R5, 0xFF //me queda 0x85
            //STRB R5, [R4], #1   // Almacenar 0x85 en base y muevo 1 el puntero //STRH para guardar un numeros de 16
            // Separar los 8 bits altos
            //LSR R2, #8  // Desplazar a la derecha 8 bits, me queda 0x2
            //STRB R2, [R4]   // Almacenar 0x02 en base+1
            //STRH para guardar un numeros de 16 y me ahorro lo anterior
            STRH R2, [R4]
stop: B stop


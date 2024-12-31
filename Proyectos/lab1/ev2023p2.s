            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

//origen:     .byte 0xF5

destino:    .space 1, 0x00

            .section .text
            .global reset

reset:          //LDR R0, =origen
                LDR R1, =destino
                LDR R2, =tabla
                MOV  R0,#0xF5           // Guarda en R0 el numero a convertir //SIN USAR MEMORIA
                MOV R3, R0

                // Extraer la parte baja del número BCD compactado
                AND R4, R3, #0x0F        // R4 = parte baja (0xF5 & 0x0F = 0x5)
                LDRB R5, [R2, R4]        // Obtener el valor de la tabla para la parte baja
                STRB R5, [R1]            // Almacenar el valor en destino

                // Extraer la parte alta del número BCD compactado
                LSR R4, R3, #4           // R4 = parte alta (0xF5 >> 4 = 0xF)
                LDRB R5, [R2, R4]        // Obtener el valor de la tabla para la parte alta
                STRB R5, [R1, #1]        // Almacenar el valor en destino+1

stop:       B stop

            .pool
tabla:      .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F  // 0-9
            .byte 0x77, 0x7F, 0x39, 0x3F, 0x79, 0x71 // A-F
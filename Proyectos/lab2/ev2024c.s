/*1) 90 Minutos - 100 Puntos (15, 35, 35, 15)
Se desea implementar una versión simplificada de un reloj. La dirección de memoria inicial
donde se encuentra almacenada la fecha y hora actual esta en R0, con la siguiente estructura:
M[R0] = segundo
M[R0 +1] = minuto
M[R0 +2] = hora
M[R0 +3] = día
M[R0 +4] = mes
M[R0 +5] = anio
Para ello se solicita:
a) Escriba una subrutina transparente que genere una demora constante con un lazo de
50.000 iteraciones. Esta demora se estimará en una centesima de segundo.
b) Escriba una subrutina transparente llamada hora que recibe en el registro R0 la dirección
inicial de la estructura de datos. Esta rutina sera llamada una vez por segundo y debe
realizar todos los controles para llevar correctamente la hora del reloj. Cuando se alcance
el final del día (23:59:59) deberá escribir en R1 el valor de 1, sino deberá estar en 0.
c) Escriba una subrutina transparente llamada fecha que recibirá como parámetro R0 la dirección inicial de la estructura de datos y en R1 un valor indicativo de cambio de día, cuando se
alcanzo en final del día y corresponde un cambio de fecha. La misma deberá realizar todos
los controles para llevar correctamente la fecha y poner R1 en 0 nuevamente al finalizar.
d) Construya el programa principal con el reloj planteado usando las tres subrutinas previas. */
            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

dato:       .byte 0x55, 0x32, 0x15, 0x17, 0x09, 0x18

            .section .text
            .global reset

reset:      LDR R0, =dato
            BL fecha

stop: B stop

fecha:  CMP R1, #1                // Compara R1 con 1
        BNE fin_fecha             // Si no es 1, salta al final
        LDRB R2, [R0, #3]         // Carga el día en R2
        ADDS R2, R2, #1           // Incrementa el día
        CMP R2, #31               // Compara con 31 (simplificación, no considera meses con menos días)
        BNE no_mes_incremento    // Si no es 31, no incrementa el mes
        MOV R2, #1                // Resetea el día
        STRB R2, [R0, #3]         // Guarda el día
        LDRB R2, [R0, #4]         // Carga el mes en R2
        ADDS R2, R2, #1           // Incrementa el mes
        CMP R2, #13               // Compara con 13
        BNE no_anio_incremento     // Si no es 13, no incrementa el año
        MOV R2, #1                // Resetea el mes
        STRB R2, [R0, #4]         // Guarda el mes
        LDRB R2, [R0, #5]         // Carga el año en R2
        ADDS R2, R2, #1           // Incrementa el año
        STRB R2, [R0, #5]         // Guarda el año
        B fin_fecha               // Salta al final

no_anio_incremento:     STRB R2, [R0, #4]         // Guarda el mes
                        B fin_fecha               // Salta al final
no_mes_incremento: STRB R2, [R0, #3]         // Guarda el día

fin_fecha:  MOV R1, #0                // Resetea R1
            POP {R0, R1, R2, R3, LR}  // Restaura los registros
            BX LR                     // Retorna de la subrutina
 
//no me esta incrementando


                

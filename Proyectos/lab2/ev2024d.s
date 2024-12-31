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
            BL demora
            BL hora
            BL fecha

stop: B stop

//a
demora:     PUSH {R4, LR}        // Guarda los registros R4 y el enlace de retorno en la pila
            LDR R4, =50000           // Carga el valor 50,000 en R0
            B demora_lazo
            POP {R4, LR}         // Restaura los registros R0, R1 y el enlace de retorno
            BX LR                    // Retorna de la subrutina

demora_lazo:    SUBS R4, R4, #1          // Resta 1 a R0
                CMP R4, #0
                IT  NE
                BNE demora_lazo         // Si R0 no es cero, repite el bucle

//----

//b
hora:  PUSH {R4, R5, R6}
       LDRB R4, [R0], #1 //cargo segundo
       LDRB R5, [R0], #1 //cargo min
       LDRB R6, [R0], #1 //cargo hora

        ADDS R4, R4, #1          // Incrementa los segundos
        CMP R4, #60              // Compara con 60
        BNE no_minuto_incremento  // Si no es 60, no incrementa los minutos
        MOV R4, #0               // Resetea los segundos
        STRB R4, [R0]            // Guarda los segundos
        ADDS R5, R5, #1          // Incrementa los minutos
        CMP R5, #60              // Compara con 60
        BNE no_hora_incremento    // Si no es 60, no incrementa las horas
        MOV R5, #0               // Resetea los minutos
        STRB R5, [R0, #1]        // Guarda los minutos
        ADDS R6, R6, #1          // Incrementa las horas
        CMP R6, #24              // Compara con 24
        BNE no_dia_incremento     // Si no es 24, no incrementa el día
        MOV R6, #0               // Resetea las horas
        STRB R6, [R0, #2]        // Guarda las horas
        MOV R1, #1               // Indica cambio de día
        B fin_hora               // Salta al final

no_dia_incremento:  STRB R6, [R0, #2]        // Guarda las horas
                    MOV R1, #0               // No hay cambio de día
                    B fin_hora               // Salta al final

no_hora_incremento:     STRB R5, [R0, #1]        // Guarda los minutos
                        MOV R1, #0               // No hay cambio de día
                        B fin_hora               // Salta al final

no_minuto_incremento:    STRB R4, [R0]            // Guarda los segundos
                        MOV R1, #0               // No hay cambio de día
  
fin_hora:       POP {R4, R5, R6}     // Restaura los registros
                BX LR                    // Retorna de la subrutina
//------
//c
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
 



                

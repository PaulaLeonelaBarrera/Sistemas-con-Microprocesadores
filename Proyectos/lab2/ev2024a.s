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

dato:       .space 6, 0x00

            .section .text
            .global reset

reset:      LDR R0, =dato
            BL demora

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

                

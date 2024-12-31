/*6) [Profundización] Escriba la subrutina que ejecute el gestor de eventos correspondiente a las
teclas del reloj. Ésta debe identificar la subrutina correspondiente a la tecla presionada (gestor
del evento) y saltar a la misma. Para ello emplea el código de la tecla presionada almacenado
en el registro R0 como un índice en una tabla de saltos que comienza en el lugar base. Cada
entrada en la tabla de saltos contiene la dirección de la primera instrucción de la subrutina
correspondiente (punto de entrada). El programa debe transferir control a la dirección que
corresponde al índice. Por ejemplo, si el índice fuera 2, el programa saltaría a la dirección que
está almacenada en la entrada 2 de la tabla. Como es lógico cada entrada tiene 4 bytes. Por
ejemplo:
R0=2         Datos                      Resultado
        (base) = 0x1A00.1D05         (PC) = 0x1A00.5FC4
        (base + 4) = 0x1A00.2321
        (base + 8) = 0x01A0.5FC4
        (base + 12) = 0x01A0.7C3A 
*/
                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

base:           .word  0x1A001D05, 0x1A002321, 0x01A05FC4, 0x01A07C3A

                .section .text
                .global reset

reset:          MOV R0,#2
                LDR R1,=base
                BL salto
                POP {PC} //?

stop:           B stop

salto:          MOV R3,#4
                MUL R2,R0,R3
                ADD R2,R1
                LDR R3,[R2]
                PUSH {R3} //?
                BX LR
/*) Se desea mostrar el valor de un número almacenado en memoria en su representación decimal 
en los displays de 7 segmentos.
a) Escriba una subrutina transparente que reciba la dirección del numero de 1 byte en R0.
El mapa de bits de 7 segmentos de centena, decena y unidad del número convertido deberán 
almacenarse en las direcciones de memoria consecutivas a R0, respectivamente.
En el siguiente ejemplo convertirmos el número 215 en su mapa de bits de 7 segmentos:
Pre condiciones:     M[R0]=0xD7 (215(10))
Resultado:   M[R0+1]=0x5B (2(10))    M[R0+2]=0x06 (1(10))  M[R0+3]=0x6D (5(10))
b) Escriba un programa principal que llame a la subrutina del apartado anterior para verificar
su funcionamiento.
c) Modifique el programa principal del apartado anterior para mostrar, en los displays 7 segmentos, los dígitos 
de la centenas, decenas y unidades, en el ejemplo: 2 1 5.
Para poder lograr esto, deberá encender un display por vez, esperando el tiempo necesario
antes de apagarlo y encender el siguiente.
Se proporcionan la subrutina demora que no requiere parámetros y la subrutina mostrar
que permite mostrar un dígito en uno de los displays siete segmentos del poncho correspondiente 
a la placa EDU-CIAA. Para ello, antes de llamar a la subrutina, debe almacenar
en R0 el mapa de bits de siete segmentos correspondiente al número que desea mostrar, y
en R1 debe almacenar el valor 0x08, 0x04, 0x02 o 0x01 según el display que desea utilizar 
*/
    .cpu cortex-m4 // Indica el procesador de destino
    .syntax unified // Habilita las instrucciones Thumb-2
    .thumb // Usar instrucciones Thumb y no ARM
    .section .data
    .equ tamanio,4

tabla:  .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67 // codigo 7 segmentos
numero: .byte 0x11 // Numero a mostrar por display
resul:  .space 20 // Espacio para resultado
        .align
        .section .text // Define la seccion de codigo (FLASH)
        .global reset // Define el punto de entrada del codigo
reset:

programa_principal: LDR R0, =numero // cargo puntero número a convertir
                    LDR R1, =tabla // cargo puntero tabla conversion
                    BL apartado_a // ejecutamos conversion a 7 segmentos


apartado_c: LDR R2, =numero // cargo puntero número original
            ADD R2, 0x01 // cargo puntero a primer numero a mostrar
            LDRB R0, [R2] // cargo numero a mostrar
            MOV R1, 0x04 // indico digito a prender
            BL mostrar
            BL demora
            LDR R2, =numero // cargo puntero número original
            ADD R2, 0x02 // cargo puntero a segundo numero a mostrar
            LDRB R0, [R2] // cargo numero a mostrar
            MOV R1, 0x02 // indico digito a prender
            BL mostrar
            BL demora
            LDR R2, =numero // cargo puntero número original
            ADD R2, 0x03 // cargo puntero a tercer numero a mostrar
            LDRB R0, [R2] // cargo numero a mostrar
            MOV R1, 0x01 // indico digito a prender
            BL mostrar
            BL demora
            B apartado_c

apartado_a: PUSH {R4, R5} // salvor registros para transparencia
            LDRB R4, [R0] // cargo número a convertir
            MOV R2, #100
            UDIV R5, R4, R2 // cargo centena en R5
            ADD R3, R1, R5 // cargo puntero resultado conversion
            LDRB R3, [R3] // cargo resultado conversion centena
            ADD R0, 0X01 // incremento puntero a resultado
            STRB R3, [R0] // guardo resultado conversion centena en R0+1
            MUL R5, R2
            SUB R4, R5 // elimino centena de numero a convertir
            MOV R2, #10
            UDIV R5, R4, R2 // cargo decena en R5
            ADD R3, R1, R5 // cargo puntero resultado conversion
            LDRB R3, [R3] // cargo resultado conversion centena
            ADD R0, 0X01 // incremento puntero a resultado
            STRB R3, [R0] // guardo resultado conversion centena en R0+1
            MUL R5, R2
            SUB R4, R5 // elimino decena de numero a convertir
            MOV R2, #1
            UDIV R5, R4, R2 // cargo unidad en R5
            ADD R3, R1, R5 // cargo puntero resultado conversion
            LDRB R3, [R3] // cargo resultado conversion centena
            ADD R0, 0X01 // incremento puntero a resultado
            STRB R3, [R0] // guardo resultado conversion centena en R0+1
            POP {R4,R5} // recupero registros salvados
            BX LR

stop:    B stop // Lazo infinito para terminar la ejecucion
        .align
        .pool

/**
* Inclusion de las funciones para configurar los teminales GPIO del procesador
*/
.include "ejemplos/funciones.s"
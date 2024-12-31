/*2) 50 minutos - 60 puntos
Realizar una subrutina transparente convertir que reciba en R0 la dirección de memoria del
inicio de la cadena de caracteres y en R1 las indicaciones de que realizar con esa cadena:
a) Si el parámetro recibido en R1 es 1, deberá convertir toda la cadena a mayúsculas.
b) Si el parámetro recibido en R1 es 2, deberá convertir toda la cadena a minúsculas.
c) Si el parámetro recibido en R1 es 3, deberá convertir el primer carácter a mayúscula y el
resto de la cadena a minúsculas.
Parámetros M[R0] = hOLA Mu-NDO R1 = 0x3
Resultado M[R0] = Hola mu-ndo
La subrutina debe controlar si los caracteres se encuentran entre a y z o entre A y Z.
Escribir programa principal para probar la subrutina. */
            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data
cadena:    .asciz "hOLA Mu-NDO"

            .section .text
            .global reset

reset:  LDR R0, =cadena //paso por referencia en registro
        MOV R1, #3
        MOV R2, R0
        BL convertir

stop:   B stop

mayus: //Convierte un caracter en minúscula a mayúscula

        //Controlo que el caracter se encuentra entre a y z 
        CMP R3, #97
        IT LO
        BXLO LR
        CMP R3, #122
        IT HI
        BXHI LR
        //---------
        SUB R3, #32 //Se resta 32 para pasar el caracter a mayuscula
        STRB R3, [R0]  //Guarda M(R0)=R1
        BX LR //vuelvo a cadena


minus: //Convierte un caracter en mayúscula a minúscula 

        //Controlo que el caracter se encuentra entre A y Z 
        CMP R3, #65
        IT LO
        BXLO LR
        CMP R3, #90
        IT HI
        BXHI LR
        //---------
        ADD R3, #32 //Se suma 32 para pasar el caracter a minuscula
        STRB R3, [R0]  //Guarda M(R0)=R1
        BX LR //vuelvo a cadena

convertir:  PUSH {LR}
            CMP R1, #3
            IT NE
            POPNE {PC}    
            LDRB R3, [R0]
            CMP R3, 0X00
            IT EQ
            POPEQ {PC}
            CMP R2, R0
            IT EQ
            BLEQ mayus
            ADD R0, #1
            LDRB R3, [R0]
            CMP R2, R0
            IT LT
            BLLT minus
            POP {LR}
            B convertir
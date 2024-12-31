/*1) 40 Minutos - 40 Puntos (20, 20)
Escriba una subrutina que cambie de minúsculas a mayúsculas un carácter ASCII.
a) Diseñe y escriba una subrutina transparente mayus que convierta el carácter almacenado
en R0 de minúscula a mayúscula. La rutina debe tener en cuenta que si el carácter no se
encuentra en a y z, deberá devolver el mismo sin modificar.
b) Diseñe y escriba ahora una subrutina transparente cadena que recibe en R0 la dirección
de memoria del inicio de la cadena de caracteres para convertir la misma a mayúscula.
Escriba el programa de principal para probar la misma.
Parámetros M[R0] = hola
Resultado M[R0] = HOLA
Como ayuda, la cadena de caracteres solo estará formada por 1 palabra, por lo que no tendrá
espacios en el medio, la cadena termina con el \0 */
            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data
palabra:     .asciz "hola"
caracter:   .ascii "p" //probé con A

            .section .text
            .global reset

reset:  LDR R0, =palabra //paso por referencia en registro
        BL cadena

stop:   B stop

mayus: //Convierte un caracter en minúscula a mayúscula

        //Controlo que el caracter se encuentra entre a y z 
        CMP R1, #97
        IT LO
        BXLO LR
        CMP R1, #122
        IT HI
        BXHI LR
        //---------
        SUB R1, #32 //Se resta 32 para pasar el caracter a mayuscula
        STRB R1, [R0]  //Guarda M(R0)=R1
        BX LR //vuelvo a cadena

cadena: PUSH {LR}
        LDRB R1, [R0]
        CMP R1, 0X00
        ITE EQ
        POPEQ {PC}
        BLNE mayus
        ADD R0, #1
        POP {LR}
        B cadena
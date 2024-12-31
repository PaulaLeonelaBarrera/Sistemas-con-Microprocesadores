/*1) 40 Minutos - 40 Puntos (20, 20)
Escriba una subrutina que cambie de minúsculas a mayúsculas un carácter ASCII.
a) Diseñe y escriba una subrutina transparente mayus que convierta el carácter almacenado
en R0 de minúscula a mayúscula. La rutina debe tener en cuenta que si el carácter no se
encuentra en a y z, deberá devolver el mismo sin modificar. */
            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

caracter:   .ascii "p" //probé con A

            .section .text
            .global reset

reset:  LDR R0, =caracter //paso por referencia en registro
        LDRB R1,[R0] //paso por registro
        BL mayus

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
        BX LR //vuelvo al programa principal

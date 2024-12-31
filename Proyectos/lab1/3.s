    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

base: 
    .byte 0x06,0x7A,0x7B,0x7C,0x00
    .align


    .section .text
    .global reset
reset:
        LDR R0,=base //Cargo la direccion base del registro

lazoCarga:  LDRB R1,[R0],#1 //CArgo el primer caracter y muevo el puntero
            MOV R2,#8
            MOV R3,#0

lazoCuenta: RORS R1,R1,#1 //Roto los shift para ir controlando 1 la idea es que quede en la misma posicion
            IT  HS
            ADDHS R3,#1
            //---Termina IF---
            SUB R2,#1     //Resto para llevar control de cuantos bits van haciendo shift
            CMP R2,0x00
            ITT EQ   //Contador llega a cero?
            LSREQ R1,#16//Para no realizar 32 iteraciones hago un shift de 24 y ya queda el numero original
            LSREQ R1,#8

            BNE lazoCuenta //Si aun no llega volve a seguir contando
            //---Fin lazo cuenta---

            LSRS R3,#1      //Veo si el que se fue contando es par o impar
            ITT HS           //Si es impar agrego 1 al mas significativo con un ORR
            ORRHS R1,R1,0x80
            STRBHS R1,[R0,#-1] //TEngo que decrementar uno temporalmente porque ya incremente antes

            CMP R1, 0x00    //comparo si se trata del ultimo caracter
            BNE lazoCarga  //Si no es el ultimo caracter vuelvo para pasar al sgte caracter

stop:       B stop
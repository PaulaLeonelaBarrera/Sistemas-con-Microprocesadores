/*Escriba una subrutina transparente que realice la suma de un número de 64 bits y uno de
32 bits. Esta subrutina recibe la dirección del número de 64 bits en R0 y el número de 32
bits en R1. El resultado, de 64 bits, se almacena en el mismo lugar donde se recibió el primer operando. 
Escriba un programa principal para probar el funcionamiento de la misma. 
Por ejemplo:
Parámetros:      R0 = 0x1008.0000       R1 = 0xA056.0102
Pre condiciones: M[R0] = 0x8100.0304    M[R0+4] = 0x0020.0605 //ESTO ES EL NUMERO DE 64bits
Resultado:       M[R0] = 0x2156.0406    M[R0+4] = 0x0020.0606
 */
            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

operando:   .word 0x81000304, 0x00200605

            .section .text
            .global reset

reset:      LDR R0,=operando        //dirección del nro de 64 bits en R0
            //MOVER UNA CTE > 16 bits //operando de 32 bits
            MOV R1,#0x0102          //1ero muevo la parte baja
            MOVT R1,#0XA056         //MoveTop: carga la parte alta del registro sin alterar la parte baja.
            BL suma        //Instrucción de llamada a subrutina suma

stop:       B stop

suma:       LDR R2,[R0]             //cargo en R2 los 32 ult bits del numero//0x81000304
            ADDS R1 ,R1 ,R2         //sumo 81000304+A0560102//R1=R1+R2
            STR R1,[R0]             //guardo en M[R0] el resultado de la suma
            LDR R2,[R0,#4]          //cargo en R2 los 1eros 32b
            ADC R2,#0               //le sumo el carry del ADDS
            STR R2,[R0,#4]          //guardo el numero en memoria
            BX LR            //Instrucción de retorno

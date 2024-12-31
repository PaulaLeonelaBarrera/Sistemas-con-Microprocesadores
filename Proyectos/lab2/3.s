/*Extraiga de la solución desarrollada por usted para el ejercicio 4 del laboratorio 1 el código necesario 
para implementar una subrutina transparente que realice el incremento de los segundos representados como 
dos dígitos BCD almacenados en dos direcciones consecutivas de memoria. La misma recibe el valor numérico 1 
en el registro R0 y la dirección de memoria donde está almacenado el dígito menos significativo en el registro R1.
La subrutina devuelve en el registro R0 el valor 1 si ocurre un desbordamiento de los segundos
y se debe efectuar un incremento en los minutos, o 0 en cualquier otro caso. */
        .cpu cortex-m4
        .syntax unified
        .thumb
        .section .data

segundos:   .byte 0x08, 0x05 //numeros BCD almacenados en dos direcciones consecutivas de memoria


        .section .text
        .global reset
      
reset:  MOV R0,#1
        LDR R1,=segundos  //la dirección de memoria donde está almacenado el dígito menos significativo

        BL incrementarSegundos

stop: B stop


incrementarSegundos:    PUSH {R4-R5}
                        //Recibe el valor numerico 1 en R0
                        //EN R4 y R5 guardare el valor de los segundos
                        LDRB R4,[R1] //Menos signif
                        LDRB R5,[R1,#1] //Mas significativo

                        //Condicion si el valor de R0 es 1
                        CMP R0,0x01
                        IT EQ  
                        ADDEQ R4,#1 //Sumo 01 seg
                        //----

                        MOV R0,#0 //Establezco por defecto la bandera R0 en 0

                        //Condicion dig menos significativo mayor a 9
                        CMP R4,0x09
                        ITT HI
                        MOVHI R4,#0 //Si el dig menos sig es > 9 vuelve a cero
                        ADDHI R5,#1 //Sumo 1 al dig mas significativo
                        //----

                        CMP R5,0x05
                        ITT HI
                        MOVHI R5,#0
                        MOVHI R0,#1 //Bandera en 1 para indicar desbordamiento

                        //Realizo guardado de los segundos correspondientes
                        STRB R4,[R1] //Menos signif
                        STRB R5,[R1,#1] //Mas significativo
                        
                        POP {R4-R5}
                        BX LR  //Salto colocando en el pc la instruccion en LR

    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
vector: .hword 1, 4, 6, 10, 15
/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:  MOV  R0,#4
        LDR  R1,=vector
        MOV  R2,#0
        MOV  R3,#4
        PUSH {R0-R3} //Para rec
        BL   busqRec
        POP  {R0-R3}//Para rec
stop:   B stop
        .endfunc

        // Punto b 
        .func busqIter
        // Recibe en R0 el numero a buscar, R1 &base, R2 inicio, R3 final
        // Devuelve el indice en R0 si se encontro, sino -1
busqIter:    PUSH {R4-R6}
             MOV  R6,#0              // Cargo una bandera en 0

loopIter:   CMP  R2,R3     
            BGT  noEncontro         // Si el inicio es mayor al final, salta al final
            CMP  R6,0               
            BNE  encontro           // Si la bandera es 1, se encontro
            ADD  R4,R2,R3           // Sumo el inicio mas el fin
            BIC  R4,R4,#0x1         // Divido y multiplico por 2 (poner el bit menos sig en 0) ya que trabajamos con hwords
            LDRH R5,[R1,R4]         // Cargo el valor del medio
            
            CMP  R5,R0
            ITT  EQ
            LSREQ R0,R4,#1          // Si se encuentra, guardar el indice y actualizar bandera
            MOVEQ R6,#1
            ITT   LT
            ADDLT R2,R4,#2          // Si es menor, cambio el indice menor
            LSRLT R2,R2,#1
            ITT   GT
            SUBGT R3,R4,#2          // Si es mayor, cambio el indice mayor
            LSRGT R3,R3,#1

            B    loopIter
noEncontro: MOV  R0,#-1

encontro:   POP  {R4-R6}
            BX LR

            .endfunc

            // Punto c 
            .func busqRec
            // Recibe en R0 el numero a buscar, R1 &base, R2 inicio, R3 final
            // Devuelve el indice en R0 si se encontro, sino -1
busqRec:    POP  {R0-R3}
            PUSH {R4-R5,LR}   

            CMP  R2,R3     
            BGT  noEncontroRec      // Si el inicio es mayor al final, salta al final
            ADD  R4,R2,R3           // Sumo el inicio mas el fin
            BIC  R4,R4,#0x1         // Divido y multiplico por 2 (poner el bit menos sig en 0) ya que trabajamos con hwords
            LDRH R5,[R1,R4]         // Cargo el valor del medio

            CMP  R5,R0
            BEQ  encontroRec
            ITT   LT
            ADDLT R2,R4,#2          // Si es menor, cambio el indice menor
            LSRLT R2,R2,#1
            ITT   GT
            SUBGT R3,R4,#2          // Si es mayor, cambio el indice mayor
            LSRGT R3,R3,#1
            PUSH {R0-R3}
            BL   busqRec
            POP  {R0-R3}
            B    finRec

noEncontroRec:  MOV  R0,#-1
                B    finRec
encontroRec:    LSR   R0,R4,#1          // Si se encuentra, guardar el indice


finRec:     POP  {R4-R5,LR}
            PUSH {R0-R3}
            BX   LR

            .endfunc

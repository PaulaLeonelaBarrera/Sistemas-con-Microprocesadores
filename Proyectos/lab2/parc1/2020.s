    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
binario: .byte 7,40,37,26,52,62,63,1,2
cadena: .space 12
/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:  LDR  R0,=binario
        LDR  R1,=cadena
        MOV R4, R0
        MOV R5, R1

        MOV  R2,#7
        BL   codifArb
        //BL codifMIME

stop:   B stop

        .endfunc

    // Punto a
    .func codifMIME
    // Recibe en R4 &binario, R5 &cadena
codifMIME://
            PUSH  {R6-R8}           // Push de R6 a R8
            LDRB  R6,[R4],#1        // Cargo byte del binario, sumo 1 a la direccion
            LSL   R6,#8             // Shift byte a la izquierda
            LDRB  R7,[R4],#1        // Cargo el segundo byte en R7, sumo 1 a la direccion
            ORR   R6,R7             // Combino R6 y R7
            LSL   R6,#8             // Shift byte a la izquierda
            LDRB  R7,[R4],#1        // Cargo el tercer byte en R7, sumo 1 a la direccion
            ORR   R6,R7             // Combino R6 y R7    
            LDR   R8,=tabla         // Apunto R4 a la tabla de conversion

            LSR   R7,R6,#16         // Shift 16 bits a la derecha para tener los primeros 6 bits
            AND   R7,#0x3F          // Enmascaro los 6 bits menos significativos
            LDRB  R7,[R8,R7]        // Cargo el valor ASCII en R7
            STRB  R7,[R5],#1        // Guardo el valor convertido en la cadena, sumo 1 a la direccion

            LSR   R7,R6,#8          // Shift 8 bits a la derecha
            AND   R7,#0x3F          // Enmascaro los 6 bits menos significativos
            LDRB  R7,[R8,R7]        // Cargo el valor ASCII en R7
            STRB  R7,[R5],#1        // Guardo el valor convertido en la cadena, sumo 1 a la direccion
            
            AND   R7,R6,#0x3F       // Enmascaro los 6 bits menos significativos
            LDRB  R7,[R8,R7]        // Cargo el valor ASCII en R7
            STRB  R7,[R5],#1        // Guardo el valor convertido en la cadena, sumo 1 a la direccion

            POP   {R6-R8}
            BX LR

            .pool

tabla://
    .ascii "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"  // 0-25
    .ascii "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"  // 26-51
    .ascii "0","1","2","3","4","5","6","7","8","9"   // 52-61
    .ascii "+","/"   //62-63
    .align
    .endfunc

    // Punto b
    .func codif3B
    // Recibe en R4 &binario, R5 &cadena, R6 cantidad de bytes
codif3B://
    PUSH {LR}               // Push LR para poder llamar una funcion adentro
loop3B://
    CMP  R6,3               // Comparo R6 con 3
    BLT  fin3B              // Si es menor a 3, va al final
    BL   codifMIME          // Llamo a la funcion de codif
    SUB  R6,#3              // Resto 3 a R6
    B    loop3B
fin3B://
    POP  {PC}
    .endfunc

    // Punto c
    .func codifArb
    // Recibe en R0 &binario, R1 &cadena, R2 cantidad de bytes
    
codifArb:   PUSH {R4-R6,LR}
            MOV  R4,R0              // Cargo el puntero de binario en R4
            MOV  R5,R1              // Cargo el puntero de cadena en R5
            
            MOV  R6,#3              // Cargo el numero 3 en R6 para checkear mod 3
            UDIV R3,R2,R6           // Cargo en R3 R2/3
            MUL  R3,R3,R6           // Cargo en R3 R3*3
            SUB  R3,R2,R3           // Cargo en R3 R2-R3

            MOV  R6,#0              // Cargo 0 en R6 para cargar en el final
            CMP  R3,1               
            IT  EQ
            STRHEQ R6,[R0,R2]       // Si el resto es 1, agrego dos ceros

            CMP  R3,2
            IT EQ
            STRBEQ R6,[R0,R2]       // Si el resto es 2, agrego un cero
            
            MOV R6,R2               // Cargo R2 en R6 para llamar a la funcion
            BL   codif3B

            CMP R6,0                // Si R6 quedo en 0, va al final
            BEQ finArb
            BL  codifMIME           // Llamada a la funcion en solo 3 bytes
            MOV  R6,#0x3D           // Cargo "=" en R6
            CMP  R3,1               // Si el resto es 1, agrego dos "="
            ITT  EQ
            STRBEQ R6,[R5,#-2]!
            STRBEQ R6,[R5,#1]!

            CMP  R3,2               // Si el resto es 2, agrego un "="
            IT EQ
            STRBEQ R6,[R5,#-1]
finArb://
    POP  {R4-R6,PC}

    .endfunc

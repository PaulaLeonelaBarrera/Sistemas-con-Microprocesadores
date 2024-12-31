.cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// -------------------------------------------------------------------------
// Recursos utilizados por el led 1
    .equ LED_1_PORT,    2
    .equ LED_1_PIN,     10
    .equ LED_1_BIT,     14
    .equ LED_1_MASK,    (1 << LED_1_BIT)

    .equ LED_1_GPIO,    0
    .equ LED_1_OFFSET,  ( LED_1_GPIO << 2)
// Recursos utilizados por el led 2
    .equ LED_2_PORT,    2
    .equ LED_2_PIN,     11
    .equ LED_2_BIT,     11
    .equ LED_2_MASK,    (1 << LED_2_BIT)

// Recursos utilizados por el led 3
    .equ LED_3_PORT,    2
    .equ LED_3_PIN,     12
    .equ LED_3_BIT,     12
    .equ LED_3_MASK,    (1 << LED_3_BIT)

// Recursos utilizados por los leds 2 y 3
    .equ LED_N_GPIO,    1
    .equ LED_N_OFFSET,  ( LED_N_GPIO << 2)
    .equ LED_N_MASK,    ( LED_2_MASK | LED_3_MASK )
// Digito 1
    .equ DIG1_PORT,     0
    .equ DIG1_PIN,      0
    .equ DIG1_BIT,      0
    .equ DIG1_MASK,     (1 << DIG1_BIT)

// Digito 2
    .equ DIG2_PORT,     0
    .equ DIG2_PIN,      1
    .equ DIG2_BIT,      1
    .equ DIG2_MASK,     (1 << DIG2_BIT)

// Digito 3
    .equ DIG3_PORT,     1
    .equ DIG3_PIN,      15
    .equ DIG3_BIT,      2
    .equ DIG3_MASK,     (1 << DIG3_BIT)

// Digito 4
    .equ DIG4_PORT,     1
    .equ DIG4_PIN,      17
    .equ DIG4_BIT,      3
    .equ DIG4_MASK,     (1 << DIG4_BIT)

// Recursos usados por Digitos
    .equ DIG_GPIO,      0
    .equ DIG_OFFSET,    ( DIG_GPIO << 2 )
    .equ DIG_MASK,      ( DIG1_MASK | DIG2_MASK | DIG3_MASK | DIG4_MASK )

//  Segmento A 
    .equ SEGA_PORT,     4
    .equ SEGA_PIN,      0
    .equ SEGA_BIT,      0
    .equ SEGA_MASK,     (1 << SEGA_BIT)

//  Segmento B 
    .equ SEGB_PORT,     4
    .equ SEGB_PIN,      1
    .equ SEGB_BIT,      1
    .equ SEGB_MASK,     (1 << SEGB_BIT)

//  Segmento C 
    .equ SEGC_PORT,     4
    .equ SEGC_PIN,      2
    .equ SEGC_BIT,      2
    .equ SEGC_MASK,     (1 << SEGC_BIT)

//  Segmento D
    .equ SEGD_PORT,     4
    .equ SEGD_PIN,      3
    .equ SEGD_BIT,      3
    .equ SEGD_MASK,     (1 << SEGD_BIT)

//  Segmento E
    .equ SEGE_PORT,     4
    .equ SEGE_PIN,      4
    .equ SEGE_BIT,      4
    .equ SEGE_MASK,     (1 << SEGE_BIT)

//  Segmento F
    .equ SEGF_PORT,     4
    .equ SEGF_PIN,      5
    .equ SEGF_BIT,      5
    .equ SEGF_MASK,     (1 << SEGF_BIT)

//  Segmento G
    .equ SEGG_PORT,     4
    .equ SEGG_PIN,      6
    .equ SEGG_BIT,      6
    .equ SEGG_MASK,     (1 << SEGG_BIT)

// Recursos usados por Segmentos
    .equ SEG_GPIO,      2
    .equ SEG_OFFSET,    ( SEG_GPIO << 2)
    .equ SEG_MASK,      ( SEGA_MASK | SEGB_MASK | SEGC_MASK | SEGD_MASK | SEGE_MASK | SEGF_MASK | SEGG_MASK ) 

// -------------------------------------------------------------------------    
// Aceptar
    .equ ACEP_PORT,     3
    .equ ACEP_PIN,      2
    .equ ACEP_BIT,      9
    .equ ACEP_MASK,     (1 << ACEP_BIT)
// Cancelar
    .equ CANC_PORT,     3
    .equ CANC_PIN,      1
    .equ CANC_BIT,      8
    .equ CANC_MASK,     (1 << CANC_BIT)

// Recursos usados por Aceptar y Cancelar
    .equ BOTAC_GPIO,      5
    .equ BOTAC_OFFSET,    ( BOT_GPIO << 2)
    .equ BOTAC_MASK,      ( ACEP_MASK | CANC_MASK )

// Intento de la primer tecla
    .equ BOT1_PORT,     4
    .equ BOT1_PIN,      8
    .equ BOT1_BIT,      12
    .equ BOT1_MASK,     (1 << BOT1_BIT)

// segunda tecla
    .equ BOT2_PORT,     4
    .equ BOT2_PIN,      9
    .equ BOT2_BIT,      13
    .equ BOT2_MASK,     (1 << BOT2_BIT)

// tercer tecla
    .equ BOT3_PORT,     4
    .equ BOT3_PIN,      10
    .equ BOT3_BIT,      14
    .equ BOT3_MASK,     (1 << BOT3_BIT)

// uarta tecla
    .equ BOT4_PORT,     6
    .equ BOT4_PIN,      7
    .equ BOT4_BIT,      15
    .equ BOT4_MASK,     (1 << BOT4_BIT)

// Recursos utilizados por los Botones
    .equ BOT_GPIO,      5
    .equ BOT_OFFSET,    ( BOT_GPIO << 2)
    .equ BOT_MASK,      ( BOT1_MASK | BOT2_MASK | BOT3_MASK | BOT4_MASK)

/****************************************************************************/
/* Vector de interrupciones                                                 */
/****************************************************************************/

    .section .isr           // Define una seccion especial para el vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value
    .word   handler+1       //  2: Non mascarable interrupt service routine
    .word   handler+1       //  3: Hard fault system trap service routine
    .word   handler+1       //  4: Memory manager system trap service routine
    .word   handler+1       //  5: Bus fault system trap service routine
    .word   handler+1       //  6: Usage fault system tram service routine
    .word   0               //  7: Reserved entry
    .word   0               //  8: Reserved entry
    .word   0               //  9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call trap service routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service system trap service routine
    .word   systick_isr+1   // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la seccion de variables (RAM)
espera:
    .word 1                 // Variable compartida con el tiempo de espera

dado:
    .byte 0,0               // Dados

apretado:
    .byte 0,0               //Aceptar/Cancelar

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del codigo
    .section .text          // Define la seccion de codigo (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:

    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]
    
    // Llama a una subrutina para configurar el systick
    BL systick_init

    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT  | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(LED_2_PORT << 7 | LED_2_PIN << 2)]
    STR R0,[R1,#(LED_3_PORT << 7 | LED_3_PIN << 2)]

    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#((ACEP_PORT << 5 | ACEP_PIN) << 2)]
    STR R0,[R1,#((CANC_PORT << 5 | CANC_PIN) << 2)]

    // Configura los pines de los Digitos como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(4 * (32 * DIG1_PORT + DIG1_PIN))]
    STR R0,[R1,#(4 * (32 * DIG2_PORT + DIG2_PIN))]
    STR R0,[R1,#(4 * (32 * DIG3_PORT + DIG3_PIN))]
    STR R0,[R1,#(4 * (32 * DIG4_PORT + DIG4_PIN))]

    // Configura los pines de los Segmentos como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(4 * (32 * SEGA_PORT + SEGA_PIN))]

    // Apaga todos los bits gpio de los Digitos
    LDR R1,=GPIO_CLR0
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    // Configura los bits gpio de los Digitos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    // Apaga todos los bits gpio de los Segmentos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    // Configura los bits gpio de los Segmentos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,#SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    // Configura los bits gpio de los BOTONES como entradas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#BOTAC_OFFSET]
    BIC R0,#BOTAC_MASK
    STR R0,[R1,#BOTAC_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

refrescar:
   //JUGADOR 1
    // Define el estado actual de los leds como todos apagados
    MOV   R3,#0x00              // Carga el estado arctual de las teclas
    LDR   R2,[R4,#BOTAC_OFFSET]
    LDR R1, =dado
    LDRB R0, [R1]

    TST R2,#ACEP_MASK    // Si la tecla esta apretada dejo de contar
    BNE elseJ1
    LDR R2, =apretado
    LDRB R2, [R2]
    CMP R2, #0
    BNE elseJ1            // SI ya se apreto, no cuento
    BL contar
    B finIfJ1
elseJ1:
    MOV R2, #1
    LDR R3, =apretado
    STRB R2, [R3]

finIfJ1:
    STRB R0, [R1]
    MOV R8, #DIG1_MASK
    BL pintar                   // Pinta en el Digito el Numero
    
    STR R8, [R4, #DIG_OFFSET]   // Actualiza digito
    STR R1,[R4,#SEG_OFFSET]     // Actualiza numero
    
    BL demora
    //JUGADOR 2
    // Define el estado actual de los leds como todos apagados
    MOV   R3,#0x00              // Carga el estado arctual de las teclas
    LDR   R2,[R4,#BOTAC_OFFSET]
    LDR R1, =dado+1
    LDRB R0, [R1]

    TST R2,#CANC_MASK    // Si la tecla esta apretada dejo de contar
    BNE elseJ2
    LDR R2, =apretado+1
    LDRB R2, [R2]
    CMP R2, #0
    BNE elseJ2            // SI ya se apreto, no cuento
    BL contar
    B finIfJ2
elseJ2:
    MOV R2, #1
    LDR R3, =apretado+1
    STRB R2, [R3]

finIfJ2:
    STRB R0, [R1]
    MOV R8, #DIG2_MASK
    BL pintar                   // Pinta en el Digito el Numero
    
    STR R8, [R4, #DIG_OFFSET]   // Actualiza digito
    STR R1,[R4,#SEG_OFFSET]     // Actualiza numero

    BL demora
ganador:
    LDR R1, =apretado
    LDRB R0, [R1]
    LDRB R1, [R1,#1]
    CMP R0,#0
    BEQ finSinGanador
    CMP R1,#0
    BEQ finSinGanador

    LDR R1, =dado
    LDRB R0, [R1]
    LDRB R1, [R1,#1]

    CMP R0,R1
    BHS elseGanador    // R0>=R1
    MOV R0, #2
    MOV R8, #DIG3_MASK
    BL pintar
    B finGanador
elseGanador:
    MOV R0, #1
    MOV R8, #DIG3_MASK
    BL pintar

finGanador:
    STR R8, [R4, #DIG_OFFSET]   // Actualiza digito
    STR R1,[R4,#SEG_OFFSET]     // Actualiza numero

finSinGanador:
    BL demora
    B   refrescar
stop:
    B stop
    .pool                   // Almacenar las constantes de codigo
    .endfunc
    .func elegirDigito
elegirDigito:
    TST R0, #0
    IT EQ
    MOVEQ R1, #DIG3_MASK // Cargo el digito en el que escribire

    TST R0, #1
    IT EQ
    MOVEQ R1, #DIG4_MASK    // Fundamento del desorden: asi anda, no se como hacerlo mas lindo (y no quieor)

    TST R0, #2
    IT EQ
    MOVEQ R1, #DIG1_MASK

    TST R0, #3
    IT EQ
    MOVEQ R1, #DIG2_MASK

    BX LR
    .endfunc
    .func pintar
pintar:
    LDR R3,=tabla           // Apunta R3 al bloque con la tabla
    LDRB R1,[R3,R0]         // Cargar en R1 el elemento convertido

    BX LR 
    .pool                   // Almacenar las constantes de código

tabla:                      // Define la tabla de conversión 
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67
    .endfunc
    .func contar
contar:                 //Recibe en R0 la cuenta y la devuelve modificada
        ADD R0, #1
        CMP R0, #7
        IT EQ
        MOVEQ R0, #0
fin:    
        BX LR

    .endfunc
    
/************************************************************************************/
/* Rutina de inicializacion del SysTick                                             */
/************************************************************************************/
.func systick_init
systick_init:
    CPSID I                     // Se deshabilitan globalmente las interrupciones

    // Se sonfigura prioridad de la interrupcion
    LDR R1,=SHPR3               // Se apunta al registro de prioridades
    LDR R0,[R1]                 // Se cargan las prioridades actuales
    MOV R2,#2                   // Se fija la prioridad en 2
    BFI R0,R2,#29,#3            // Se inserta el valor en el campo
    STR R0,[R1]                 // Se actualizan las prioridades

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]                 // Se quita el bit ENABLE

    // Se configura el desborde para un periodo de 100 ms
    LDR R1,=SYST_RVR
    LDR R0,=#96000        //UN MILISEGUNDO
    STR R0,[R1]                 // Se especifica el valor de RELOAD

    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    // Escribir cualquier valor limpia el contador
    STR R0,[R1]                 // Se limpia COUNTER y flag COUNT

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1]                 // Se fijan ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                     // Se habilitan globalmente las interrupciones
    BX  LR                      // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
    .func systick_isr
systick_isr:
    PUSH {LR}

    LDR  R0,=espera             // Se apunta R0 a la variable espera
    LDR R1,[R0]                // Se carga el valor de la variable espera
    SUBS R1,#1                  // Se decrementa el valor de espera
    BHI  systick_exit           // Si Espera > 0 entonces NO pasaron 10 veces
    LDR R1,=GPIO_NOT0           // Se apunta a la base de registros NOT
    MOV R0,#LED_3_MASK          // Se carga la mascara para el LED 2
    STR R0,[R1,#LED_N_OFFSET]   // Se invierte el bit GPIO del LED 2
    MOV R1, #1000               // Reseteo la espera
systick_exit:
    LDR R0, =espera
    STR R1,[R0]                // Se actualiza la variable espera
    POP {LR}
    BX   LR                     // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de codigo
    .endfunc

/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.          */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/
    .func handler
handler:
    LDR R1,=GPIO_SET0           // Se apunta a la base de registros SET
    MOV R0,#LED_1_MASK          // Se carga la mascara para el LED 1
    STR R0,[R1,#LED_1_OFFSET]   // Se activa el bit GPIO del LED 1
    B handler                   // Lazo infinito para detener la ejecucion
    .pool                       // Se almacenan las constantes de codigo
    .endfunc

    .func demora
demora: 
    PUSH {R4,R5}
    MOV R4,#0
    LDR R5,=max
    LDR R5,[R5]
lazo_demora:
    ADD R4,#1
    CMP R4,R5   
    BLE lazo_demora

    POP {R4,R5}
    BX LR
max:
    .word 50000
    .endfunc

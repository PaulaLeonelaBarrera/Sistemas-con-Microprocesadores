    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

    /****************************************************************************/
    /* Definiciones de macros                                                   */
    /****************************************************************************/

    // Recursos utilizados por el segmento A
    // Numero de puerto de entrada/salida utilizado en el Segmento A
    .equ SEG_A_PORT,    4
    // Numero de terminal dentro del puerto de e/s utilizado en el Segmento A
    .equ SEG_A_PIN,     0
    // Numero de bit GPIO utilizado en el Segmento A
    .equ SEG_A_BIT,     0
    // Mascara de 32 bits con un 1 en el bit correspondiente al Segmento A
    .equ SEG_A_MASK,    (1 << SEG_A_BIT)

// Recursos utilizados por el segmento B
    .equ SEG_B_PORT,    4
    .equ SEG_B_PIN,     1
    .equ SEG_B_BIT,     1
    .equ SEG_B_MASK,    (1 << SEG_B_BIT)

// Recursos utilizados por el segmento C
    .equ SEG_C_PORT,    4
    .equ SEG_C_PIN,     2
    .equ SEG_C_BIT,     2
    .equ SEG_C_MASK,    (1 << SEG_C_BIT)

// Recursos utilizados por el segmento D
    .equ SEG_D_PORT,    4
    .equ SEG_D_PIN,     3
    .equ SEG_D_BIT,     3
    .equ SEG_D_MASK,    (1 << SEG_D_BIT)

// Recursos utilizados por el segmento E
    .equ SEG_E_PORT,    4
    .equ SEG_E_PIN,     4
    .equ SEG_E_BIT,     4
    .equ SEG_E_MASK,    (1 << SEG_E_BIT)

// Recursos utilizados por el segmento F
    .equ SEG_F_PORT,    4
    .equ SEG_F_PIN,     5
    .equ SEG_F_BIT,     5
    .equ SEG_F_MASK,    (1 << SEG_F_BIT)

// Recursos utilizados por el segmento G
    .equ SEG_G_PORT,    4
    .equ SEG_G_PIN,     6
    .equ SEG_G_BIT,     6
    .equ SEG_G_MASK,    (1 << SEG_G_BIT)

// Recursos utilizados por los segmentos
    // Numero de puerto GPIO utilizado por los segmentos
    .equ SEG_GPIO,      2
    // Desplazamiento para acceder a los registros GPIO de los segmentos
    .equ SEG_OFFSET,    ( 4 * SEG_GPIO )
    // Mascara de 32 bits con un 1 en los bits correspondiente a cada segmento
    .equ SEG_MASK,      ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK)

// -------------------------------------------------------------------------
// Recursos utilizados por el Digito 1
    .equ DIG_1_PORT,    0
    .equ DIG_1_PIN,     0
    .equ DIG_1_BIT,     0
    .equ DIG_1_MASK,    (1 << DIG_1_BIT)

// Recursos utilizados por el Digito 2
    .equ DIG_2_PORT,    0
    .equ DIG_2_PIN,     1
    .equ DIG_2_BIT,     1
    .equ DIG_2_MASK,    (1 << DIG_2_BIT)

// Recursos utilizados por el Digito 3
    .equ DIG_3_PORT,    1
    .equ DIG_3_PIN,     15
    .equ DIG_3_BIT,     2
    .equ DIG_3_MASK,    (1 << DIG_3_BIT)

// Recursos utilizados por el Digito 4
    .equ DIG_4_PORT,    1
    .equ DIG_4_PIN,     17
    .equ DIG_4_BIT,     3
    .equ DIG_4_MASK,    (1 << DIG_4_BIT)

// Recursos utilizados por los Digitos
    .equ DIG_N_GPIO,    0
    .equ DIG_N_OFFSET,  ( DIG_N_GPIO << 2)
    .equ DIG_N_MASK,    ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK )

// -------------------------------------------------------------------------    
// Recursos utilizados por el led 1
    .equ LED_1_PORT,    2
    .equ LED_1_PIN,     10
    .equ LED_1_BIT,     14
    .equ LED_1_MASK,    (1 << LED_1_BIT)

    .equ LED_1_GPIO,    0
    .equ LED_1_OFFSET,  ( LED_1_GPIO << 2)


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
    .word   systick_isr+1       // 15: System tick service routine
    .word   handler+1       // 16: IRQ 0: DAC service routine
    .word   handler+1       // 17: IRQ 1: M0APP service routine
    .word   handler+1       // 18: IRQ 2: DMA service routine
    .word   0               // 19: Reserved entry
    .word   handler+1       // 20: IRQ 4: FLASHEEPROM service routine
    .word   handler+1       // 21: IRQ 5: ETHERNET service routine
    .word   handler+1       // 22: IRQ 6: SDIO service routine
    .word   handler+1       // 23: IRQ 7: LCD service routine
    .word   handler+1       // 24: IRQ 8: USB0 service routine
    .word   handler+1       // 25: IRQ 9: USB1 service routine
    .word   handler+1       // 26: IRQ 10: SCT service routine
    .word   handler+1       // 27: IRQ 11: RTIMER service routine
    .word   count_isr+1     // 28: IRQ 12: TIMER0 service routine
    .word   handler+1       // 29: IRQ 13: TIMER1 service routine
    .word   handler+1       // 30: IRQ 14: TIMER2 service routine
    .word   handler+1       // 31: IRQ 15: TIMER3 service routine
    .word   handler+1       // 32: IRQ 16: MCPWM service routine
    .word   handler+1       // 33: IRQ 17: ADC0 service routine
    .word   handler+1       // 34: IRQ 18: I2C0 service routine
    .word   handler+1       // 35: IRQ 19: I2C1 service routine
    .word   handler+1       // 36: IRQ 20: SPI service routine
    .word   handler+1       // 37: IRQ 21: ADC1 service routine
    .word   handler+1       // 38: IRQ 22: SSP0 service routine
    .word   handler+1       // 39: IRQ 23: SSP1 service routine
    .word   handler+1       // 40: IRQ 24: USART0 service routine
    .word   handler+1       // 41: IRQ 25: UART1 service routine
    .word   handler+1       // 42: IRQ 26: USART2 service routine
    .word   handler+1       // 43: IRQ 27: USART3 service routine
    .word   handler+1       // 44: IRQ 28: I2S0 service routine
    .word   handler+1       // 45: IRQ 29: I2S1 service routine
    .word   handler+1       // 46: IRQ 30: SPIFI service routine
    .word   handler+1       // 47: IRQ 31: SGPIO service routine
    .word   handler+1       // 48: IRQ 32: PIN_INT0 service routine
    .word   handler+1       // 49: IRQ 33: PIN_INT1 service routine
    .word   handler+1       // 50: IRQ 34: PIN_INT2 service routine
    .word   handler+1       // 51: IRQ 35: PIN_INT3 service routine
    .word   handler+1       // 52: IRQ 36: PIN_INT4 service routine
    .word   handler+1       // 53: IRQ 37: PIN_INT5 service routine
    .word   handler+1       // 54: IRQ 38: PIN_INT6 service routine
    .word   handler+1       // 55: IRQ 39: PIN_INT7 service routine
    .word   handler+1       // 56: IRQ 40: GINT0 service routine
    .word   handler+1       // 56: IRQ 40: GINT1 service routine

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la seccion de variables (RAM)
divisor:
    .space 1,0
digitos:
    .space 4,0
    /****************************************************************************/
    /* Programa principal                                                       */
    /****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina para configurar el systick
    BL systick_init

    // Configura los pines de los Segmentos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(4 * (32 * SEG_A_PORT + SEG_A_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_B_PORT + SEG_B_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_C_PORT + SEG_C_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_D_PORT + SEG_D_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_E_PORT + SEG_E_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_F_PORT + SEG_F_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_G_PORT + SEG_G_PIN))]

    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(LED_1_PORT << 7 | LED_1_PIN << 2)]

    // Se configuran los pines de los digitos 1 al 4 como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]

    // Apaga todos los bits gpio de los segmentos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    // Se apagan los bits gpio correspondientes a los digitos 
    LDR R0,=DIG_N_MASK
    STR R0,[R1,#DIG_N_OFFSET]
    LDR R0,=LED_1_MASK
    STR R0,[R1,#LED_1_OFFSET]

    // Configura los bits gpio de los segmentos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,#SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    LDR R0,=LED_1_MASK
    STR R0,[R1,#LED_1_OFFSET]
    // Se configuran los bits gpio de los digitos como salidas
    LDR R0,[R1,#DIG_N_OFFSET]
    ORR R0,#DIG_N_MASK
    STR R0,[R1,#DIG_N_OFFSET]


    // Cuenta con clock interno
    LDR R1,=TIMER0_BASE
    MOV R0,#0x00
    STR R0,[R1,#CTCR]

    // Prescaler de 95.000.000 para una frecuencia de 1 Hz
    LDR R0,=95000
    STR R0,[R1,#PR]

    // El valor de reset de 86400 segundos
    LDR R0,=86400
    STR R0,[R1,#MR3]

    // El valor de int de 1 segundo
    LDR R0,=0
    STR R0,[R1,#MR2]

    // El valor de alarma 1 01:24 = 5040
    LDR R0,=5040
    STR R0,[R1,#MR1]

    // El valor de alarma 2 08:33 = 30780
    LDR R0,=30780
    STR R0,[R1,#MR0]

    // El registro de match 3 provoca reset del contador, 2 int
    MOV R0,#(MR3R | MR2I)
    STR R0,[R1,#MCR]

    MOV R0,#(2 << 4 | 2 << 6)
    STR R0,[R1,#EMR]

    // Limpieza del contador
    MOV R0,#CRST
    STR R0,[R1,#TCR]

    // Inicio del contador
    MOV R0,#CEN
    STR R0,[R1,#TCR]


    // Limpieza del pedido pendiente en el NVIC
    LDR R1,=NVIC_ICPR0
    MOV R0,(1 << 12)
    STR R0,[R1]

    // Habilitacion del pedido de interrupcion en el NVIC
    LDR R1,=NVIC_ISER0
    MOV R0,(1 << 12)
    STR R0,[R1]

    CPSIE I     // Rehabilita interrupciones

main:
    WFI
    LDR R1,=TIMER0_BASE
    LDR R2,[R1,#EMR]
    AND R2,#3
    CMP R2,0
    BEQ res
    LDR R0,=set_led_3       // Apuntar al incio de una subrutina lejana
    BLX R0                  // Llamar a la rutina para encender el led rojo
    LDR R1,=TIMER0_BASE
    LDR R2,[R1,#EMR]
    BIC R2,#3
    STR R2,[R1,#EMR] 
    B finMain
res:
    LDR R0,=clear_led_3       // Apuntar al incio de una subrutina lejana
    BLX R0                  // Llamar a la rutina para encender el led rojo
finMain:
    B main

    .pool       // Almacenar las constantes de código
    .endfunc

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

    // Se configura el desborde para un periodo de 1 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(96000 - 1)
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

    BX  LR                      // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de codigo
.endfunc

  .func systick_isr
systick_isr:
    PUSH {LR}
    LDR  R1,=3600
    LDR  R2,=TIMER0_BASE
    LDR  R2,[R2,#MR2]
    UDIV R0,R2,R1
    MLS  R2,R1,R0,R2
    LDR  R1,=60
    UDIV R2,R2,R1
    LDR  R1,=digitos

    BL   hora
    LDR  R3,=divisor
    LDRB  R3,[R3]
    LDR  R2,=digitos
    LDRB R0,[R2],#1         // Guardo el digito a mostrar en R0
    CMP  R3,0
    BNE  dig1
    MOV  R1,#8              // Prender el LED4
    BL   mostrar

dig1:
    CMP  R3,5
    LDRB R0,[R2],#1            // Guardo el digito a mostrar en R0
    BNE  dig2
    MOV  R1,#4              // Prender el LED2
    BL   mostrar

dig2:
    CMP  R3,10
    LDRB R0,[R2],#1         // Guardo el digito a mostrar en R0
    BNE  dig3
    MOV  R1,#2              // Prender el LED3
    BL   mostrar

dig3:
    CMP  R3,15
    LDRB R0,[R2]            // Guardo el digito a mostrar en R0
    BNE  endref
    MOV  R1,#1              // Prender el LED4
    BL   mostrar
endref:
    CMP  R3,20
    ITE  EQ
    MOVEQ R3,#0
    ADDNE  R3,#1
    LDR  R0,=divisor
    STRB  R3,[R0]
    POP {LR}
    BX   LR

    .endfunc

.func count_isr
    count_isr:
    // Limpio el flag de interrupcion
    LDR R3,=TIMER0_BASE
    LDR R0,[R3,#IR]
    STR R0,[R3,#IR]

    LDR R0,[R3,#MR2]
    LDR R2,=86400
    CMP  R0,R2
    ITE EQ
    MOVEQ R0,#0
    ADDNE R0,#1
    STR R0,[R3,#MR2]
    BX   LR


    .pool                   // Almacenar las constantes de código
    .endfunc


    .func segmentos
    // Recibe en R0 el num a convertir, devuelve en R0 el num convertido
segmentos:
    PUSH {R4}               // Guardo el valor de R4
    LDR  R4,=tabla          // Apunta R4 al bloque con la tabla
    LDRB R0,[R4,R0]         // Cargar en R0 el elemento convertido
    POP  {R4}               // Devuelvo R4 a su valor original
    BX   LR                 // Vuelta a la llamada

    .pool                   // Almacenar las constantes de código

tabla:                      // Define la tabla de conversión 
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67      
    .endfunc

    .func mostrar
mostrar:
    PUSH {R4-R5}
    LDR R4,=GPIO_PIN0
    MOV R5,#0
    STRB R5,[R4,#DIG_N_OFFSET]
    STRB R5,[R4,#SEG_OFFSET]

    STRB R0,[R4,#SEG_OFFSET]
    STRB R1,[R4,#DIG_N_OFFSET]
    POP  {R4-R5}
    BX LR

    .endfunc

     .func conversion
    // Recibe en R0 numero 0-99, guarda en la dir almacenada en R1 las decenas, unidades en R1+1
conversion:
    PUSH {R4-R6}            // Guardo los valores de R4-R6
    MOV  R4,R0            // Cargo el valor del numero en R4
    MOV  R6,#10             // Cargo 10 en R6
    UDIV R5,R4,R6           // Guardo en R5 <- R4/10
    MUL  R5,R5,R6           // R5 <- R5 x 10
    SUB  R5,R4,R5           // R5 <- R4 - R5, unidades en R5
    UDIV R4,R4,R6           // Guardo en R4 las decenas
    STRB R4,[R1]            // Guardo en la direccion de R1 las decenas
    STRB R5,[R1,#1]         // Guardo en la dir de R1+1 las unidades
    POP  {R4-R6}            // Devuelvo R4-R6 a sus valores originales
    BX   LR                 // Vuelta a la llamada

    .endfunc

    .func hora
    // Recibe en R0 hora, R2,min , guarda la rep en 7seg en dir de R1 como
    // dest = dec_hora, dest+1 = un_hora, dest+2 = dec_min, dest+3 = un_min
hora:
    //Conversion de hora en 2 bytes a hora en 4 bytes en destino
    PUSH {LR}               // Guardo la direccion de la llamada
    BL  conversion          // Llamada a conversion de dia
    MOV R0,R2
    ADD R1,#2               // Sumo dos a R1 para guardar conversion de mes
    BL  conversion          // Llamada a conversion de mes
    SUB R1,#2               // Vuelvo a la direccion base

    LDRB R0,[R1]            // Cargo en R0 el numero a convertir
    BL  segmentos           // Llamo a segmentos para convertir
    STRB R0,[R1],#1         // Guardo en R1 el numero convertido, sumo 1 a R1

    LDRB R0,[R1]            // Cargo en R0 el numero a convertir
    BL  segmentos           // Llamo a segmentos para convertir
    STRB R0,[R1],#1         // Guardo en R1 el numero convertido, sumo 1 a R1

    LDRB R0,[R1]            // Cargo en R0 el numero a convertir
    BL  segmentos           // Llamo a segmentos para convertir
    STRB R0,[R1],#1         // Guardo en R1 el numero convertido, sumo 1 a R1

    LDRB R0,[R1]            // Cargo en R0 el numero a convertir
    BL  segmentos           // Llamo a segmentos para convertir
    STRB R0,[R1],#-3        // Guardo en R1 el numero convertido, resto 3 a R1

    POP {PC}                // Vuelvo a la llamada            

    .endfunc


    /****************************************************************************/
    /* Rutina de servicio generica para excepciones                             */
    /* Esta rutina atiende todas las excepciones no utilizadas en el programa.  */
    /* Se declara como una medida de seguridad para evitar que el procesador    */
    /* se pierda cuando hay una excepcion no prevista por el programador        */
    /****************************************************************************/
    .func handler
    handler:
    LDR R0,=set_led_1       // Apuntar al incio de una subrutina lejana
    BLX R0                  // Llamar a la rutina para encender el led rojo
    B handler               // Lazo infinito para detener la ejecucion
    .pool                   // Almacenar las constantes de codigo
    .endfunc

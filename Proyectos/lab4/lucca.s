    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

    /****************************************************************************/
    /* Definiciones de macros                                                   */
    /****************************************************************************/

    // Recursos utilizados por el punto del display
    .equ LED_PORT,      6
    .equ LED_PIN,       8
    .equ LED_MAT,       1
    .equ LED_TMR,       2

    // Recursos utilizados por la primera tecla de funcion
    .equ B1_PORT,	4
    .equ B1_PIN,	8
    .equ B1_BIT,	12
    .equ B1_MASK,	(1 << B1_BIT)

	// Recursos utilizados por la segunda tecla de funcion
    .equ B2_PORT,	4
    .equ B2_PIN,	9
    .equ B2_BIT,	13
    .equ B2_MASK,	(1 << B2_BIT)

	// Recursos utilizados por la tercera tecla de funcion
    .equ B3_PORT,	4
    .equ B3_PIN,	10
    .equ B3_BIT,	14
    .equ B3_MASK,	(1 << B3_BIT)

	// Recursos utilizados por la cuarta tecla de funcion
    .equ B4_PORT,	6
    .equ B4_PIN,	7
    .equ B4_BIT,	15
    .equ B4_MASK,	(1 << B4_BIT)

	// Recursos utilizados por la tecla aceptar
    .equ BA_PORT,	3
    .equ BA_PIN,	2
    .equ BA_BIT,	9
    .equ BA_MASK,	(1 << BA_BIT)

	// Recursos utilizados por la tecla cancelar
    .equ BC_PORT,	3
    .equ BC_PIN,	1
    .equ BC_BIT,	8
    .equ BC_MASK,	(1 << BC_BIT)

    .equ BOT_GPIO,	5
    .equ BOT_OFFSET, (BOT_GPIO << 2)
    .equ BOT_MASK,	( B1_MASK | B2_MASK | B3_MASK | B4_MASK | BA_MASK | BC_MASK)
    
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
    .word   handler+1       // 15: System tick service routine
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
    .word   handler+1       // 28: IRQ 12: TIMER0 service routine
    .word   handler+1       // 29: IRQ 13: TIMER1 service routine
    .word   timer_isr+1     // 30: IRQ 14: TIMER2 service routine
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
    /* Programa principal                                                       */
    /****************************************************************************/

    .section .data          // Define la sección de variables (RAM)
variables:
    .zero 8
    .equ periodo,    0      // Variable compartida el valor del periodo del PWM
    .equ factor,     4      // Variable compartida con el factor de trabajo del PWM
control_factor:             
    .word 0                 // Variable compartida para ir controlando el cambio en la intensidad
control_estados:
    .word 1
    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Configura el pin del punto como salida TMAT
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC5)
    STR R0,[R1,#(LED_PORT << 7 | LED_PIN << 2)]

    // Configuración de los pines de teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(B1_PORT << 7 | B1_PIN << 2)]
    STR R0,[R1,#(B2_PORT << 7 | B2_PIN << 2)]
    STR R0,[R1,#(B3_PORT << 7 | B3_PIN << 2)]
    STR R0,[R1,#(B4_PORT << 7 | B4_PIN << 2)]
    STR R0,[R1,#(BA_PORT << 7 | BA_PIN << 2)]
    STR R0,[R1,#(BC_PORT << 7 | BC_PIN << 2)]
  
    // Cargo en R1 un puntero al inicio del registro DIR (para configurar como E o S los pines)
    LDR R1,=GPIO_DIR0    
    // Configuración los bits gpio de todos los botones como entradas
    LDR R0,[R1,#(BOT_GPIO << 2)]
    AND R0,#~BOT_MASK
    STR R0,[R1,#(BOT_GPIO << 2)]

    // Inicialización de las variables con los tiempos del PWM
    LDR R1,=variables
    MOV R0,#100                  // Cargo un
    STR R0,[R1,#periodo]         // Periodo de 100
    MOV R2,#10                   // y un factor inicial
    STR R2,[R1,#factor]          // de 10%

    // Se elige cuenta con clock interno en el registro de control del timer de cuenta
    LDR R1,=TIMER2_BASE       // Apunto al registro de control del timer 2
    MOV R0,#0x00              // Elijo cuenta con clock interno
//0 cuenta con PCLK en FP
//1 Flanco Positivo en Fuente Externa
//2 Flanco Negativo en Fuente Externa
//3 Ambos flancos en Fuente Externa  
    STR R0,[R1,#CTCR]         // Cargo en el registro de control del timer de cuenta que use clock interno

    // Cargo en PR 9500 para que limite la cuenta del PC.
    // 48MHz / 9500 + 1 ==> obtengo una frecuencia de 5KHz de incremento en el timer counter
    LDR R0,=9500
    STR R0,[R1,#PR]          

    // La primera interupcion ocurre despues de 10 ciclos de TC
    STR R2,[R1,#MR1]

    // Habilito la interrupcion en el match register 1 cuando se cumpla lo anterior
    MOV R0,#(MR1I)
    STR R0,[R1,#MCR]

    // Define el estado inicial y toggle on match del led
    MOV R0,#(3 << (4 + (2 * LED_MAT)))
    STR R0,[R1,#EMR]

    // Limpieza del contador
    MOV R0,#CRST
    STR R0,[R1,#TCR]

    // Inicio del contador
    MOV R0,#CEN
    STR R0,[R1,#TCR]

    // Limpieza del pedido pendiente en el NVIC
    LDR R1,=NVIC_ICPR0
    MOV R0,(1 << 14)
    STR R0,[R1]

    // Habilitacion del pedido de interrupcion en el NVIC
    LDR R1,=NVIC_ISER0
    MOV R0,(1 << 14)
    STR R0,[R1]

    // Punteros al registro de control del GPIO0, luego accedere al GPIO5 mediante BOT_OFFSET. Y al registro de control de factor
    LDR R4,=GPIO_PIN0
    LDR R5,=control_factor
    LDR R6,=control_estados

    CPSIE I     // Rehabilita interrupciones


    main:
    // Carga el estado actual de las teclas
    LDR   R0,[R4,#BOT_OFFSET]

    // Verifica el estado del bit correspondiente al boton 1
    TST R0,#B1_MASK
    IT    NE                   
    BLNE  rebote      // Llamar a rutina antirebote
    // Si la tecla esta apretada
    TST R0,#B1_MASK
    ITT NE
    MOVNE R1, #10     // Cargo un 10
    STRNE R1, [R5]    // en el control del factor
    
    // Verifica el estado del bit correspondiente al boton 2
    TST R0,#B2_MASK
    IT    NE                   
    BLNE  rebote      // Llamar a rutina antirebote
    // Si la tecla esta apretada
    TST R0,#B2_MASK
    ITTT NE
    MOVNE R1, #0      // Cargo
    SUBNE R1, #10     // -10
    STRNE R1, [R5]    // en el control del factor

    // Verifica el estado del bit correspondiente a la tecla aceptar
    TST R0,#BA_MASK
    IT    NE                   
    BLNE  rebote      // Llamar a rutina antirebote
    // Si la tecla esta apretada
    TST R0,#BA_MASK
    ITT NE            
    MOVNE R1, #0      // Cargo un 0
    STRNE R1, [R6]    // en el control de estado. 

    // Verifica el estado del bit correspondiente a la tecla cancelar
    TST R0,#BC_MASK
    IT    NE                   
    BLNE  rebote      // Llamar a rutina antirebote
    // Si la tecla esta apretada
    TST R0,#BC_MASK
    ITT NE            
    MOVNE R1, #1     // Cargo un 1
    STRNE R1, [R6]   // en el control de estado. 

    B main

    .pool       // Almacenar las constantes de código
    .endfunc

    /****************************************************************************/
    /* Rutina de espera para evitar el efecto rebote de las teclas              */
    /****************************************************************************/
    .func rebote
rebote:
    PUSH {R4}               // Guardar registros en la pila
    LDR R4, =10000000            // Valor para un breve retardo
rebote_lazo:
    SUBS R4, R4, #1             // Decrementar el contador
    BNE rebote_lazo             // Esperar hasta que llegue a 0
    POP {R4}                // Restaurar registros
    BX LR                       // Retornar
    .pool
    .endfunc

    /****************************************************************************/
    /* Rutina de servicio para la interrupcion del timer                        */
    /****************************************************************************/
    .func timer_isr
timer_isr:
    PUSH {R4, R5, R6}
    // Limpio el flag de interrupcion
    LDR R1,=TIMER2_BASE
    LDR R0,[R1,#IR]           // Cargo en R0 el timer interrupt register
    STR R0,[R1,#IR]           // Limpio los flags de IR
    
    LDR R5,=control_estados
    LDR R6, [R5]
    CMP R6, #0
    IT EQ
    BEQ PWM
    
    LDR R12, =control_factor  
    LDR R4, [R12]             //Valor a decrementar o incrementar
    //
    MOV R2, #0
    STR R2, [R12]

    LDR R12, =variables       
    LDR R2, [R12, #periodo]   
    SUB R2, #10                //Valor maximo de factor, 224 - 10

    LDR R3, [R12, #factor]    
    ADD R3, R4                //factor actual + control factor que depende de que tecla este apretada, puede ser +4, -4 o 0 respectivamente

    CMP R3, #10               //Comparo con 10
    IT LO                     //Si es 0 o -10
    MOVLO R3, R2              //Vuelvo a empezar desde el valor maximo

    CMP R3, R2                //Comparo con el valor maximo
    IT HI                     //Si es mayor
    MOVHI R3, #10             //Vuelvo a empezar desde el valor minimo

    STR R3, [R12, #factor]    //Cargo el nuevo valor del factor

PWM:
    // Cargo el factor de trabajo
    LDR R12,=variables
    LDR R2,[R12,#factor]

    // Determino si el punto esta encendido o apagado
    LDR R0,[R1,#EMR]
    TST R0,#(1 << 1)

    ITTE EQ
    // Si esta apagado se utiliza periodo menos el factor de trabajo
    LDREQ R3,[R12,#periodo]
    SUBEQ R3,R2
    // Si esta encendido se utiliza el factor de trabajo
    MOVNE R3,R2

    // Se actualiza el valor de match para la siguiente interrupcion
    LDR R0,[R1,#MR1]
    ADD R0,R3
    STR R0,[R1,#MR1]
end:
    POP {R4, R5, R6}
    // Retorno
    BX  LR

    .pool                   // Almacenar las constantes de código
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

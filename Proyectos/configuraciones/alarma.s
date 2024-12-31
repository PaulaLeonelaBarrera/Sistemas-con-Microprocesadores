    .cpu cortex-m4          // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Declaraciones de macros para acceso simbolico a los recursos             */
/****************************************************************************/

	// Recursos utilizados por el primer segmento
    .equ SA_PORT,	4
    .equ SA_PIN,	0
    .equ SA_BIT,	0
    .equ SA_MASK,	(1 << SA_BIT)

	// Recursos utilizados por el segundo segmento
    .equ SB_PORT,	4
    .equ SB_PIN,	1
    .equ SB_BIT,	1
    .equ SB_MASK,	(1 << SB_BIT)

	// Recursos utilizados por el tercer segmento
    .equ SC_PORT,	4
    .equ SC_PIN,	2
    .equ SC_BIT,	2
    .equ SC_MASK,	(1 << SC_BIT)

	// Recursos utilizados por el cuatro segmento
    .equ SD_PORT,	4
    .equ SD_PIN,	3
    .equ SD_BIT,	3
    .equ SD_MASK,	(1 << SD_BIT)

	// Recursos utilizados por el quint segmento
    .equ SE_PORT,	4
    .equ SE_PIN,	4
    .equ SE_BIT,	4
    .equ SE_MASK,	(1 << SE_BIT)

	// Recursos utilizados por el sexto segmento
    .equ SF_PORT,	4
    .equ SF_PIN,	5
    .equ SF_BIT,	5
    .equ SF_MASK,	(1 << SF_BIT)

	// Recursos utilizados por el septimo segmento
    .equ SG_PORT,	4
    .equ SG_PIN,	6
    .equ SG_BIT,	6
    .equ SG_MASK,	(1 << SG_BIT)

	// Recursos utilizados por los segmentos en general
    .equ SEG_GPIO,	2
    .equ SEG_MASK,	( SA_MASK | SB_MASK | SC_MASK | SD_MASK | SE_MASK | SF_MASK | SG_MASK )

	// Recursos utilizados por el primer digito
    .equ D1_PORT,	0
    .equ D1_PIN,	0
    .equ D1_BIT,	0
    .equ D1_MASK,	(1 << D1_BIT)

	// Recursos utilizados por el segundo digito
    .equ D2_PORT,	0
    .equ D2_PIN,	1
    .equ D2_BIT,	1
    .equ D2_MASK,	(1 << D2_BIT)

	// Recursos utilizados por el tercer digito
    .equ D3_PORT,	1
    .equ D3_PIN,	15
    .equ D3_BIT,	2
    .equ D3_MASK,	(1 << D3_BIT)

	// Recursos utilizados por el cuatro digito
    .equ D4_PORT,	1
    .equ D4_PIN,	17
    .equ D4_BIT,	3
    .equ D4_MASK,	(1 << D4_BIT)

	// Recursos utilizados por los digitos en general
    .equ DIG_GPIO,	0
    .equ DIG_MASK,	( D1_MASK | D2_MASK | D3_MASK | D4_MASK)

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
    .equ BA_PIN,	1
    .equ BA_BIT,	8
    .equ BA_MASK,	(1 << BA_BIT)

	// Recursos utilizados por la tecla cancelar
    .equ BC_PORT,	3
    .equ BC_PIN,	2
    .equ BC_BIT,	9
    .equ BC_MASK,	(1 << BC_BIT)

    .equ BOT_GPIO,	5
    .equ BOT_MASK,	( B1_MASK | B2_MASK | B3_MASK | B4_MASK | BA_MASK | BC_MASK)

    .equ ET0,       0
    .equ ET1,       1
    .equ ET3,       3
    .equ ET4,       4
    .equ EF0,       24
    .equ ES0,       32
/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM)
    .align
teclas:                     
    .zero 4                 // Ultimo estado de las teclas
digito:
    .zero 1                 // Digito seleccionado actualmente
segmentos:                     
    .zero 4                 // Estado de los segmentos de los digitos

/****************************************************************************/
/* Función para la inicialización del hardware de la alarma                 */
/****************************************************************************/
    .section .text
    .func inicio
    .align 
inicio:
    // Configuración de los pines de segmentos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SA_PORT << 7 | SA_PIN << 2)]
    STR R0,[R1,#(SB_PORT << 7 | SB_PIN << 2)]
    STR R0,[R1,#(SC_PORT << 7 | SC_PIN << 2)]
    STR R0,[R1,#(SD_PORT << 7 | SD_PIN << 2)]
    STR R0,[R1,#(SE_PORT << 7 | SE_PIN << 2)]
    STR R0,[R1,#(SF_PORT << 7 | SF_PIN << 2)]
    STR R0,[R1,#(SG_PORT << 7 | SG_PIN << 2)]

    // Configuración de los pines de digitos como gpio sin pull-up
    STR R0,[R1,#(D1_PORT << 7 | D1_PIN << 2)]
    STR R0,[R1,#(D2_PORT << 7 | D2_PIN << 2)]
    STR R0,[R1,#(D3_PORT << 7 | D3_PIN << 2)]
    STR R0,[R1,#(D4_PORT << 7 | D4_PIN << 2)]

    // Configuración de los pines de teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(B1_PORT << 7 | B1_PIN << 2)]
    STR R0,[R1,#(B2_PORT << 7 | B2_PIN << 2)]
    STR R0,[R1,#(B3_PORT << 7 | B3_PIN << 2)]
    STR R0,[R1,#(B4_PORT << 7 | B4_PIN << 2)]
    STR R0,[R1,#(BA_PORT << 7 | BA_PIN << 2)]
    STR R0,[R1,#(BC_PORT << 7 | BC_PIN << 2)]

    // Apagado de todos los bits gpio de los segmentos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    // Apagado de todos bits gpio de los digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#(DIG_GPIO << 2)]

    // Configuración de los bits gpio de segmentos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(SEG_GPIO << 2)]
    ORR R0,#SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    // Configuración de los bits gpio de digitos como salidas
    LDR R0,[R1,#(SEG_GPIO << 2)]
    ORR R0,#DIG_MASK
    STR R0,[R1,#(DIG_GPIO << 2)]

    // Configuración los bits gpio de botones como entradas
    LDR R0,[R1,#(BOT_GPIO << 2)]
    AND R0,#~BOT_MASK
    STR R0,[R1,#(BOT_GPIO << 2)]	

    LDR R0,=systick_init+1
    BX  R0

    .pool
    .endfunc

/****************************************************************************/
/* Rutina de inicialización del SysTick                                     */
/****************************************************************************/
    .func systick_init
systick_init: 
    CPSID I                 // Deshabilita interrupciones

    // Configurar prioridad de la interrupcion
    LDR R1,=SHPR3           // Apunta al registro de prioridades
    LDR R0,[R1]             // Carga las prioridades actuales
    MOV R2,#2               // Fija la prioridad en 2
    BFI R0,R2,#29,#3        // Inserta el valor en el campo 
    STR R0,[R1]             // Actualiza las prioridades

    // Habilitar el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR    
    MOV R0,#0x00
    STR R0,[R1]             // Quita ENABLE

    // Configurar el desborde para un periodo de 100 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(480000 - 1)
    STR R0,[R1]             // Especifica valor RELOAD

    // Inicializar el valor actual del contador
    // Escribir cualquier valor limpia el contador
    LDR R1,=SYST_CVR 
    MOV R0,#0
    STR R0,[R1]             // Limpia COUNTER y flag COUNT
    
    // Habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR    
    MOV R0,#0x07
    STR R0,[R1]             // Fija ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                 // Rehabilita interrupciones
    BX  LR                  // Retorna al programa principal
    .pool                   // Almacena las constantes de código
    .endfunc

/****************************************************************************/
/* Rutina de servicio para la interrupcion del timer                        */
/****************************************************************************/
    .func refresco
refresco:
    // Limpio el flag de interrupcion
    LDR R0,=TIMER0_BASE
    LDR R1,[R0,#IR]
    STR R1,[R0,#IR]

    LDR R0,=GPIO_CLR0
    LDR R1,=DIG_MASK
    STR R1,[R0, #(DIG_GPIO << 2)]
    LDR R1,=SEG_MASK
    STR R1,[R0, #(SEG_GPIO << 2)]

    MOV  R0,#100
delay:
    SUBS R0,#1
    BNE  delay

    LDR  R0,=segmentos
    LDRB R1,[R0]
    ADD  R1,#1
    AND  R1,#0x03
    STRB R1,[R0],#1
    LDRB R2,[R0, R1]
    LDR  R0,=digitos
    LDRB R3,[R0, R1]

    LDR R0,=GPIO_SET0
    STR R2,[R0, #(SEG_GPIO << 2)]
    STR R3,[R0, #(DIG_GPIO << 2)]

    // Retorno
    BX  LR

    .pool                   // Almacenar las constantes de código

digitos:
    .byte D1_MASK, D2_MASK, D3_MASK, D4_MASK

    .endfunc

/****************************************************************************/
/* Función para el escaneo de entradas del sistema de alarma                */
/* Emula los valores de retorno usando el poncho multiproposito             */
/****************************************************************************/
    .func escaneo
escaneo:
    PUSH  {R4,R5,R6}
    // Inicializa los registros de resultado
    MOV   R0,#0xFF

    // Carga en R2 del estado actual de las teclas
    LDR   R4,=GPIO_PIN0
    LDR   R2,[R4,#(BOT_GPIO << 2)]
    AND   R2,#BOT_MASK

    // Carga en R3 del estado anterior de las teclas
    LDR   R4,=teclas
    LDR   R3,[R4]

    // Carga en R5 de los cambios en las teclas 
    EOR   R5,R2,R3

    // Detección de un cambio en la primera tecla
    ANDS  R6,R5,#B1_MASK
    ITTT  NE
    EORNE R3,#B1_MASK
    MOVNE R1,#ET0
    BNE   terminar

    // Detección de un cambio en la segunda tecla
    ANDS  R6,R5,#B2_MASK
    ITTT  NE
    EORNE R3,#B2_MASK
    MOVNE R1,#ET1
    BNE   terminar

    // Detección de un cambio en la tercera tecla
    ANDS  R6,R5,#B3_MASK
    ITTT  NE
    EORNE R3,#B3_MASK
    MOVNE R1,#ET3
    BNE   terminar

    // Detección de un cambio en la cuarta tecla
    ANDS  R6,R5,#B4_MASK
    ITTT  NE
    EORNE R3,#B4_MASK
    MOVNE R1,#ET4
    BNE   terminar

    // Detección de un cambio en la cuarta tecla
    ANDS  R6,R5,#BA_MASK
    ITTT  NE
    EORNE R3,#BA_MASK
    MOVNE R1,#EF0
    BNE   terminar

    // Detección de un cambio en la cuarta tecla
    ANDS  R6,R5,#BC_MASK
    ITTT  NE
    EORNE R3,#BC_MASK
    MOVNE R1,#ES0
    BNE   terminar

    MOV   R0,#0x00

terminar:
    STR   R3,[R4]
    POP   {R4,R5,R6}
    BX    LR
    .pool
    .endfunc

/****************************************************************************/
/* Función para el escaneo de entradas del sistema de alarma                */
/* Emula los valores de retorno usando el poncho multiproposito             */
/****************************************************************************/
    .func enviar
enviar:
	CMP R0,#3
    BHI final
    LDR R2,=segmentos+1
    STR R1,[R2, R0]
final:
    BX  LR
    .pool
    .endfunc

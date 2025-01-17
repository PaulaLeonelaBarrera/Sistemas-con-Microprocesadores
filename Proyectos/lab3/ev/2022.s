/*1) 90 Minutos - 30, 40, 15, 15 Puntos
Escriba un programa en lenguaje ensamblador del ARM-Cortex M4 para implementar un temporizador 
descendente que muestre una cuenta regresiva en los displays de 7 segmentos. La cuenta regresiva 
iniciará desde en un valor establecido por el usuario, tendrá una precisión de 1 décima de segundo 
y debe detenerse al llegar a cero.
a) Implemente un programa que permita establecer el valor de inicio de la cuenta regresiva
con una precisión de un segundo. El valor debe mostrarse en los displays de 7 segmentos,
usando el Display 2 y el Display 3, para unidades y decenas de segundos, respectivamente. 
El Display 1 permancerá en cero y quedará reservado para las décimas de segundos, que se 
mostrarán durante la cuenta regresiva. Al iniciar el programa, los displays deben mostar el valor cero, 
y al presionar la tecla F1 aumentar el valor en una unidad, mientras que al presionar la tecla F2 el valor 
debe disminuir una unidad.
b) Modifique el programa anterior para que al presionar la tecla Aceptar inicie la cuenta
regresiva. La cuenta tendrá una precisión de una décima de segundo y debe utilizar la
interrupción Systick para la medición del tiempo. La cuenta debe detenerse al llegar a cero.
c) Modifique el código para que, si el usuario presiona la tecla Cancelar, la cuenta regresiva
se detenga. Al presionar la tecla Aceptar la cuenta regresiva debe continuar normalmente.
d) Modifique el programa para que, si mantiene presionada la tecla Cancelar durante 3 segundos o más, 
el contador vuelva a cero y quede detenido. */
    .cpu cortex-m4  // Indica el procesador de destino
    .syntax unified // Habilita las instrucciones Thumb-2
    .thumb          // Usar instrucciones Thumb y no ARM
    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos utilizados por el primer dígito
    .equ DIG_1_PORT, 0
    .equ DIG_1_PIN, 0
    .equ DIG_1_BIT, 0
    .equ DIG_1_MASK, (1 << DIG_1_BIT)

// Recursos utilizados por el segundo dígito
    .equ DIG_2_PORT, 0
    .equ DIG_2_PIN, 1
    .equ DIG_2_BIT, 1
    .equ DIG_2_MASK, (1 << DIG_2_BIT)

// Recursos utilizados por el tercer dígito
    .equ DIG_3_PORT, 1
    .equ DIG_3_PIN, 15
    .equ DIG_3_BIT, 2
    .equ DIG_3_MASK, (1 << DIG_3_BIT)

// Recursos utilizados por el cuarto dígito
    .equ DIG_4_PORT, 1
    .equ DIG_4_PIN, 17
    .equ DIG_4_BIT, 3
    .equ DIG_4_MASK, (1 << DIG_4_BIT)

// Recursos utilizados por los digitos
    .equ DIG_GPIO, 0
    .equ DIG_OFFSET, ( DIG_GPIO << 2)
    .equ DIG_MASK, ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK)

//Recusos utilizados por el punto
    .equ SEG_DP_PORT, 6
    .equ SEG_DP_PIN, 8
    .equ SEG_DP_BIT, 16
    .equ SEG_DP_MASK, (1 << SEG_DP_BIT)
    .equ SEG_DP_GPIO, 5
    .equ SEG_DP_OFFSET, ( SEG_DP_GPIO << 2)

//Recursos utilizados por el segmento a
    .equ SEG_A_PORT, 4
    .equ SEG_A_PIN, 0
    .equ SEG_A_BIT, 0
    .equ SEG_A_MASK, (1 << SEG_A_BIT)

//Recursos utilizados por el segmento b
    .equ SEG_B_PORT, 4
    .equ SEG_B_PIN, 1
    .equ SEG_B_BIT, 1
    .equ SEG_B_MASK, (1 << SEG_B_BIT)

//Recursos utilizados por el segmento c
    .equ SEG_C_PORT, 4
    .equ SEG_C_PIN, 2
    .equ SEG_C_BIT, 2
    .equ SEG_C_MASK, (1 << SEG_C_BIT)

//Recursos utilizados por el segmento d
    .equ SEG_D_PORT, 4
    .equ SEG_D_PIN, 3
    .equ SEG_D_BIT, 3
    .equ SEG_D_MASK, (1 << SEG_D_BIT)

//Recursos utilizados por el segmento e
    .equ SEG_E_PORT, 4
    .equ SEG_E_PIN, 4
    .equ SEG_E_BIT, 4
    .equ SEG_E_MASK, (1 << SEG_E_BIT)

//Recursos utilizados por el segmento f
    .equ SEG_F_PORT, 4
    .equ SEG_F_PIN, 5
    .equ SEG_F_BIT, 5
    .equ SEG_F_MASK, (1 << SEG_F_BIT)

//Recursos utilizados por el segmento g
    .equ SEG_G_PORT, 4
    .equ SEG_G_PIN, 6
    .equ SEG_G_BIT, 6
    .equ SEG_G_MASK, (1 << SEG_G_BIT)

// Recursos utilizados por los SEGMENTOS
    .equ SEG_GPIO, 2
    .equ SEG_OFFSET, ( SEG_GPIO << 2)
    .equ SEG_MASK, ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )

// Recursos utilizados por tecla 1
    .equ TEC_1_PORT, 4
    .equ TEC_1_PIN, 8
    .equ TEC_1_BIT, 12
    .equ TEC_1_MASK, (1 << TEC_1_BIT)

// Recursos utilizados por tecla 2
    .equ TEC_2_PORT, 4
    .equ TEC_2_PIN, 9
    .equ TEC_2_BIT, 13
    .equ TEC_2_MASK, (1 << TEC_2_BIT)

// Recursos utilizados por tecla 3
    .equ TEC_3_PORT, 4
    .equ TEC_3_PIN, 10
    .equ TEC_3_BIT, 14
    .equ TEC_3_MASK, (1 << TEC_3_BIT)

// Recursos utilizados por tecla 4
    .equ TEC_4_PORT, 6
    .equ TEC_4_PIN, 7
    .equ TEC_4_BIT, 15
    .equ TEC_4_MASK, (1 << TEC_4_BIT)

//Recursos utilizador por la tecla aceptar
    .equ TEC_AC_PORT, 3
    .equ TEC_AC_PIN, 2
    .equ TEC_AC_BIT, 9
    .equ TEC_AC_MASK, (1 << TEC_AC_BIT)

// Recursos utilizados por tecla de cancelar
    .equ TEC_CN_PORT, 3
    .equ TEC_CN_PIN, 1
    .equ TEC_CN_BIT, 8
    .equ TEC_CN_MASK, (1 << TEC_CN_BIT)

// Recursos utilizados por el teclado
    .equ TEC_GPIO, 5
    .equ TEC_OFFSET, ( TEC_GPIO << 2)
    .equ TEC_MASK, ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK | TEC_4_MASK | TEC_AC_MASK | TEC_CN_MASK)


/****************************************************************************/
/*              Vector de interrupciones                                    */
/****************************************************************************/
    .section .isr   // Define una seccion especial para el vector
    .word stack     // 0: Initial stack pointer value
    .word reset+1   // 1: Initial program counter value
    .word handler+1 // 2: Non mascarable interrupt service routine
    .word handler+1 // 3: Hard fault system trap service routine
    .word handler+1 // 4: Memory manager system trap service routine
    .word handler+1 // 5: Bus fault system trap service routine
    .word handler+1 // 6: Usage fault system tram service routine
    .word 0         // 7: Reserved entry
    .word 0         // 8: Reserved entry
    .word 0         // 9: Reserved entry
    .word 0         // 10: Reserved entry
    .word handler+1 // 11: System service call trap service routine
    .word 0         // 12: Reserved entry
    .word 0         // 13: Reserved entry
    .word handler+1 // 14: Pending service system trap service routine
    .word systick_isr+1 // 15: System tick service routine
    .word handler+1 // 16: Interrupt IRQ service routine

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data  // Define la seccion de variables (RAM)

espera:        .byte 100
cont_refresco: .byte 0      //Contador de refrescos
bandera:       .byte 0    
tiempo:        .byte 0,0,0
espacio:       .space 1
tmp_tec:       .hword 0     //Contador para espera de teclas

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset   // Define el punto de entrada del codigo
    .section .text  // Define la seccion de codigo (FLASH)
    .func main      // Inidica al depurador el inicio de una funcion

reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]
    // Llama a una subrutina para configurar las teclas
    BL config_tec
    // Llama a una subrutina para configurar los segmentos y digitos
    BL config_dig
    BL config_seg 
    // Llama a una subrutina para configurar el systick
    BL systick_init

stop:   B stop

.endfunc

tabla: .byte 0x3F,0x06,0x5b,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x67

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
.func systick_isr
systick_isr:
    PUSH {LR}
    BL teclas
    BL actualizar_reloj
    BL refresco 
    POP {PC} // Se retorna al programa principal
    .pool // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
.func refresco
refresco:
    PUSH {LR} 
    BL apagar_digitos
    LDR R1,=cont_refresco   //R1 = direccion contador refresco      
    LDRB R2,[R1]            //R2 = valor contador refresco
    ADD R2,#1               //R2 ++
    CMP R2,#4       
    IT EQ                   //Si R2 llega a 4
    MOVEQ R2,#1             //R2 vuelve a 1
    STRB R2,[R1]            //Guardo el contador de refrescos
    BL prender_segmento     //Rutina para prender el segmento
    BL prender_digito       //Rutina para prender el digito
    POP {PC}                // Se retorna al programa principal
.endfunc

/************************************************************************************/
/* Rutina de prendido de digitos                                                    */
/************************************************************************************/
.func prender_digito
prender_digito:
    LDR R4,=GPIO_PIN0       //Registro para ver el estado de las salidas
    LDR R0,=cont_refresco   //R0 = direccion contador de refrescos
    LDRB R1,[R0]            //R1 = valor cont_ref
    CMP R1,#1           
    IT EQ                   //Si refresco = 1
    MOVEQ R2,#DIG_1_MASK    //Se prende el digito 1 (guardo su mascara en R2)
    CMP R1,#2
    IT EQ                   //Si Refresco = 2
    MOVEQ R2,#DIG_2_MASK    //Se prende el digito 2 (guardo su mascara en R2)
    CMP R1,#3
    IT EQ
    MOVEQ R2,#DIG_3_MASK
    STR R2,[R4,#DIG_OFFSET] //Guardo mascara de digito en pin0+dig_offset
    BX LR
.endfunc

/************************************************************************************/
/* Rutina de prendido de segmentos                                                  */
/************************************************************************************/
.func prender_segmento
prender_segmento:
    PUSH {LR}
    LDR R5,=GPIO_CLR0
    LDR R4,=GPIO_PIN0       //Registro para ver el estado de las salidas
    LDR R0,=cont_refresco
    LDRB R1,[R0]            //R1 = contador de refresco
    CMP R1,#1
    ITT EQ                  //Si refresco = 1
    LDREQ R0,=tiempo        //R0 = direccion de tiempo
    LDRBEQ R0,[R0]          //R0 = decima de segundo
    CMP R1,#2               //Si refresco = 2
    ITT EQ
    LDREQ R0,=tiempo
    LDRBEQ R0,[R0,#1]
    //Para prender punto o apagar si no es el digito correspondiente
    ITTEE EQ
    MOVEQ R3,#SEG_DP_MASK
    STREQ R3,[R4,#SEG_DP_OFFSET]
    MOVNE R3,#SEG_DP_MASK
    STRNE R3,[R5,#SEG_DP_OFFSET]
    CMP R1,#3               //Si refresco = 3
    ITT EQ
    LDREQ R0,=tiempo
    LDRBEQ R0,[R0,#2]
    BL segmentos            //Convierto de BCD a 7 seg 
    STR R3,[R4,#SEG_OFFSET] //Guardo en pin0+seg_offset el nro en 7seg
    POP {PC}
.endfunc

/************************************************************************************/
.func teclas
teclas:
    PUSH {LR} 
    LDR R0,=GPIO_PIN0           
    LDR R1,[R0,#TEC_OFFSET]     //R1 = estado de teclas
    TST R1,#TEC_1_MASK
    IT NE                       //Si tecla apretada = tecla F1
    BLNE tecla_1                //Subrutina para tecla F1
    TST R1,#TEC_2_MASK
    IT NE                       //Si tecla apretada = tecla F2
    BLNE tecla_2                //Subrutina para tecla F2
    TST R1,#TEC_AC_MASK
    IT NE                       //Si tecla apretada = tecla acpetar
    BLNE tecla_aceptar          //Subrutina para tecla aceptar
    TST R1,#TEC_CN_MASK
    IT NE                       //Si tecla apretada = tecla acpetar
    BLNE tecla_cancelar         //Subrutina para tecla aceptar
    POP {PC} // Se retorna al programa principal
.endfunc

/************************************************************************************/
.func tecla_aceptar
tecla_aceptar:
    LDR R0,=bandera     //R0 = direccion de bandera para activar y desactivar cuenta
    MOV R1,#1
    STRB R1,[R0]
    BX LR // Se retorna al programa principal
.endfunc

/************************************************************************************/
.func tecla_cancelar
tecla_cancelar:
    LDR R2,=bandera     //R2 = direccion de bandera para activar y desactivar cuenta
    MOV R3,#0
    STRB R2,[R2]
    LDR R0,=tmp_tec     //R0 = direccion de tmp_tec
    LDRH R1,[R0]        //R1 = valor de tmp_tec
    ADD R1,#1           //tmp_tec +1
    LDR R5,=3000
    CMP R1,R5
    ITE EQ              //Si tmp_tec = 3000
    LDRHEQ R1,=0        //Reseteo tmp_tec = 0       
    BNE fin_tecla_ac    //Si no es 3000, salgo
    LDR R2,=tiempo
    LDR R3,=0
    STR R3,[R2]
fin_tecla_ac:
    STRH R1,[R0]
    BX LR // Se retorna al programa principal
.endfunc

/************************************************************************************/
.func tecla_1
tecla_1:
    PUSH {R1}
    LDR R0,=tmp_tec     //R0 = direccion de tmp_tec
    LDRH R1,[R0]        //R1 = valor de tmp_tec
    ADD R1,#1           //tmp_tec +1
    CMP R1,#400
    ITE EQ              //Si tmp_tec = 400
    LDRHEQ R1,=0        //Reseteo tmp_tec = 0       
    BNE fin_tecla_1     //Si no es 400, salgo
    LDR R2,=tiempo
    LDRB R3,[R2,#1]     //R3 = unidad segundos
    LDRB R4,[R2,#2]     //R4 = decena segundos
    ADD R3,#1
    CMP R3,#10
    ITT EQ
    MOVEQ R3,#0
    ADDEQ R4,#1
    STRB R3,[R2,#1]
    STRB R4,[R2,#2]
fin_tecla_1:
    STRH R1,[R0]
    POP {R1}
    BX LR
.endfunc

/************************************************************************************/
.func tecla_2
tecla_2:
    PUSH {R1}
    LDR R0,=tmp_tec     //R0 = direccion de tmp_tec
    LDRH R1,[R0]        //R1 = valor de tmp_tec
    ADD R1,#1           //tmp_tec +1
    CMP R1,#400
    ITE EQ              //Si tmp_tec = 400
    LDRHEQ R1,=0        //Reseteo tmp_tec = 0       
    BNE fin_tecla_2     //Si no es 400, salgo
    LDR R2,=tiempo
    LDRB R3,[R2,#1]     //R3 = unidad segundos
    LDRB R4,[R2,#2]     //R4 = decena segundos
    SUB R3,#1
    CMP R3,#-1
    ITT EQ
    MOVEQ R3,#9
    SUBEQ R4,#1
    STRB R3,[R2,#1]
    STRB R4,[R2,#2]
fin_tecla_2:
    STRH R1,[R0]
    POP {R1}
    BX LR
.endfunc

/************************************************************************************/
/* Rutina de actualizacion de reloj                                                 */
/************************************************************************************/
.func actualizar_reloj
actualizar_reloj:
    PUSH {LR}
    LDR R2,=espera          //R2 = direccion espera
    LDRB R3,[R2]            //R3 = valor espera
    SUB R3,#1               //R3 -1
    CMP R3,#0
    ITT MI                //Si R3 <0
    MOVMI R3,#100           //Seteo espera en 100 de nuevo
    BLMI decremento_dseg    //rutina resta de 0,1s
    STRB R3,[R2]
    POP {PC}
.endfunc

/************************************************************************************/
/* Rutina de decrementar 0,1s                                                       */
/************************************************************************************/
.func decremento_dseg
decremento_dseg:
    PUSH {LR}
    PUSH {R2,R3}
    LDR R0,=tiempo          
    LDRB R1,[R0]            //R1 = valor decima de seg
    LDR R2,=bandera
    LDRB R2,[R2]            //R2 = bandera
    TST R2, #1              
    IT NE                   //Si bandera = 1
    SUBNE R1,#1             //tiempo - 0,1
    CMP R1,#0
    ITT MI                   //Si decima de seg es negativ
    MOVMI R1,#9
    BLMI decremento_seg     //Voy a funcion que resta un segundo
    STRB R1,[R0]
    POP {R2,R3}
    POP {PC}
.endfunc

/************************************************************************************/
/* Rutina de decremento de segundos                                                 */
/************************************************************************************/
.func decremento_seg
decremento_seg:
    PUSH {LR}
    LDRH R2,[R0,#1]     //R2 = segundos
    CMP R2,#0          
    ITT EQ              //Si seg=00
    MOVEQ R1,#0         //decima de seg = 0
    BLEQ flag_dis       //Bandera = 0 
    BEQ fin_decremento  //Termina
    LDRB R2,[R0,#1]     //R2 = unidad de seg
    LDRB R3,[R0,#2]     //R3 = decena de seg
    SUB R2,#1           //R2 -1
    CMP R2,#0
    ITT MI              //Si R2<0
    MOVMI R2,#9         //Unidad = 9
    SUBMI R3,#1         //Decena -1
    STRB R2,[R0,#1]
    STRB R3,[R0,#2]
fin_decremento:
    POP {PC}
.endfunc

/************************************************************************************/
/* Rutina de dejar de contar (bandera=0)                                            */
/************************************************************************************/
.func flag_dis
flag_dis:
    PUSH {R0,R1}
    LDR R0,=bandera
    MOV R1,#0
    STRB R1,[R0]
    POP {R0,R1}
    BX LR
.endfunc


/************************************************************************************/
/* Rutina de inicializacion del SysTick                                             */
/************************************************************************************/
.func systick_init
systick_init:
    CPSID I             // Se deshabilitan globalmente las interrupciones
    // Se Configura prioridad de la interrupcion
    LDR R1,=SHPR3       // Se apunta al registro de prioridades
    LDR R0,[R1]         // Se cargan las prioridades actuales
    MOV R2,#2           // Se fija la prioridad en 2
    BFI R0,R2,#29,#3    // Se inserta el valor en el campo
    STR R0,[R1]         // Se actualizan las prioridades
    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]         // Se quita el bit ENABLE
    // Se configura el desborde para un periodo de 1 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(48000 - 1)
    STR R0,[R1]         // Se especifica el valor de RELOAD
    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    // Escribir cualquier valor limpia el contador
    STR R0,[R1]         // Se limpia COUNTER y flag COUNT
    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1]         // Se fijan ENABLE, TICKINT y CLOCK_SRC
    CPSIE I             // Se habilitan globalmente las interrupciones
    BX LR               // Se retorna al programa principal
    .pool               // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
/* Rutina de apagado de digitos                                                     */
/************************************************************************************/
.func apagar_digitos
apagar_digitos:
    LDR R0,=GPIO_CLR0
    LDR R1,=DIG_MASK
    STR R1,[R0,#DIG_OFFSET]
    BX LR
.endfunc

/************************************************************************************/
/* Rutina de inicializacion de segmentos                                            */
/************************************************************************************/
.func config_seg
config_seg:
    // Se configuran los pines de los segmentos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]
    //Punto tiene diferente funcion
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]
    // Apaga todos los bits gpio de los seg
    LDR R1,=GPIO_CLR0           //Apunto al registro de CLR0
    LDR R0,=SEG_MASK            //Cargo la máscara 
    STR R0,[R1,#SEG_OFFSET] 
    LDR R0,=SEG_DP_MASK
    STR R0,[R1,#SEG_DP_OFFSET]
    // Configura los SEG como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,#SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    LDR R0,[R1,#SEG_DP_OFFSET]
    ORR R0,#SEG_DP_MASK
    STR R0,[R1,#SEG_DP_OFFSET]
    BX LR     // Se retorna al programa principal
    .pool     // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
/* Rutina de inicializacion de DIGITOS                                              */
/************************************************************************************/
.func config_dig
config_dig:
    PUSH {LR}
    //Configura los digitos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]
    //Apaga los digitos
    BL apagar_digitos
    //Configuro los digitos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK            //salida si DIR=1 y entrada si DIR=0 por eso OR
    STR R0,[R1,#DIG_OFFSET]
    POP {PC}        // Se retorna al programa principal
    .pool           // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
/* Rutina de inicializacion de teclas                                               */
/************************************************************************************/
.func config_tec
config_tec:
    PUSH {LR}
    //Configura los digitos como gpio sin pull-up
    LDR R1,=SCU_BASE
    // Configura los pines de las teclas como gpio con pull-UP
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS |SCU_MODE_FUNC4)
    STR R0,[R1,#(TEC_1_PORT << 7 | TEC_1_PIN << 2)]
    STR R0,[R1,#(TEC_2_PORT << 7 | TEC_2_PIN << 2)]
    STR R0,[R1,#(TEC_3_PORT << 7 | TEC_3_PIN << 2)]
    STR R0,[R1,#(TEC_4_PORT << 7 | TEC_4_PIN << 2)]
    STR R0,[R1,#(TEC_AC_PORT << 7 | TEC_AC_PIN << 2)]
    STR R0,[R1,#(TEC_CN_PORT << 7 | TEC_CN_PIN << 2)]
    // Configura las teclas como entradas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#TEC_OFFSET]
    BIC R0,#TEC_MASK
    STR R0,[R1,#TEC_OFFSET]
    POP {PC}        // Se retorna al programa principal
    .pool           // Se almacenan las constantes de codigo
.endfunc

/************************************************************************************/
/* Rutina de conversion BCD a 7segmentos                                            */
/************************************************************************************/
.func segmentos
segmentos: 
    LDR R3,=tabla     
    LDRB R3,[R3,R0]             //Carga en R3 el digito en 7 seg
    BX LR
.endfunc

/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.          */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/

.func handler
handler:
    LDR R1,=GPIO_SET0       // Se apunta a la base de registros SET
    MOV R0,#DIG_1_MASK      // Se carga la mascara para el LED 1
    STR R0,[R1,#DIG_OFFSET] // Se activa el bit GPIO del LED 1
    B handler               // Lazo infinito para detener la ejecucion
    .pool                   // Se almacenan las constantes de codigo
.endfunc
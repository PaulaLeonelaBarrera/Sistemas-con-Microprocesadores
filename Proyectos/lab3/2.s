/* Copyright 2016-2020, Laboratorio de Microprocesadores 
 * Facultad de Ciencias Exactas y Tecnología 
 * Universidad Nacional de Tucuman
 * http://www.microprocesadores.unt.edu.ar/
 * Copyright 2016-2020, Esteban Volentini <evolentini@herrera.unt.edu.ar>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

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
// Recursos utilizados por el primer boton
    .equ BOT_1_PORT,    4
    .equ BOT_1_PIN,     8
    .equ BOT_1_BIT,     12
    .equ BOT_1_MASK,    (1 << BOT_1_BIT)

// Recursos utilizados por el segundo boton
    .equ BOT_2_PORT,    4
    .equ BOT_2_PIN,     9
    .equ BOT_2_BIT,     13
    .equ BOT_2_MASK,    (1 << BOT_2_BIT)

// Recursos utilizados por el tercer boton
    .equ BOT_3_PORT,    4
    .equ BOT_3_PIN,     10
    .equ BOT_3_BIT,     14
    .equ BOT_3_MASK,    (1 << BOT_3_BIT)

// Recursos utilizados por el cuarto boton
    .equ BOT_4_PORT,    6
    .equ BOT_4_PIN,     7
    .equ BOT_4_BIT,     15
    .equ BOT_4_MASK,    (1 << BOT_4_BIT)

// Recursos utilizados por los botones
    .equ BOT_GPIO,      5
    .equ BOT_OFFSET,    ( BOT_GPIO << 2)
    .equ BOT_MASK,      ( BOT_1_MASK | BOT_2_MASK | BOT_3_MASK | BOT_4_MASK )

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la seccion de variables (RAM)
espera:
    .zero 1                 // Variable compartida con el tiempo de espera

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del codigo
    .section .text          // Define la seccion de codigo (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
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

    // Se configuran los pines de los digitos 1 al 4 como gpio sin pull-up
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]

    // Configura los pines de los botones como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#((BOT_1_PORT << 5 | BOT_1_PIN) << 2)]
    STR R0,[R1,#((BOT_2_PORT << 5 | BOT_2_PIN) << 2)]
    STR R0,[R1,#((BOT_3_PORT << 5 | BOT_3_PIN) << 2)]
    STR R0,[R1,#((BOT_4_PORT << 5 | BOT_4_PIN) << 2)]

    // Apaga todos los bits gpio de los segmentos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]
    // Se apagan los bits gpio correspondientes a los digitos 
    LDR R0,=DIG_N_MASK
    STR R0,[R1,#DIG_N_OFFSET]

    // Configura los bits gpio de los segmentos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,#SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    // Se configuran los bits gpio de los digitos como salidas
    LDR R0,[R1,#DIG_N_OFFSET]
    ORR R0,#DIG_N_MASK
    STR R0,[R1,#DIG_N_OFFSET]

    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#BOT_OFFSET]
    BIC R0,#BOT_MASK
    STR R0,[R1,#BOT_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

refrescar:
    // Define el estado actual de los digitos como todos apagados
    MOV   R3,#0x00
    // Prende el digito 1
    LDR   R0,[R4,#DIG_N_OFFSET]
    ORR   R0,#1
    STR   R0,[R4,#DIG_N_OFFSET]   
    // Carga el estado actual de los botones
    LDR   R0,[R4,#BOT_OFFSET]

    // Verifica el estado del bit correspondiente al boton uno
    TST R0,#BOT_1_MASK
    // Si la tecla esta apretada
    IT NE
    // Enciende el bit del segmento B
    ORRNE R3,#SEG_B_MASK

    // Prende el segmento C si el boton dos esta apretado
    TST R0,#BOT_2_MASK
    IT    NE
    ORRNE R3,#SEG_C_MASK

    // Prende el segmento E si el boton tres esta apretado
    TST R0,#BOT_3_MASK
    IT    NE
    ORRNE R3,#SEG_E_MASK

    // Prende el segmento F si el boton cuatro esta apretado
    TST R0,#BOT_4_MASK
    IT    NE
    ORRNE R3,#SEG_F_MASK

    // Actualiza las salidas con el estado definido para los segmentos
    STR   R3,[R4,#SEG_OFFSET]

    // Repite el lazo de refresco indefinidamente
    B     refrescar
stop:
    B stop
    .pool                   // Almacenar las constantes de codigo
    .endfunc

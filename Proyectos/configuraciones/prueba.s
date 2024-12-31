/* Copyright 2016, Laboratorio de Microprocesadores 
 * Facultad de Ciencias Exactas y Tecnología 
 * Universidad Nacional de Tucuman
 * http://www.microprocesadores.unt.edu.ar/
 * Copyright 2016, Esteban Volentini <evolentini@gmail.com>
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

    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

    .include "configuraciones/rutinas.s"
    .include "configuraciones/lpc4337.s"

    .section .text              // Define la sección de código (FLASH)
    .global reset               // Define el punto de entrada del código

reset:   
    LDR R4,=leds_init
    BLX R4

    LDR R4,=set_led_r
    BLX R4
    LDR R4,=clear_led_r
    BLX R4
    LDR R4,=toggle_led_r
    BLX R4
    LDR R4,=clear_led_r
    BLX R4

    LDR R4,=set_led_g
    BLX R4
    LDR R4,=clear_led_g
    BLX R4
    LDR R4,=toggle_led_g
    BLX R4
    LDR R4,=clear_led_g
    BLX R4

    LDR R4,=set_led_b
    BLX R4
    LDR R4,=clear_led_b
    BLX R4
    LDR R4,=toggle_led_b
    BLX R4
    LDR R4,=clear_led_b
    BLX R4

    LDR R4,=set_led_1
    BLX R4
    LDR R4,=clear_led_1
    BLX R4
    LDR R4,=toggle_led_1
    BLX R4
    LDR R4,=clear_led_1
    BLX R4

    LDR R4,=set_led_2
    BLX R4
    LDR R4,=clear_led_2
    BLX R4
    LDR R4,=toggle_led_2
    BLX R4
    LDR R4,=clear_led_2
    BLX R4

    LDR R4,=set_led_3
    BLX R4
    LDR R4,=clear_led_3
    BLX R4
    LDR R4,=toggle_led_3
    BLX R4
    LDR R4,=clear_led_3
    BLX R4
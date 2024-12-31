//Con directivas al ensamblador.
    
    .cpu cortex-m4
    .syntax unified
    .thumb

    .section .data

base:   .hword 4,1,1,1,1
        .align
        .section .text
    
    .global reset

    reset:  LDR R0,=base
            LDRH R1,[R0],#2
            MOV R3,#0x55
            //Creo el lazo para ir rellenando el vector
    lazo:   STRH R3,[R0],#2
            SUB R1,#1
            CMP R1,0x00
            BNE lazo
    stop:   B stop


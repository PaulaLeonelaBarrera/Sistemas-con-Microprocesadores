                .cpu cortex-m4
                .syntax unified
                .thumb
                .section .data

base:           .byte 0x06, 0x7A, 0x7B, 0x7C, 0x00 
                .align                           

                .section .text
                .global reset

reset:          LDR R0, =base                           //apunto a la base           

lazo:           LDRB R1, [R0], #1                        //cargo el primer numero o sea 0x06 en R1 e incremento R0
                MOV R3, #0                              //cargo 0 en R3 para usarlo como contador
                MOV R4, #0                              //R4 tendra la cantidad de 1's
                
                CMP R1, 0x00                            //while R1!=0x00 do. R1 ES EL NUMERO EN SI.
                BEQ stop

rotacion:       CMP R3, #32                           
                BEQ par
                RORS R1, #1    
                IT HS                                   //mover un bit del numero
                ADDHS R4, #1                            //suma cantidad de unos cuando C=1
                ADD R3, #1    
                B rotacion


par:            LSRS R4, #1                             //pone el LSB en el carry para ver si es par o impar.
                ITT HS                                   //Si C=1
                ADDHS R1, #128                          //suma 0x80 si la cantidad de 1's es impar.
                STRHS R1, [R0, #-1]
                B lazo                                  


stop:           B stop
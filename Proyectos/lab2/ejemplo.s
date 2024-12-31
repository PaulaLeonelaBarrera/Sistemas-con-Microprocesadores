            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data


            .section .text
            .global reset

reset:  MOV R1,#57 // Cargo el primer sumando 
        MOV R2,#10 // Cargo el segundo sumando 
        BL suma // Llamo a la subrutina 

stop:   B stop // Lazo infinito para terminar

suma:   ADD R0,R1,R2 // Realizo la suma 
        BX LR // Retorno al programa principal
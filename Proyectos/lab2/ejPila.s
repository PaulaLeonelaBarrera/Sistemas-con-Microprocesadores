            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data


            .section .text
            .global reset

reset:  MOV R0,#57 // Cargo en R0 el primer operando 
        MOV R1,#10 // Cargo en R1 el segundo operando 
        PUSH {R0,R1} // Preparo los parámetros en la pila 
        BL suma // Llamo a la subrutina 
        POP {R0,R1} // Recupero el resultado de la pila 

stop:   B stop // Lazo infinito para terminar 

suma:   PUSH {LR} // Almaceno la dirección de retorno 
        LDR R0,[SP,#4] // Recupero el primer parámetro 
        LDR R1,[SP,#8] // Recupero el primer parámetro 
        ADD R0,R1 // Realizo la suma 
        STR R0,[SP,#4] // Almaceno el resultado 
        POP {PC} // Retorno al programa principal
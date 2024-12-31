    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

.section .data              // Define la sección de variables (RAM) 
base:   .byte 59, 59, 23, 30, 3, 24     //Se carga la hora y fecha  29/3/24 23:58:55  

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Indica al depurador el inicio de una funcion


reset:  LDR R0, =base          //Guarda en R0 la direccion base de la estructura de datos 
        MOV R1, #0             //Inicialmente en 0, si hay cambio de dia lo indica este registro
        MOV R5, #24             //Para controlar que al retornar tenga el valor 24 el registro R5
        MOV R4, #0

demoraSegundo:              //lazo que itera 100 veces para que cuando salga del mismo sea pq paso 1 segundo             
    CMP R4, #100
    ITT LT
    ADDLT R4, #1               //incremento el registro que itera 100 veces
    BLLT demora               //Llama a la subrutina demora
    CMP R4, #100
    IT LT
    BLT demoraSegundo
    BL hora
    BL fecha
    B demoraSegundo


stop:   B    stop               // Lazo infinito para terminar la ejecución
        .pool                   // Almacenar las constantes de código
        .endfunc


//---------- SUBRUTINA Demora ----------//
    .func demora
 
demora:     PUSH {R4,R5}        //Guardo los valores de R4 y R5 en la pila para que si hay algo, no se pierda
            LDR R4, =50000     
            MOV R5, #0          //registro auxiliar que va contando las iteraciones

   
lazo:       CMP R5, R4          //Compara si R0 es menor a 50000
            ITT LT              //Si es menor, 
            ADDLT R5, #1        //incremento el registro auxiliar
            BLT lazo          //y vuelvo al lazo
            POP {R4,R5}         //Obtengo de la pila los valores de R4 y R5
            BX LR               //Fin de la subrutina
            .endfunc


//---------- SUBRUTINA hora ----------//
.func hora

hora:   PUSH {R4-R9}    //Guarda en la pila los valores desde R4 a R5

        LDRB R4, [R0]       // Carga en R4 el valor de los segundos
        LDRB R5, [R0,#1]    // Carga en R5 el valor de los minutos
        LDRB R6, [R0,#2]    // Carga en R5 el valor de las horas


        ADD R4,#1            //Incrementa en uno los segundos
        CMP R4,#59           //Compara si segundos es mayor a 59
        ITT GT      
        MOVGT R4, #0         //Resetea los segundos en 00
        ADDGT R5,#1          //Incrementa en uno los minutos

        CMP R5,#59           //Compara si los minutos es mayor a 59
        ITT GT
        MOVGT R5,#0          //Resetea los minutos en 00
        ADDGT R6,#1          //Incrementa en uno las horas

        CMP R6,#23           //Compara si las horas es mayor a 23
        ITT GT
        MOVGT R6,#0          //Resetea las horas en 00
        MOVGT R1,#1          //Pone en cero el control de desborde

        STRB R4, [R0]       //Guarda en memoria los segundos actualizados
        STRB R5, [R0,#1]    //Guarda en memoria los minutos actualizados
        STRB R6, [R0,#2]    //Guarda en memoria las horas actualizadas

        POP {R4-R9}      //Retorno desde R4 a R5 a sus valores originales

        BX LR
        .endfunc

//---------- SUBRUTINA fecha ----------//
.func fecha

fecha:  PUSH {R4-R9}    //Guarda en la pila los valores desde R4 a R5

        LDRB R4, [R0,#3]    // Carga en R4 el dia
        LDRB R5, [R0,#4]    // Carga en R5 el el mes
        LDRB R6, [R0,#5]    // Carga en R5 el anio

        
        ADD R4,R1            //Si hubo cambio de dia, se aumenta el dia
        CMP R4,#30           //Compara si dias es mayor a 30, se considera que todos los meses tienen 30 dias
        ITT GT      
        MOVGT R4, #1         //Resetea los dias en 1
        ADDGT R5,#1          //Incrementa en uno los meses

        CMP R5,#12           //Compara si los meses es mayor a 12
        ITT GT
        MOVGT R5,#1          //Resetea los meses en 1
        ADDGT R6, #1         //Incrementa en uno los anios

        STRB R4, [R0,#3]       //Guarda en memoria los dias actualizados
        STRB R5, [R0,#4]    //Guarda en memoria los meses actualizados
        STRB R6, [R0,#5]    //Guarda en memoria las anios actualizadas
        
        MOV R1, #0
        POP {R4-R9}      //Retorno desde R4 a R5 a sus valores originales

        BX LR
        .endfunc

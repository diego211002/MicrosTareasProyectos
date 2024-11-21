`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 18:49:16
// Design Name: 
// Module Name: Instrution_Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Instruction_Memory(
    input [10:0] addr,                 // Dirección de la instrucción
    output reg [31:0] instruction      // Instrucción leída de la memoria
);
    // Memoria de instrucciones de 34 posiciones (0 a 33)
    reg [31:0] instruction_memory [0:33];

    initial begin
        // Inicializar la memoria con las instrucciones proporcionadas
        instruction_memory[0]  = 32'hfe010113;  // addi sp, sp, -32     // Resta 32 al puntero de pila `sp` para reservar espacio en la pila.
        instruction_memory[1]  = 32'h00812e23;  // sw s0, 28(sp)       // Guarda el valor de `s0` en la pila en `sp + 28`.
        instruction_memory[2]  = 32'h02010413;  // addi s0, sp, 32     // Inicializa `s0` como un marco de pila, apuntando a `sp + 32`.
        instruction_memory[3]  = 32'h0000c7b7;  // lui a5, 0xc         // Carga 0xc000 en el registro `a5`.
        instruction_memory[4]  = 32'h7df78793;  // addi a5, a5, 2015   // Agrega 2015 a `a5` para completar un valor de dirección.
        instruction_memory[5]  = 32'hfef42223;  // sw a5, -28(s0)      // Guarda el valor de `a5` en la pila en `s0 - 28`.
        instruction_memory[6]  = 32'h06300793;  // li a5, 99           // Carga el valor ASCII de 'c' en `a5`.
        instruction_memory[7]  = 32'hfef401a3;  // sb a5, -29(s0)      // Guarda un byte (valor 'c') en `s0 - 29`.
        instruction_memory[8]  = 32'h02100793;  // li a5, 33           // Carga el valor 33 en `a5`, inicializando una variable.
        instruction_memory[9]  = 32'hfef42623;  // sw a5, -20(s0)      // Guarda el valor de `a5` (33) en `s0 - 20`.
        instruction_memory[10] = 32'hfe042423;  // sw zero, -24(s0)    // Inicializa la variable de control del ciclo `i` en 0.
        instruction_memory[11] = 32'h03c0006f;  // j 68                // Salta a la dirección 0x68 (inicio del ciclo).
        instruction_memory[12] = 32'hfe842783;  // lw a5, -24(s0)      // Carga el valor de `i` desde `s0 - 24`.
        instruction_memory[13] = 32'h00079863;  // bnez a5, 44         // Salta a 0x44 si `i` no es igual a 0.
        instruction_memory[14] = 32'h06200793;  // li a5, 98           // Carga 'b' en `a5` cuando `i == 0`.
        instruction_memory[15] = 32'hfef401a3;  // sb a5, -29(s0)      // Guarda 'b' en la posición `s0 - 29`.
        instruction_memory[16] = 32'h01c0006f;  // j 5c                // Salta a la dirección 0x5c (fuera del bloque `else`).
        instruction_memory[17] = 32'hfec42783;  // lw a5, -20(s0)      // Carga el valor de `b` desde `s0 - 20`.
        instruction_memory[18] = 32'h00179793;  // slli a5, a5, 0x1    // Desplaza `b` un bit a la izquierda (multiplica por 2).
        instruction_memory[19] = 32'hfef42623;  // sw a5, -20(s0)      // Guarda el nuevo valor de `b` en `s0 - 20`.
        instruction_memory[20] = 32'hfec42783;  // lw a5, -20(s0)      // Carga nuevamente el valor de `b` desde `s0 - 20`.
        instruction_memory[21] = 32'h00f7f793;  // andi a5, a5, 15     // Realiza un AND entre `b` y 15 (enmascara el valor).
        instruction_memory[22] = 32'hfef42623;  // sw a5, -20(s0)      // Guarda el valor enmascarado de `b` en `s0 - 20`.
        instruction_memory[23] = 32'hfe842703;  // lw a5, -24(s0)      // Carga el valor de `i` desde `s0 - 24`.
        instruction_memory[24] = 32'h00178793;  // addi a5, a5, 1      // Incrementa `i` en 1.
        instruction_memory[25] = 32'hfef42423;  // sw a5, -24(s0)      // Guarda el nuevo valor de `i` en `s0 - 24`.
        instruction_memory[26] = 32'hfe842703;  // lw a4, -24(s0)      // Carga el valor de `i` en `a4`.
        instruction_memory[27] = 32'h00100793;  // li a5, 1            // Carga 1 en `a5`, como límite del ciclo.
        instruction_memory[28] = 32'hfce7d0e3;  // bge a5, a4, 30      // Salta a 0x30 si `a5` >= `a4`.
        instruction_memory[29] = 32'h00000793;  // li a5, 0            // Carga 0 en `a5` al final del ciclo.
        instruction_memory[30] = 32'h00078513;  // mv a0, a5           // Mueve el valor de `a5` a `a0` (valor de retorno).
        instruction_memory[31] = 32'h01c12403;  // lw s0, 28(sp)       // Restaura el valor de `s0` desde la pila.
        instruction_memory[32] = 32'h02010113;  // addi sp, sp, 32     // Libera el espacio reservado en la pila.
        instruction_memory[33] = 32'h00008067;  // ret                 // Retorna al llamador.
    end

    always @(*) begin
        if (addr[7:2] < 34)                 // Si la dirección está dentro del rango válido (0-33):
            instruction = instruction_memory[addr[7:2]];  // Cargar la instrucción correspondiente.
        else                                // Si la dirección está fuera de rango:
            instruction = 32'b0;            // Asignar instrucción nula (código inválido).
    end
endmodule


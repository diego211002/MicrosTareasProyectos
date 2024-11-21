`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 18:35:10
// Design Name: 
// Module Name: Contador_PC
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

module Contador_PC(            // M�dulo Contador_PC: implementa el contador de programa (PC).
    input clk,                 // Entrada de reloj para sincronizar las operaciones.
    input reset,               // Se�al de reset para reiniciar el contador de programa.
    input [31:0] PCNext,       // Valor del pr�ximo PC (calculado en el datapath o unidad de control).
    output reg [31:0] PC       // Salida del valor actual del PC (direcci�n de la instrucci�n actual).
);

    always @(posedge clk or posedge reset) begin // Bloque siempre activado en flanco positivo de reloj o se�al de reset.
        if (reset)                               // Si se activa la se�al de reset:
            PC <= 32'b0;                         // Reiniciar el PC a 0 (inicio del programa).
        else                                     // En cada flanco positivo del reloj, si no hay reset:
            PC <= PCNext;                        // Actualizar el PC con el valor de PCNext (la siguiente direcci�n de instrucci�n).
    end
endmodule                                        // Fin del m�dulo Contador_PC.

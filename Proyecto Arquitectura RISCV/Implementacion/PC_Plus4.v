`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 19:41:10
// Design Name: 
// Module Name: PC_Plus4
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

module PC_Plus4 (              // M�dulo PC_Plus4: calcula la siguiente direcci�n del contador de programa (PC+4).
    input [31:0] A,            // Entrada: direcci�n actual del PC (32 bits).
    output [31:0] B            // Salida: direcci�n siguiente del PC (PC + 4).
);
    assign B = A + 4;          // Operaci�n combinacional: suma 4 al valor actual del PC para obtener la siguiente instrucci�n.
endmodule                      // Fin del m�dulo PC_Plus4.


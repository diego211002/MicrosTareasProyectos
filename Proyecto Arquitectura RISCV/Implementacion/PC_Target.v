`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 18:36:09
// Design Name: 
// Module Name: PC_Target
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

module PC_Target(                  // M�dulo PC_Target: calcula la direcci�n de salto en base al PC actual y un valor inmediato extendido.
    input [31:0] PC,               // Entrada: valor actual del contador de programa (PC).
    input [31:0] ImmExt,           // Entrada: valor inmediato extendido desde el decodificador de inmediatos.
    output [31:0] PCTarget         // Salida: direcci�n de salto calculada (PC de destino).
);

    // Operaci�n combinacional: calcula el PC de destino sumando el valor actual del PC con el inmediato extendido.
    assign PCTarget = PC + ImmExt;

endmodule                          // Fin del m�dulo PC_Target.


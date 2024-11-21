`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 19:16:28
// Design Name: 
// Module Name: Mux
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

module Mux(                   // Módulo Mux: implementa un multiplexor de 2 entradas a 1 salida.
    input [31:0] A,           // Entrada A de 32 bits.
    input [31:0] B,           // Entrada B de 32 bits.
    input sel,                // Señal de selección: determina cuál de las entradas se enviará a la salida.
    output [31:0] C           // Salida C: selecciona entre A y B según la señal `sel`.
);

    // Asignación combinacional:
    // Si `sel` es 1, la salida C toma el valor de B.
    // Si `sel` es 0, la salida C toma el valor de A.
    assign C = (sel) ? B : A; 

endmodule                      // Fin del módulo Mux.



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 20:20:45
// Design Name: 
// Module Name: Alu
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

module Alu(                          // M�dulo ALU: realiza operaciones aritm�ticas y l�gicas.
    input [31:0] A, B,               // Entradas A y B: operandos de 32 bits.
    input [3:0] ALUControl,          // Entrada de control: define la operaci�n a realizar.
    output reg [31:0] C              // Salida C: resultado de la operaci�n.
);

    always @(*) begin                // Bloque combinacional, ejecuta operaciones basadas en ALUControl.
        case (ALUControl)            // Selecci�n de operaci�n seg�n el valor de ALUControl.
            4'b0000: 
                C = A + B;           // Operaci�n: Suma de A y B.
            4'b0001: 
                C = A << B[4:0];     // Operaci�n: Shift l�gico a la izquierda (controlado por los 5 bits menos significativos de B).
            4'b0010: 
                C = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // Comparaci�n signed (menor que): devuelve 1 si A < B.
            4'b0011: 
                C = (A < B) ? 32'b1 : 32'b0; // Comparaci�n unsigned (menor que): devuelve 1 si A < B (sin considerar signo).
            4'b0100: 
                C = A ^ B;           // Operaci�n: XOR bit a bit entre A y B.
            4'b0101: 
                C = A >> B[4:0];     // Operaci�n: Shift l�gico a la derecha (controlado por los 5 bits menos significativos de B).
            4'b0110: 
                C = $signed(A) >>> B[4:0]; // Operaci�n: Shift aritm�tico a la derecha (preserva el signo).
            4'b0111: 
                C = A | B;           // Operaci�n: OR bit a bit entre A y B.
            4'b1000: 
                C = A & B;           // Operaci�n: AND bit a bit entre A y B.
            4'b1001: 
                C = A - B;           // Operaci�n: Resta de A y B.
            4'b1010: 
                C = ($signed(A) >= $signed(B)) ? 32'b1 : 32'b0; // Comparaci�n signed (mayor o igual que): devuelve 1 si A >= B.
            default: 
                C = 32'b0;           // Caso por defecto: si ALUControl no coincide con ninguna operaci�n, devuelve 0.
        endcase
    end

endmodule                            // Fin del m�dulo ALU.

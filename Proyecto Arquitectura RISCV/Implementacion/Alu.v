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

module Alu(                          // Módulo ALU: realiza operaciones aritméticas y lógicas.
    input [31:0] A, B,               // Entradas A y B: operandos de 32 bits.
    input [3:0] ALUControl,          // Entrada de control: define la operación a realizar.
    output reg [31:0] C              // Salida C: resultado de la operación.
);

    always @(*) begin                // Bloque combinacional, ejecuta operaciones basadas en ALUControl.
        case (ALUControl)            // Selección de operación según el valor de ALUControl.
            4'b0000: 
                C = A + B;           // Operación: Suma de A y B.
            4'b0001: 
                C = A << B[4:0];     // Operación: Shift lógico a la izquierda (controlado por los 5 bits menos significativos de B).
            4'b0010: 
                C = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // Comparación signed (menor que): devuelve 1 si A < B.
            4'b0011: 
                C = (A < B) ? 32'b1 : 32'b0; // Comparación unsigned (menor que): devuelve 1 si A < B (sin considerar signo).
            4'b0100: 
                C = A ^ B;           // Operación: XOR bit a bit entre A y B.
            4'b0101: 
                C = A >> B[4:0];     // Operación: Shift lógico a la derecha (controlado por los 5 bits menos significativos de B).
            4'b0110: 
                C = $signed(A) >>> B[4:0]; // Operación: Shift aritmético a la derecha (preserva el signo).
            4'b0111: 
                C = A | B;           // Operación: OR bit a bit entre A y B.
            4'b1000: 
                C = A & B;           // Operación: AND bit a bit entre A y B.
            4'b1001: 
                C = A - B;           // Operación: Resta de A y B.
            4'b1010: 
                C = ($signed(A) >= $signed(B)) ? 32'b1 : 32'b0; // Comparación signed (mayor o igual que): devuelve 1 si A >= B.
            default: 
                C = 32'b0;           // Caso por defecto: si ALUControl no coincide con ninguna operación, devuelve 0.
        endcase
    end

endmodule                            // Fin del módulo ALU.

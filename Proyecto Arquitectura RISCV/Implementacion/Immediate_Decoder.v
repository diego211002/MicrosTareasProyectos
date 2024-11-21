`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 18:57:14
// Design Name: 
// Module Name: Immediate_Decoder
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
module Immediate_Decoder( 
    input [31:0] instruction,   // Instrucción completa de 32 bits
    input [2:0] ImmSrc,         // Tipo de inmediato desde la unidad de control (define cómo interpretar el inmediato)
    output reg [31:0] ImmExt    // Salida del inmediato decodificado (valor extendido a 32 bits)
);

    always @(*) begin
        case (ImmSrc)
            3'b000: // Tipo I (e.g., ADDI, LW, JALR)
                // El inmediato se encuentra en los bits [31:20].
                // Se extiende el bit más significativo (signo) para formar un inmediato de 32 bits.
                ImmExt = {{20{instruction[31]}}, instruction[31:20]};

            3'b001: // Tipo S (e.g., SW)
                // El inmediato se construye combinando los bits [31:25] y [11:7].
                // Se extiende el bit de signo (bit 31) para formar un valor de 32 bits.
                ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            3'b010: // Tipo B (e.g., BEQ, BNE)
                // El inmediato de rama incluye varios campos: [31], [7], [30:25], y [11:8].
                // Además, se añade un bit 0 al final para garantizar que sea un desplazamiento múltiplo de 2.
                ImmExt = {{20{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

            3'b011: // Tipo U (e.g., LUI, AUIPC)
                // El inmediato ocupa los bits más altos [31:12] y se rellena con ceros en los 12 bits inferiores.
                ImmExt = {instruction[31:12], 12'b0};

            3'b100: // Tipo J (e.g., JAL)
                // El inmediato de salto incluye campos dispersos: [31], [19:12], [20], y [30:21].
                // También se añade un bit 0 al final para mantener la alineación.
                ImmExt = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};

            default: 
                // Caso por defecto: si `ImmSrc` tiene un valor no reconocido, el inmediato se asigna a 0.
                ImmExt = 32'b0;
        endcase
    end
endmodule



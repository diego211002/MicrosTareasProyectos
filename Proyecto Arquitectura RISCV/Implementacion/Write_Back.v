`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 19:21:05
// Design Name: 
// Module Name: Write_Back
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
module Write_Back (
    input [31:0] A,             // Entrada A (ALUResult)
    input [31:0] B,             // Entrada B (ReadData de la memoria de datos)
    input [31:0] C,             // Entrada C (PC+4)
    input [6:0] Opcode,         // Opcode de la instrucción
    output reg [31:0] wdata     // Dato seleccionado para escritura en el banco de registros
);

    // Inicializar wdata en 0 para evitar estados indeterminados en simulación
    initial wdata = 32'b0;

    always @(*) begin
        case (Opcode)
            7'b0110011: wdata = A;   // Tipo R (ALUResult)
            7'b0000011: wdata = B;   // LW (ReadData de memoria)
            7'b1101111: wdata = C;   // JAL (PC+4)
            7'b1100111: wdata = C;   // JALR (PC+4)
            7'b0010011: wdata = A;   // Tipo I (ALUResult) - por ejemplo, ADDI
            default: wdata = 32'b0;  // Para otros casos no manejados
        endcase
    end
endmodule


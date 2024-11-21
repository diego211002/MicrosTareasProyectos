`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 19:39:40
// Design Name: 
// Module Name: Branch_Control
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
module Branch_Control(
    input [31:0] rs1,                // Primer operando para comparaci�n (generalmente un registro fuente).
    input [31:0] rs2,                // Segundo operando para comparaci�n (generalmente otro registro fuente).
    input [2:0] Funct3,              // Campo Funct3 de la instrucci�n, define el tipo de comparaci�n.
    input [6:0] Opcode,              // Opcode de la instrucci�n, identifica si es una instrucci�n de rama.
    output reg br_taken              // Se�al de rama tomada (1 si se cumple la condici�n, 0 de lo contrario).
);

    always @(*) begin
        // Por defecto, se asume que la rama no se toma.
        br_taken = 0;

        // Verifica si el opcode corresponde a una instrucci�n de rama.
        if (Opcode == 7'b1100011) begin
            // Basado en el valor de Funct3, selecciona el tipo de comparaci�n.
            case (Funct3)
                3'b000: 
                    br_taken = (rs1 == rs2) ? 1'b1 : 1'b0; // BEQ (Branch if Equal): salta si rs1 == rs2.
                3'b001: 
                    br_taken = (rs1 != rs2) ? 1'b1 : 1'b0; // BNE (Branch if Not Equal): salta si rs1 != rs2.
                3'b100: 
                    br_taken = (rs1 < rs2) ? 1'b1 : 1'b0;  // BLT (Branch if Less Than, unsigned): salta si rs1 < rs2.
                3'b101: 
                    br_taken = (rs1 >= rs2) ? 1'b1 : 1'b0; // BGE (Branch if Greater or Equal, unsigned): salta si rs1 >= rs2.
                3'b110: 
                    br_taken = ($signed(rs1) < $signed(rs2)) ? 1'b1 : 1'b0; // BLT (signed): salta si rs1 < rs2 (con signo).
                3'b111: 
                    br_taken = ($signed(rs1) >= $signed(rs2)) ? 1'b1 : 1'b0; // BGE (signed): salta si rs1 >= rs2 (con signo).
                default: 
                    br_taken = 0; // Si Funct3 no es v�lido, no se toma la rama.
            endcase
        end
    end

endmodule


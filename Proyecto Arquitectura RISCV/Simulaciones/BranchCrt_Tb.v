`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 07:31:14 PM
// Design Name: 
// Module Name: BranchCrt_Tb
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


module BranchCrt_Tb;
     // Señales de entrada
    reg [31:0] rs1;
    reg [31:0] rs2;
    reg [2:0] Funct3;
    reg [6:0] Opcode;

    // Señal de salida
    wire br_taken;

    // Instancia del módulo a probar
    Branch_Control uut (
        .rs1(rs1),
        .rs2(rs2),
        .Funct3(Funct3),
        .Opcode(Opcode),
        .br_taken(br_taken)
    );

    // Estímulos
    initial begin
        // Inicialización
        rs1 = 0; rs2 = 0; Funct3 = 3'b000; Opcode = 7'b1100011; #10; // BEQ, iguales -> tomada (1)

        // Prueba BEQ
        rs1 = 5; rs2 = 5; Funct3 = 3'b000; Opcode = 7'b1100011; #10; // BEQ, iguales -> tomada (1)
        rs1 = 5; rs2 = 3; Funct3 = 3'b000; Opcode = 7'b1100011; #10; // BEQ, diferentes -> no tomada (0)

        // Prueba BNE
        rs1 = 5; rs2 = 3; Funct3 = 3'b001; Opcode = 7'b1100011; #10; // BNE, diferentes -> tomada (1)
        rs1 = 5; rs2 = 5; Funct3 = 3'b001; Opcode = 7'b1100011; #10; // BNE, iguales -> no tomada (0)

        // Prueba BLT (unsigned)
        rs1 = 2; rs2 = 3; Funct3 = 3'b100; Opcode = 7'b1100011; #10; // BLT -> tomada (1)
        rs1 = 3; rs2 = 2; Funct3 = 3'b100; Opcode = 7'b1100011; #10; // BLT -> no tomada (0)

        // Prueba BGE (unsigned)
        rs1 = 3; rs2 = 2; Funct3 = 3'b101; Opcode = 7'b1100011; #10; // BGE -> tomada (1)
        rs1 = 2; rs2 = 3; Funct3 = 3'b101; Opcode = 7'b1100011; #10; // BGE -> no tomada (0)

        // Prueba BLT (signed)
        rs1 = -5; rs2 = 3; Funct3 = 3'b110; Opcode = 7'b1100011; #10; // BLT -> tomada (1)
        rs1 = 5; rs2 = -3; Funct3 = 3'b110; Opcode = 7'b1100011; #10; // BLT -> no tomada (0)

        // Prueba BGE (signed)
        rs1 = 5; rs2 = -3; Funct3 = 3'b111; Opcode = 7'b1100011; #10; // BGE -> tomada (1)
        rs1 = -5; rs2 = 3; Funct3 = 3'b111; Opcode = 7'b1100011; #10; // BGE -> no tomada (0)

        // Prueba caso Opcode no rama
        rs1 = 5; rs2 = 5; Funct3 = 3'b000; Opcode = 7'b0000000; #10; // No tomada (0)

        // Finalizar simulación
        $stop;
    end

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 07:26:13 PM
// Design Name: 
// Module Name: ImmDecod_Tb
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


module ImmDecod_Tb;

    // Señales
    reg [31:0] instruction;   // Instrucción completa de 32 bits
    reg [2:0] ImmSrc;         // Tipo de inmediato desde la unidad de control
    wire [31:0] ImmExt;       // Salida del inmediato decodificado

    // Instancia del módulo a probar
    Immediate_Decoder uut (
        .instruction(instruction),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    // Estímulos
    initial begin
        // Inicialización
        instruction = 32'b0;
        ImmSrc = 3'b000;

        // Prueba para el tipo I (ADDI, LW)
        instruction = 32'b111111111111_00000_000_00000_0010011; // ADDI con inmediato negativo (-1)
        ImmSrc = 3'b000;
        #10;

        // Prueba para el tipo S (SW)
        instruction = 32'b1111111_00000_00000_010_00000_0100011; // SW con inmediato negativo (-1)
        ImmSrc = 3'b001;
        #10;

        // Prueba para el tipo B (BEQ, BNE)
        instruction = 32'b1_000000_00000_00000_000_0_0000_1100011; // BEQ con inmediato negativo
        ImmSrc = 3'b010;
        #10;

        // Prueba para el tipo U (LUI)
        instruction = 32'b00000000000000000001_00000_0110111; // LUI con inmediato positivo
        ImmSrc = 3'b011;
        #10;

        // Prueba para el tipo J (JAL)
        instruction = 32'b1_00000000000_0_00000000_0000_1101111; // JAL con inmediato negativo
        ImmSrc = 3'b100;
        #10;

        // Caso por defecto
        ImmSrc = 3'b101; // Invalido
        #10;

        // Finalizar simulación
        $stop;
    end
endmodule
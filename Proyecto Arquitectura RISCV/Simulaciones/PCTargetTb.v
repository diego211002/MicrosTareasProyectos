`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 07:37:58 PM
// Design Name: 
// Module Name: PCTargetTb
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


module PCTargetTb;
    // Declaración de señales
    reg [31:0] PC;
    reg [31:0] ImmExt;
    wire [31:0] PCTarget;

    // Instancia del módulo a probar
    PC_Target uut (
        .PC(PC),
        .ImmExt(ImmExt),
        .PCTarget(PCTarget)
    );

    // Estímulos para probar el módulo
    initial begin
        // Inicialización
        PC = 32'h00000000; ImmExt = 32'h00000004;
        #10; // Esperar 10 ns
        $display("PC: %h, ImmExt: %h, PCTarget: %h", PC, ImmExt, PCTarget);
        
        // Caso 1: PC = 0x00000010, ImmExt = 0x00000008
        PC = 32'h00000010; ImmExt = 32'h00000008;
        #10; 
        $display("PC: %h, ImmExt: %h, PCTarget: %h", PC, ImmExt, PCTarget);

        // Caso 2: PC = 0x10000000, ImmExt = 0xFFFFFFFC (valor negativo)
        PC = 32'h10000000; ImmExt = 32'hFFFFFFFC;
        #10; 
        $display("PC: %h, ImmExt: %h, PCTarget: %h", PC, ImmExt, PCTarget);

        // Caso 3: PC = 0x7FFFFFFF, ImmExt = 0x00000001 (límite superior de 32 bits)
        PC = 32'h7FFFFFFF; ImmExt = 32'h00000001;
        #10; 
        $display("PC: %h, ImmExt: %h, PCTarget: %h", PC, ImmExt, PCTarget);

        // Fin del testbench
        $stop;
    end

endmodule

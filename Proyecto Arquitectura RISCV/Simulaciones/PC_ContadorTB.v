`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 07:11:48 PM
// Design Name: 
// Module Name: PC_ContadorTB
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


module PC_ContadorTB;
    // Declaración de señales
    reg clk;                     // Señal de reloj
    reg reset;                   // Señal de reset
    reg [31:0] PCNext;           // Valor de siguiente PC
    wire [31:0] PC;              // Valor actual de PC

    // Instancia del módulo a probar
    Contador_PC uut (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );

    // Generador de reloj (50 MHz, periodo = 20 ns)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Cambiar cada 10 ns
    end

    // Estímulos para las pruebas
    initial begin
        // Inicialización de señales
        reset = 1;               // Activar reset inicialmente
        PCNext = 32'b0;

        #20 reset = 0;           // Desactivar reset

        // Ciclo infinito para incrementar PC en 4
        forever begin
            PCNext = PC + 4;     // Incrementar PCNext en 4
            #20;                 // Esperar 1 ciclo de reloj
        end
    end
endmodule

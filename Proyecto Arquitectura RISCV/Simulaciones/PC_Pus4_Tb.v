`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 07:17:42 PM
// Design Name: 
// Module Name: PC_Pus4_Tb
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


module PC_Pus4_Tb;
 // Declaración de señales
    reg [31:0] A;           // Entrada: valor base
    wire [31:0] B;          // Salida: valor incrementado

    // Instancia del módulo a probar
    PC_Plus4 uut (
        .A(A),
        .B(B)
    );

    // Estímulos para las pruebas
    initial begin
        // Inicialización
        A = 32'b0;          // Iniciar en 0

        // Ciclo infinito para incrementar A de 4 en 4
        forever begin
            #10 A = B;      // Asignar el valor de salida (B) a la entrada (A)
        end
    end
endmodule

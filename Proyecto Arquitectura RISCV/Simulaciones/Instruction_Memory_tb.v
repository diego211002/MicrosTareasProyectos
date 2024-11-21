`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2024 09:30:52
// Design Name: 
// Module Name: Instruction_Memory_tb
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



module Instruction_Memory_tb;

    // Declaraci�n de registros y cables para las entradas y salidas del m�dulo
    reg [31:0] addr;               // Direcci�n de la instrucci�n
    wire [31:0] instruction;       // Instrucci�n le�da desde la memoria

    // Instancia del m�dulo Instruction_Memory
    Instruction_Memory uut (
        .addr(addr),
        .instruction(instruction)
    );

    // Variable para almacenar el valor esperado
    reg [31:0] expected_instruction;

    // Inicializaci�n de la prueba
    initial begin
        // Encabezado para los resultados
        $display("Iniciando pruebas para Instruction_Memory");
        $display("Direccion\tInstruccion Le�da\tInstruccion Esperada\tResultado");

        // Prueba de cada instrucci�n dentro del rango
        addr = 32'd0; expected_instruction = 32'h00800e23; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd4; expected_instruction = 32'h02010413; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd8; expected_instruction = 32'h0000c7b7; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd12; expected_instruction = 32'h7df78793; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd16; expected_instruction = 32'hfef42223; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd20; expected_instruction = 32'h06300793; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd24; expected_instruction = 32'hfef401a3; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd28; expected_instruction = 32'h02100793; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd32; expected_instruction = 32'hfef42623; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd36; expected_instruction = 32'hfe042423; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd40; expected_instruction = 32'h03c0006f; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd44; expected_instruction = 32'hfe842783; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd48; expected_instruction = 32'h00079863; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd52; expected_instruction = 32'h06200793; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd56; expected_instruction = 32'hfef401a3; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd60; expected_instruction = 32'h01c0006f; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd64; expected_instruction = 32'hfec42783; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd68; expected_instruction = 32'h00179793; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd72; expected_instruction = 32'hfef42623; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd76; expected_instruction = 32'hfec42783; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd80; expected_instruction = 32'h00f7f793; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd84; expected_instruction = 32'hfef42623; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd88; expected_instruction = 32'h00178793; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd92; expected_instruction = 32'hfef42423; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd96; expected_instruction = 32'hfe842703; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd100; expected_instruction = 32'h00100793; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd104; expected_instruction = 32'hfce7d0e3; #10; check_instruction(addr, instruction, expected_instruction);
        addr = 32'd108; expected_instruction = 32'h00000793; #10; check_instruction(addr, instruction, expected_instruction);

        // Prueba con una direcci�n fuera de rango (deber�a devolver 0)
        addr = 32'd112; expected_instruction = 32'b0; #10; check_instruction(addr, instruction, expected_instruction);

        // Prueba con otra direcci�n fuera de rango
        addr = 32'd128; expected_instruction = 32'b0; #10; check_instruction(addr, instruction, expected_instruction);

        // Finalizar la simulaci�n
        $display("Pruebas completadas.");
        $finish;
    end

    // Tarea para verificar y mostrar el resultado de cada lectura
    task check_instruction(
        input [31:0] address,
        input [31:0] actual_instruction,
        input [31:0] expected_instruction
    );
        begin
            if (actual_instruction === expected_instruction) begin
                $display("Direccion: %h | Instruccion Le�da: %h | Instruccion Esperada: %h | Resultado: Correcto", address, actual_instruction, expected_instruction);
            end else begin
                $display("Direccion: %h | Instruccion Le�da: %h | Instruccion Esperada: %h | Resultado: Error", address, actual_instruction, expected_instruction);
            end
        end
    endtask

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 19:59:41
// Design Name: 
// Module Name: Main_tb
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

module Main_tb;

    // Declaraci�n de se�ales
    reg clk;
    reg reset;
    wire [31:0] PC_out;
    wire [31:0] instruction;
    wire [31:0] ALUResult;
    wire [31:0] mem_data;
    wire [31:0] PCNext, PCPlus4, ImmExt, PCTarget;
    wire [31:0] rs1_data, rs2_data, ALUOperandB, DataMemOut, ALUorMem, write_data;
    wire [6:0] Opcode;
    wire [2:0] Funct3;
    wire [6:0] Funct7;
    wire signed [4:0] raddr1, raddr2;
    wire [4:0] waddr;
    wire [3:0] ALUControl;
    wire PCSrc, ResultSrc, MemWrite, ALUSrc, RegWrite;
    wire [2:0] ImmSrc;
    wire br_taken;
    wire EnImm;

    // Instanciaci�n del m�dulo Main
    Main uut (
        .clk(clk),
        .reset(reset),
        .PC_out(PC_out),
        .instruction(instruction),
        .ALUResult(ALUResult),
        .mem_data(mem_data),
        .PCNext(PCNext),
        .PCPlus4(PCPlus4),
        .ImmExt(ImmExt),
        .PCTarget(PCTarget),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .ALUOperandB(ALUOperandB),
        .DataMemOut(DataMemOut),
        .ALUorMem(ALUorMem),
        .write_data(write_data),
        .Opcode(Opcode),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .ALUControl(ALUControl),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .br_taken(br_taken),
        .EnImm(EnImm)
    );

    // Generaci�n de reloj
    always begin
        #5 clk = ~clk; // Generaci�n de se�al de reloj con periodo de 10 unidades
    end

    // Est�mulos de entrada
    initial begin
        // Inicializaci�n de se�ales
        clk = 0;
        reset = 1;

        // Verificaci�n de las salidas cuando reset est� activo
        #10 reset = 0; // Desactivar reset despu�s de 10 unidades de tiempo
    end

    // Evaluar condici�n en cada flanco de reloj positivo
    always @(posedge clk) begin
        if (PC_out > 32'h84) begin
            $display("PC_out ha superado 0x84. Deteniendo la simulaci�n.");
            $finish;  // Finalizar la simulaci�n si PC_out es mayor que 0x84
        end
    end

    // Monitoreo de se�ales de salida
    initial begin
        $monitor("Time: %0t | PC_out: %h | Instruction: %h | ALUResult: %h | mem_data: %h", 
                 $time, PC_out, instruction, ALUResult, mem_data);
    end
endmodule


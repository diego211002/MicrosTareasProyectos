`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 07:50:14 PM
// Design Name: 
// Module Name: WriteBackTb
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


module WriteBackTb;
    // Declaración de señales
    reg [31:0] A, B, C;
    reg [6:0] Opcode;
    wire [31:0] wdata;

    // Instancia del módulo Write_Back
    Write_Back uut (
        .A(A),
        .B(B),
        .C(C),
        .Opcode(Opcode),
        .wdata(wdata)
    );

    // Procedimiento para generar estímulos
    initial begin
        // Mostrar encabezado de la tabla
        $display("Inicio de la simulación del módulo Write_Back...");
        $display("------------------------------------------------------------");
        $display("| Iteración |   A   |   B   |   C   | Opcode | wdata |");
        $display("------------------------------------------------------------");

        // Caso 1: Instrucción tipo R (ALUResult)
        A = 32'h00000010;  // ALU Result (ej. suma)
        B = 32'h00000000;  // No usado en este caso
        C = 32'h00000000;  // No usado en este caso
        Opcode = 7'b0110011;  // Instrucción tipo R (Ej: ADD)
        #10;
        $display("|    1     |  10   |  00   |  00   |  0110011 |  10   |", A, B, C, wdata);

        // Caso 2: Instrucción LW (Cargar de memoria)
        A = 32'h00000000;  // No usado en este caso
        B = 32'h00000020;  // ReadData de memoria (ej. cargado desde memoria)
        C = 32'h00000000;  // No usado en este caso
        Opcode = 7'b0000011;  // Instrucción de carga (Ej: LW)
        #10;
        $display("|    2     |  00   |  20   |  00   |  0000011 |  20   |", A, B, C, wdata);

        // Caso 3: Instrucción JAL (salto)
        A = 32'h00000000;  // No usado en este caso
        B = 32'h00000000;  // No usado en este caso
        C = 32'h00000030;  // PC+4 (dirección de retorno)
        Opcode = 7'b1101111;  // Instrucción JAL (Ej: Jump and Link)
        #10;
        $display("|    3     |  00   |  00   |  30   |  1101111 |  30   |", A, B, C, wdata);

        // Caso 4: Instrucción JALR (salto con registro)
        A = 32'h00000000;  // No usado en este caso
        B = 32'h00000000;  // No usado en este caso
        C = 32'h00000040;  // PC+4 (dirección de retorno)
        Opcode = 7'b1100111;  // Instrucción JALR
        #10;
        $display("|    4     |  00   |  00   |  40   |  1100111 |  40   |", A, B, C, wdata);

        // Caso 5: Instrucción tipo I (ADDI)
        A = 32'h00000015;  // ALU Result (ej. suma de inmediato)
        B = 32'h00000000;  // No usado en este caso
        C = 32'h00000000;  // No usado en este caso
        Opcode = 7'b0010011;  // Instrucción tipo I (Ej: ADDI)
        #10;
        $display("|    5     |  15   |  00   |  00   |  0010011 |  15   |", A, B, C, wdata);

        // Fin de la simulación
        $display("------------------------------------------------------------");
        $display("Fin de la simulación.");
        $stop;  // Termina la simulación
    end

endmodule
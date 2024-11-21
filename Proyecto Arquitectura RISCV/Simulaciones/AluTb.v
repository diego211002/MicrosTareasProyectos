`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 07:43:29 PM
// Design Name: 
// Module Name: AluTb
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


module AluTb;
    // Declaraci�n de se�ales
    reg [31:0] A, B;
    reg [3:0] ALUControl;
    wire [31:0] C;

    // Instancia del m�dulo ALU
    Alu uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .C(C)
    );

    // Procedimiento para generar est�mulos
    initial begin
        // Mostrar encabezado de la tabla
        $display("Inicio de la simulaci�n de la ALU con casos de prueba...");
        $display("----------------------------------------------------------------------");
        $display("| Iteraci�n |        A        |        B        | ALUControl |     C     |");
        $display("----------------------------------------------------------------------");

        // Caso 1: Suma (A + B)
        A = 32'h00000005;  // 5
        B = 32'h00000003;  // 3
        ALUControl = 4'b0000;  // Suma
        #10;  // Esperar 10 ns
        $display("|    1     |   %h   |   %h   |  0000   |   %h   |", A, B, C);

        // Caso 2: Desplazamiento a la izquierda (A << B[4:0])
        A = 32'h00000001;  // 1
        B = 32'h00000002;  // 2
        ALUControl = 4'b0001;  // Shift a la izquierda
        #10;
        $display("|    2     |   %h   |   %h   |  0001   |   %h   |", A, B, C);

        // Caso 3: Comparaci�n signed (A < B)
        A = 32'h00000005;  // 5
        B = 32'h00000003;  // 3
        ALUControl = 4'b0010;  // Comparaci�n signed (menor que)
        #10;
        $display("|    3     |   %h   |   %h   |  0010   |   %h   |", A, B, C);

        // Caso 4: Comparaci�n unsigned (A < B)
        A = 32'h00000005;  // 5
        B = 32'h00000003;  // 3
        ALUControl = 4'b0011;  // Comparaci�n unsigned (menor que)
        #10;
        $display("|    4     |   %h   |   %h   |  0011   |   %h   |", A, B, C);

        // Caso 5: XOR (A ^ B)
        A = 32'h0000000F;  // 15
        B = 32'h000000F0;  // 240
        ALUControl = 4'b0100;  // XOR
        #10;
        $display("|    5     |   %h   |   %h   |  0100   |   %h   |", A, B, C);

        // Caso 6: Shift a la derecha l�gico (A >> B[4:0])
        A = 32'h00000010;  // 16
        B = 32'h00000003;  // 3
        ALUControl = 4'b0101;  // Shift a la derecha l�gico
        #10;
        $display("|    6     |   %h   |   %h   |  0101   |   %h   |", A, B, C);

        // Caso 7: Resta (A - B)
        A = 32'h00000010;  // 16
        B = 32'h00000005;  // 5
        ALUControl = 4'b1001;  // Resta
        #10;
        $display("|    7     |   %h   |   %h   |  1001   |   %h   |", A, B, C);

        // Caso 8: Comparaci�n signed (A >= B)
        A = 32'h00000005;  // 5
        B = 32'h00000003;  // 3
        ALUControl = 4'b1010;  // Comparaci�n signed (mayor o igual que)
        #10;
        $display("|    8     |   %h   |   %h   |  1010   |   %h   |", A, B, C);

        // Fin de la simulaci�n
        $display("----------------------------------------------------------------------");
        $display("Fin de la simulaci�n.");
        $stop;  // Termina la simulaci�n
    end

endmodule
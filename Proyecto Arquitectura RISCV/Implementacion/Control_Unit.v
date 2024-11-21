`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 19:07:23
// Design Name: 
// Module Name: Control_Unit
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
module Control_Unit(
    input [6:0] Op,               // Opcode de la instrucción: identifica el tipo de operación.
    input [2:0] Funct3,           // Campo funct3: especifica detalles adicionales sobre la operación.
    input [6:0] Funct7,           // Campo funct7: utilizado para distinguir ciertas operaciones (principalmente en tipo R).
    output reg PCSrc,             // Selección de fuente para el PC: indica si se toma un salto o se sigue secuencialmente.
    output reg ResultSrc,         // Selección de fuente para WriteBack: decide si escribir desde ALU o memoria.
    output reg MemWrite,          // Señal para habilitar escritura en memoria.
    output reg [3:0] ALUControl,  // Código de operación para la ALU: define la operación que debe realizar.
    output reg ALUSrc,            // Selección de operandos para la ALU: si usar registro o inmediato.
    output reg [2:0] ImmSrc,      // Tipo de inmediato para el decodificador.
    output reg RegWrite,          // Habilita escritura en el banco de registros.
    output reg enable             // Habilita otras señales adicionales (puede personalizarse).
);

    // Comportamiento de la unidad de control basado en Op, Funct3 y Funct7.
    always @(*) begin
        // Inicialización de valores por defecto (importante para evitar estados indefinidos).
        PCSrc = 0;                // Por defecto, no se toma un salto.
        ResultSrc = 0;            // Por defecto, el resultado proviene de la ALU.
        MemWrite = 0;             // Escritura en memoria deshabilitada por defecto.
        ALUControl = 4'b0000;     // Operación por defecto para la ALU (suma).
        ALUSrc = 0;               // Operando por defecto de la ALU es un registro.
        ImmSrc = 0;               // Tipo de inmediato por defecto.
        RegWrite = 0;             // Escritura en registros deshabilitada por defecto.

        // Decodificación de la instrucción según el opcode.
        case (Op)
            // Tipo I - ADDI
            7'b0010011: begin
                RegWrite = 1;            // Habilita escritura en el registro destino.
                ALUSrc = 1;              // El operando B para la ALU proviene de un inmediato.
                ImmSrc = 3'b000;         // Inmediato de tipo I.
                ResultSrc = 0;           // El resultado proviene de la ALU.
                MemWrite = 0;            // No hay escritura en memoria.
                case (Funct3)
                    3'b000: ALUControl = 4'b0000; // ADDI: suma inmediata.
                    3'b111: ALUControl = 4'b1000; // ANDI: operación AND con inmediato.
                endcase
            end

            // Tipo S - SW (Store Word)
            7'b0100011: begin
                RegWrite = 0;            // No hay escritura en registros.
                ALUSrc = 1;              // El operando B es un inmediato (dirección de memoria).
                ImmSrc = 3'b001;         // Inmediato de tipo S.
                MemWrite = 1;            // Habilita escritura en memoria.
                ALUControl = 4'b0000;    // Calcula la dirección base + offset.
            end

            // Tipo U - LUI (Load Upper Immediate)
            7'b0110111: begin
                RegWrite = 1;            // Habilita escritura en registros.
                ALUSrc = 1;              // Operando inmediato.
                ImmSrc = 3'b011;         // Inmediato de tipo U.
                ResultSrc = 0;           // Resultado directo desde el inmediato.
                MemWrite = 0;            // No hay escritura en memoria.
                ALUControl = 4'b0000;    // No hay operación aritmética específica.
            end

            // Tipo I - LW (Load Word)
            7'b0000011: begin
                RegWrite = 1;            // Habilita escritura en registros.
                ALUSrc = 1;              // El operando B es un inmediato (dirección de memoria).
                ImmSrc = 3'b000;         // Inmediato de tipo I.
                ResultSrc = 1;           // El dato proviene de la memoria.
                MemWrite = 0;            // No hay escritura en memoria.
                ALUControl = 4'b0000;    // Calcula la dirección base + offset.
            end

            // Tipo B - BEQ, BNE (Branch)
            7'b1100011: begin
                RegWrite = 0;            // No hay escritura en registros.
                ALUSrc = 0;              // Ambos operandos provienen de registros.
                MemWrite = 0;            // No hay escritura en memoria.
                ImmSrc = 3'b010;         // Inmediato de tipo B.
                case (Funct3)
                    3'b000: ALUControl = 4'b0001; // BEQ: compara igualdad.
                    3'b001: ALUControl = 4'b0010; // BNE: compara desigualdad.
                    3'b101: ALUControl = 4'b1010; // BGE: compara mayor o igual.
                endcase
            end

            // Tipo J - JAL (Jump and Link)
            7'b1101111: begin
                RegWrite = 1;            // Habilita escritura en registros.
                ALUSrc = 1;              // Operando inmediato.
                ImmSrc = 3'b100;         // Inmediato de tipo J.
                PCSrc = 1;               // Habilita salto incondicional.
                ResultSrc = 1;           // Guarda PC+4 en el registro destino.
                ALUControl = 4'b0000;    // No hay operación aritmética específica.
            end

            // Tipo JALR - Jump and Link Register
            7'b1100111: begin
                RegWrite = 1;            // Habilita escritura en registros.
                ALUSrc = 1;              // Operando inmediato.
                ImmSrc = 3'b100;         // Inmediato de tipo J.
                PCSrc = 1;               // Salto incondicional basado en registro.
                ResultSrc = 1;           // Guarda PC+4 en el registro destino.
                ALUControl = 4'b0000;    // No hay operación aritmética específica.
            end

            // Caso por defecto: no se realiza ninguna operación.
            default: begin
                PCSrc = 0;
                ResultSrc = 0;
                MemWrite = 0;
                ALUControl = 4'b0000;
                ALUSrc = 0;
                ImmSrc = 0;
                RegWrite = 0;
            end
        endcase
    end
endmodule

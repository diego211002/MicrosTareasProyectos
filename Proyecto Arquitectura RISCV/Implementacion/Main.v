`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 19:49:51
// Design Name: 
// Module Name: Main
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
module Main (
    input clk,                 // Se�al de reloj para sincronizar las operaciones.
    input reset,               // Se�al de reinicio para inicializar los m�dulos.
    output [31:0] PC_out,      // Salida del valor actual del contador de programa.
    output [31:0] instruction, // Salida de la instrucci�n actual cargada desde la memoria.
    output [31:0] ALUResult,   // Salida del resultado de la ALU.
    output [31:0] mem_data,    // Salida de los datos le�dos de la memoria de datos.
    output wire [31:0] PCNext, // Valor calculado del siguiente PC.
    output wire [31:0] PCPlus4, // PC incrementado en 4 para la siguiente instrucci�n secuencial.
    output wire [31:0] ImmExt, // Valor inmediato extendido de la instrucci�n actual.
    output wire [31:0] PCTarget, // Direcci�n objetivo calculada para un salto o rama.
    output wire [31:0] rs1_data, // Datos del primer registro fuente.
    output wire [31:0] rs2_data, // Datos del segundo registro fuente.
    output wire [31:0] ALUOperandB, // Segundo operando de la ALU (inmediato o rs2_data).
    output wire [31:0] DataMemOut, // Datos le�dos desde la memoria de datos.
    output wire [31:0] ALUorMem, // Resultado seleccionado entre ALU y memoria.
    output wire [31:0] write_data, // Dato que ser� escrito en el registro destino.
    output wire [6:0] Opcode,       // Campo Opcode de la instrucci�n.
    output wire [2:0] Funct3,       // Campo Funct3 de la instrucci�n.
    output wire [6:0] Funct7,       // Campo Funct7 de la instrucci�n.
    output wire signed [4:0] raddr1, // Direcci�n del primer registro fuente.
    output wire signed [4:0] raddr2, // Direcci�n del segundo registro fuente.
    output wire [4:0] waddr,        // Direcci�n del registro destino.
    output wire [3:0] ALUControl,   // C�digo de operaci�n para la ALU.
    output wire PCSrc,              // Selecci�n para el PC (rama o secuencia).
    output wire ResultSrc,          // Selecci�n para el resultado (ALU o memoria).
    output wire MemWrite,           // Se�al para habilitar escritura en memoria.
    output wire ALUSrc,             // Selecci�n del segundo operando para la ALU (registro o inmediato).
    output wire RegWrite,           // Habilita escritura en el banco de registros.
    output wire [2:0] ImmSrc,       // Tipo de inmediato a extender.
    output wire br_taken,           // Indica si se toma la rama.
    output wire EnImm               // Habilita la entrada al PC basado en saltos o ramas.
);

    // Instancia del m�dulo Contador_PC que almacena el valor del contador de programa.
    Contador_PC pc (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),       // Entrada del pr�ximo valor del PC.
        .PC(PC_out)            // Salida del PC actual.
    );

    // Instancia del m�dulo PC_Plus4 para calcular PC + 4.
    PC_Plus4 pc_plus4 (
        .A(PC_out),            // Entrada del valor actual del PC.
        .B(PCPlus4)            // Salida del PC incrementado en 4.
    );

    // Instancia del m�dulo Instruction_Memory para obtener la instrucci�n actual.
    Instruction_Memory inst_mem (
        .addr(PC_out),         // Direcci�n de la instrucci�n basada en el PC.
        .instruction(instruction) // Instrucci�n obtenida.
    );

    // Extracci�n de campos de la instrucci�n (Opcode, Funct3, Funct7, etc.).
    assign Opcode = instruction[6:0];
    assign Funct3 = instruction[14:12];
    assign Funct7 = instruction[31:25];
    assign raddr1 = instruction[19:15]; // Direcci�n del primer registro fuente.
    assign raddr2 = instruction[24:20]; // Direcci�n del segundo registro fuente.
    assign waddr  = instruction[11:7];  // Direcci�n del registro destino.

    // Instancia del m�dulo Immediate_Decoder para extender el inmediato seg�n el tipo de instrucci�n.
    Immediate_Decoder imm_dec (
        .instruction(instruction),
        .ImmSrc(ImmSrc),       // Tipo de inmediato seg�n la instrucci�n.
        .ImmExt(ImmExt)        // Inmediato extendido.
    );

    // Instancia del m�dulo Branch_Control para determinar si se toma una rama.
    Branch_Control branch_ctrl (
        .rs1(rs1_data),        // Primer operando de la comparaci�n.
        .rs2(rs2_data),        // Segundo operando de la comparaci�n.
        .Funct3(Funct3),       // Campo Funct3 de la instrucci�n.
        .Opcode(Opcode),       // Opcode de la instrucci�n.
        .br_taken(br_taken)    // Indica si se toma la rama.
    );

    // Instancia del m�dulo Control_Unit para generar las se�ales de control.
    Control_Unit control_unit (
        .Op(Opcode),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .PCSrc(PCSrc),         // Selecci�n para el PC (rama o secuencia).
        .ResultSrc(ResultSrc), // Selecci�n para el resultado (ALU o memoria).
        .MemWrite(MemWrite),   // Se�al de escritura en memoria.
        .ALUControl(ALUControl), // C�digo de operaci�n para la ALU.
        .ALUSrc(ALUSrc),       // Selecci�n del segundo operando de la ALU.
        .ImmSrc(ImmSrc),       // Tipo de inmediato.
        .RegWrite(RegWrite)    // Habilita escritura en registros.
    );

    // Calcula si usar PC + 4 o un destino calculado (PCTarget) basado en saltos o ramas.
    assign EnImm = (br_taken | PCSrc);

    // Mux para seleccionar el pr�ximo valor del PC.
    Mux mux_pc (
        .A(PCPlus4),
        .B(PCTarget),
        .sel(EnImm),
        .C(PCNext)
    );

    // Instancia del banco de registros.
    Register_File reg_file (
        .clk(clk),
        .reset(reset),
        .reg_wr(RegWrite),      // Habilita escritura en el banco de registros.
        .raddr1(raddr1),        // Direcci�n del primer registro fuente.
        .raddr2(raddr2),        // Direcci�n del segundo registro fuente.
        .waddr(waddr),          // Direcci�n del registro destino.
        .wdata(write_data),     // Dato a escribir en el registro destino.
        .rdata1(rs1_data),      // Datos del primer registro fuente.
        .rdata2(rs2_data)       // Datos del segundo registro fuente.
    );

    // M�dulo para calcular el PC objetivo en caso de saltos o ramas.
    PC_Target pc_target (
        .PC(PC_out),
        .ImmExt(ImmExt),
        .PCTarget(PCTarget)     // Direcci�n objetivo calculada.
    );

    // Mux para seleccionar el segundo operando de la ALU (registro o inmediato).
    Mux mux_alu_operand (
        .A(rs2_data),
        .B(ImmExt),
        .sel(ALUSrc),
        .C(ALUOperandB)
    );

    // Instancia del m�dulo ALU.
    Alu alu (
        .A(rs1_data),           // Primer operando.
        .B(ALUOperandB),        // Segundo operando (registro o inmediato).
        .ALUControl(ALUControl), // Operaci�n a realizar.
        .C(ALUResult)           // Resultado de la ALU.
    );

    // Instancia del m�dulo de memoria de datos.
    Data_Memory data_mem (
        .addr(ALUResult),       // Direcci�n de memoria calculada por la ALU.
        .wdata(rs2_data),       // Datos a escribir en memoria.
        .load_type(Funct3),     // Tipo de acceso (byte, halfword, word).
        .MemWrite(MemWrite),    // Habilita escritura en memoria.
        .rst(reset),
        .clk(clk),
        .rdata(DataMemOut)      // Datos le�dos desde la memoria.
    );

    // Mux para seleccionar entre el resultado de la ALU y los datos de la memoria.
    Mux mux_result (
        .A(ALUResult),
        .B(DataMemOut),
        .sel(ResultSrc),
        .C(ALUorMem)
    );

    // M�dulo Write_Back para determinar el valor que se escribir� en el banco de registros.
    Write_Back write_back (
        .A(ALUorMem),
        .B(DataMemOut),
        .C(PCPlus4),
        .Opcode(Opcode),
        .wdata(write_data)
    );

    // M�dulo DumpMem para registrar datos en un archivo durante la simulaci�n.
    DumpMem dump_mem (
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite),
        .PC_out(PC_out),
        .mem_data(mem_data)
    );
    
    // Asignaci�n de salida para los datos de memoria.
    assign mem_data = DataMemOut;

endmodule // Fin del m�dulo Main.


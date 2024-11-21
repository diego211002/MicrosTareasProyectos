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
    input clk,                 // Señal de reloj para sincronizar las operaciones.
    input reset,               // Señal de reinicio para inicializar los módulos.
    output [31:0] PC_out,      // Salida del valor actual del contador de programa.
    output [31:0] instruction, // Salida de la instrucción actual cargada desde la memoria.
    output [31:0] ALUResult,   // Salida del resultado de la ALU.
    output [31:0] mem_data,    // Salida de los datos leídos de la memoria de datos.
    output wire [31:0] PCNext, // Valor calculado del siguiente PC.
    output wire [31:0] PCPlus4, // PC incrementado en 4 para la siguiente instrucción secuencial.
    output wire [31:0] ImmExt, // Valor inmediato extendido de la instrucción actual.
    output wire [31:0] PCTarget, // Dirección objetivo calculada para un salto o rama.
    output wire [31:0] rs1_data, // Datos del primer registro fuente.
    output wire [31:0] rs2_data, // Datos del segundo registro fuente.
    output wire [31:0] ALUOperandB, // Segundo operando de la ALU (inmediato o rs2_data).
    output wire [31:0] DataMemOut, // Datos leídos desde la memoria de datos.
    output wire [31:0] ALUorMem, // Resultado seleccionado entre ALU y memoria.
    output wire [31:0] write_data, // Dato que será escrito en el registro destino.
    output wire [6:0] Opcode,       // Campo Opcode de la instrucción.
    output wire [2:0] Funct3,       // Campo Funct3 de la instrucción.
    output wire [6:0] Funct7,       // Campo Funct7 de la instrucción.
    output wire signed [4:0] raddr1, // Dirección del primer registro fuente.
    output wire signed [4:0] raddr2, // Dirección del segundo registro fuente.
    output wire [4:0] waddr,        // Dirección del registro destino.
    output wire [3:0] ALUControl,   // Código de operación para la ALU.
    output wire PCSrc,              // Selección para el PC (rama o secuencia).
    output wire ResultSrc,          // Selección para el resultado (ALU o memoria).
    output wire MemWrite,           // Señal para habilitar escritura en memoria.
    output wire ALUSrc,             // Selección del segundo operando para la ALU (registro o inmediato).
    output wire RegWrite,           // Habilita escritura en el banco de registros.
    output wire [2:0] ImmSrc,       // Tipo de inmediato a extender.
    output wire br_taken,           // Indica si se toma la rama.
    output wire EnImm               // Habilita la entrada al PC basado en saltos o ramas.
);

    // Instancia del módulo Contador_PC que almacena el valor del contador de programa.
    Contador_PC pc (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),       // Entrada del próximo valor del PC.
        .PC(PC_out)            // Salida del PC actual.
    );

    // Instancia del módulo PC_Plus4 para calcular PC + 4.
    PC_Plus4 pc_plus4 (
        .A(PC_out),            // Entrada del valor actual del PC.
        .B(PCPlus4)            // Salida del PC incrementado en 4.
    );

    // Instancia del módulo Instruction_Memory para obtener la instrucción actual.
    Instruction_Memory inst_mem (
        .addr(PC_out),         // Dirección de la instrucción basada en el PC.
        .instruction(instruction) // Instrucción obtenida.
    );

    // Extracción de campos de la instrucción (Opcode, Funct3, Funct7, etc.).
    assign Opcode = instruction[6:0];
    assign Funct3 = instruction[14:12];
    assign Funct7 = instruction[31:25];
    assign raddr1 = instruction[19:15]; // Dirección del primer registro fuente.
    assign raddr2 = instruction[24:20]; // Dirección del segundo registro fuente.
    assign waddr  = instruction[11:7];  // Dirección del registro destino.

    // Instancia del módulo Immediate_Decoder para extender el inmediato según el tipo de instrucción.
    Immediate_Decoder imm_dec (
        .instruction(instruction),
        .ImmSrc(ImmSrc),       // Tipo de inmediato según la instrucción.
        .ImmExt(ImmExt)        // Inmediato extendido.
    );

    // Instancia del módulo Branch_Control para determinar si se toma una rama.
    Branch_Control branch_ctrl (
        .rs1(rs1_data),        // Primer operando de la comparación.
        .rs2(rs2_data),        // Segundo operando de la comparación.
        .Funct3(Funct3),       // Campo Funct3 de la instrucción.
        .Opcode(Opcode),       // Opcode de la instrucción.
        .br_taken(br_taken)    // Indica si se toma la rama.
    );

    // Instancia del módulo Control_Unit para generar las señales de control.
    Control_Unit control_unit (
        .Op(Opcode),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .PCSrc(PCSrc),         // Selección para el PC (rama o secuencia).
        .ResultSrc(ResultSrc), // Selección para el resultado (ALU o memoria).
        .MemWrite(MemWrite),   // Señal de escritura en memoria.
        .ALUControl(ALUControl), // Código de operación para la ALU.
        .ALUSrc(ALUSrc),       // Selección del segundo operando de la ALU.
        .ImmSrc(ImmSrc),       // Tipo de inmediato.
        .RegWrite(RegWrite)    // Habilita escritura en registros.
    );

    // Calcula si usar PC + 4 o un destino calculado (PCTarget) basado en saltos o ramas.
    assign EnImm = (br_taken | PCSrc);

    // Mux para seleccionar el próximo valor del PC.
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
        .raddr1(raddr1),        // Dirección del primer registro fuente.
        .raddr2(raddr2),        // Dirección del segundo registro fuente.
        .waddr(waddr),          // Dirección del registro destino.
        .wdata(write_data),     // Dato a escribir en el registro destino.
        .rdata1(rs1_data),      // Datos del primer registro fuente.
        .rdata2(rs2_data)       // Datos del segundo registro fuente.
    );

    // Módulo para calcular el PC objetivo en caso de saltos o ramas.
    PC_Target pc_target (
        .PC(PC_out),
        .ImmExt(ImmExt),
        .PCTarget(PCTarget)     // Dirección objetivo calculada.
    );

    // Mux para seleccionar el segundo operando de la ALU (registro o inmediato).
    Mux mux_alu_operand (
        .A(rs2_data),
        .B(ImmExt),
        .sel(ALUSrc),
        .C(ALUOperandB)
    );

    // Instancia del módulo ALU.
    Alu alu (
        .A(rs1_data),           // Primer operando.
        .B(ALUOperandB),        // Segundo operando (registro o inmediato).
        .ALUControl(ALUControl), // Operación a realizar.
        .C(ALUResult)           // Resultado de la ALU.
    );

    // Instancia del módulo de memoria de datos.
    Data_Memory data_mem (
        .addr(ALUResult),       // Dirección de memoria calculada por la ALU.
        .wdata(rs2_data),       // Datos a escribir en memoria.
        .load_type(Funct3),     // Tipo de acceso (byte, halfword, word).
        .MemWrite(MemWrite),    // Habilita escritura en memoria.
        .rst(reset),
        .clk(clk),
        .rdata(DataMemOut)      // Datos leídos desde la memoria.
    );

    // Mux para seleccionar entre el resultado de la ALU y los datos de la memoria.
    Mux mux_result (
        .A(ALUResult),
        .B(DataMemOut),
        .sel(ResultSrc),
        .C(ALUorMem)
    );

    // Módulo Write_Back para determinar el valor que se escribirá en el banco de registros.
    Write_Back write_back (
        .A(ALUorMem),
        .B(DataMemOut),
        .C(PCPlus4),
        .Opcode(Opcode),
        .wdata(write_data)
    );

    // Módulo DumpMem para registrar datos en un archivo durante la simulación.
    DumpMem dump_mem (
        .clk(clk),
        .reset(reset),
        .MemWrite(MemWrite),
        .PC_out(PC_out),
        .mem_data(mem_data)
    );
    
    // Asignación de salida para los datos de memoria.
    assign mem_data = DataMemOut;

endmodule // Fin del módulo Main.


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 18:56:12
// Design Name: 
// Module Name: Data_Memory
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
module Data_Memory(
    input signed [31:0] addr,   // Dirección de acceso a memoria con signo
    input [31:0] wdata,         // Datos a escribir en memoria
    input [2:0] load_type,      // Tipo de carga (byte, halfword, word)
    input MemWrite,             // Señal de escritura en memoria
    input clk,                  // Reloj
    input rst,                  // Señal de reinicio
    output reg [31:0] rdata     // Datos leídos desde la memoria
);

    reg [31:0] memory [1023:0]; // Memoria de 1 KB
    reg [31:0] data;            // Almacena temporalmente el dato leído
    integer i;                  // Contador para limpiar memoria

    // Genera un índice de memoria válido a partir de la dirección
    wire [9:0] mem_index = addr[31] ? (addr[9:0] + 512) : addr[9:0];

    // Inicialización de la memoria a cero
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 0;
        end
    end

    // Bloque de lectura
    always @(*) begin
        data = memory[mem_index]; // Leer la palabra completa en la dirección traducida
        case (load_type)
            3'b000: rdata = {{24{data[7]}}, data[7:0]};      // Load byte (Signed)
            3'b001: rdata = {{16{data[15]}}, data[15:0]};    // Load halfword (Signed)
            3'b010: rdata = data;                            // Load word
            3'b100: rdata = {24'b0, data[7:0]};              // Load byte (Unsigned)
            3'b101: rdata = {16'b0, data[15:0]};             // Load halfword (Unsigned)
            default: rdata = 0;                              // Valor por defecto
        endcase
    end

    // Escritura en memoria y reinicio
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Borrar toda la memoria cuando rst está activo
            for (i = 0; i < 1024; i = i + 1) begin
                memory[i] <= 0;
            end
        end
        else if (MemWrite) begin
            // Escritura en memoria según el tipo de carga
            case (load_type)
                3'b000: memory[mem_index] <= {24'b0, wdata[7:0]};        // Store byte (relleno con ceros)
                3'b001: memory[mem_index] <= {16'b0, wdata[15:0]};       // Store halfword (relleno con ceros)
                3'b010: memory[mem_index] <= wdata;                      // Store word (32 bits)
                default: ;                                               // No acción para otros casos
            endcase
        end
    end
endmodule


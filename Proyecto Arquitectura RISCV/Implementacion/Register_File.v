`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 18:50:15
// Design Name: 
// Module Name: Register_File
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
module Register_File(           // M�dulo Register_File: implementa un banco de registros de 32 registros.
    input clk,                  // Se�al de reloj para sincronizar operaciones de escritura.
    input reset,                // Se�al de reinicio para inicializar todos los registros a 0.
    input reg_wr,               // Se�al de control para habilitar escritura en el banco de registros.
    input [4:0] raddr1,         // Direcci�n del primer registro a leer (5 bits para seleccionar entre 32 registros).
    input [4:0] raddr2,         // Direcci�n del segundo registro a leer (5 bits para seleccionar entre 32 registros).
    input [4:0] waddr,          // Direcci�n del registro donde se escribir�n los datos.
    input [31:0] wdata,         // Datos que se escribir�n en el registro seleccionado.
    output reg [31:0] rdata1,   // Datos le�dos del registro indicado por raddr1.
    output reg [31:0] rdata2    // Datos le�dos del registro indicado por raddr2.
);

    // Banco de registros: 32 registros de 32 bits cada uno.
    reg [31:0] registerfile [31:0];

    // Variable entera para iterar sobre los registros durante la inicializaci�n.
    integer i;

    // Bloque siempre activado en flanco positivo de reloj o en el reinicio.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Si se activa `reset`, todos los registros se inicializan a 0.
            for (i = 0; i < 32; i = i + 1)
                registerfile[i] <= 32'b0;
        end else if (reg_wr && (waddr != 0)) begin
            // Si `reg_wr` est� activo y `waddr` no es 0 (el registro x0 siempre debe ser 0):
            registerfile[waddr] <= wdata; // Escribe el valor `wdata` en el registro especificado por `waddr`.
        end
    end

    // Bloque combinacional para leer datos de los registros.
    always @(*) begin
        // `raddr1` y `raddr2` determinan los registros de los cuales se leer�n los datos.
        rdata1 = registerfile[raddr1];
        rdata2 = registerfile[raddr2];
    end

endmodule

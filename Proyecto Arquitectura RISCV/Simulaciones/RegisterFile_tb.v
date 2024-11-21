`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 10:09:09
// Design Name: 
// Module Name: RegisterFile_tb
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


module RegisterFile_tb; // Módulo de testbench para el banco de registros (RegisterFile)

    // Declaración de registros y cables para las entradas y salidas del módulo
    reg clk;                           // Señal de reloj
    reg reset;                         // Señal de reset
    reg reg_wr;                        // Señal de habilitación de escritura en registro
    reg [4:0] raddr1, raddr2, waddr;   // Direcciones de los registros para leer y escribir
    reg [31:0] wdata;                  // Dato de entrada para escritura
    wire [31:0] rdata1, rdata2;        // Datos de salida de los registros leídos

    // Instancia del módulo RegisterFile
    Register_File uut (
        .clk(clk), 
        .reset(reset), 
        .reg_wr(reg_wr), 
        .raddr1(raddr1), 
        .raddr2(raddr2), 
        .waddr(waddr), 
        .wdata(wdata), 
        .rdata1(rdata1), 
        .rdata2(rdata2)
    );

    // Inicialización de la señal de reloj
    initial begin
        clk = 0; // Iniciar el reloj en 0
        forever #5 clk = ~clk; // Generar un ciclo de reloj de 10 unidades de tiempo
    end

    // Proceso de prueba para el módulo RegisterFile
    initial begin
        // Inicializar entradas
        reset = 1;                // Activar reset
        reg_wr = 1;               // Desactivar escritura al inicio
        raddr1 = 5'd0010011;            // Dirección de lectura 1 en 0
        raddr2 = 5'd00000;            // Dirección de lectura 2 en 0
        waddr = 7'd1111111;             // Dirección de escritura en 0
        wdata = 32'd0;            // Dato de escritura en 0

        #10 reset = 0;            // Desactivar reset después de 10 unidades de tiempo

        // Prueba de escritura en un registro
        waddr = 5'd1;             // Dirección de escritura en el registro 1
        wdata = 32'hDEADBEEF;     // Dato de escritura en hexadecimal
        reg_wr = 1;               // Activar la escritura en registro
        #10;                      // Esperar 10 unidades de tiempo para que se capture el dato en el flanco negativo

        reg_wr = 0;               // Desactivar la escritura

        // Prueba de lectura de los datos escritos
        raddr1 = 5'd1;            // Dirección de lectura en el registro 1
        #10;                      // Esperar 10 unidades de tiempo
        $display("Lectura de raddr1 = %d: rdata1 = %h (Esperado: DEADBEEF)", raddr1, rdata1); // Mostrar el valor leído y el esperado

        // Prueba de escritura y lectura en otro registro
        waddr = 5'd2;             // Dirección de escritura en el registro 2
        wdata = 32'hCAFEBABE;     // Nuevo dato de escritura en hexadecimal
        reg_wr = 1;               // Activar la escritura
        #10;                      // Esperar 10 unidades de tiempo para capturar el dato en el flanco negativo

        reg_wr = 0;               // Desactivar la escritura
        raddr2 = 5'd2;            // Dirección de lectura en el registro 2
        #10;                      // Esperar 10 unidades de tiempo
        $display("Lectura de raddr2 = %d: rdata2 = %h (Esperado: CAFEBABE)", raddr2, rdata2); // Mostrar el valor leído y el esperado

        // Prueba de que el registro 0 se mantiene en 0
        waddr = 5'd0;             // Intentar escribir en el registro 0
        wdata = 32'hFFFFFFFF;     // Dato que se intentará escribir
        reg_wr = 1;               // Activar la escritura
        #10;                      // Esperar 10 unidades de tiempo

        reg_wr = 0;               // Desactivar la escritura
        raddr1 = 5'd0;            // Dirección de lectura en el registro 0
        #10;                      // Esperar 10 unidades de tiempo
        $display("Lectura de raddr1 = %d: rdata1 = %h (Esperado: 0)", raddr1, rdata1); // Confirmar que el registro 0 permanece en 0

        // Finalizar la simulación
        $finish;
    end

endmodule

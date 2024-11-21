`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2024 01:58:06 AM
// Design Name: 
// Module Name: DumpMem
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

module DumpMem(                   // Módulo DumpMem: registra datos de memoria en un archivo durante la simulación.
    input clk,                    // Señal de reloj para sincronizar la escritura.
    input reset,                  // Señal de reinicio (puede ser utilizada para lógica adicional).
    input MemWrite,               // Señal que indica si hay escritura en memoria (puede ser extendida según necesidades).
    input [31:0] PC_out,          // Dirección actual del contador de programa (PC).
    input [31:0] mem_data         // Datos actuales de la memoria a escribir en el archivo.
);

    // Declaración del archivo para escritura
    integer file;
    
    // Inicialización del archivo
    initial begin
        // Abrir el archivo "DumpMem.txt" en modo escritura ("w")
        file = $fopen("DumpMem.txt", "w"); 
        if (file == 0) begin
            // Si no se puede abrir el archivo, mostrar un mensaje de error y detener la simulación.
            $display("Error al abrir el archivo de salida");
            $finish;
        end
    end

    // Escritura en el archivo en cada flanco positivo de reloj
    always @(posedge clk) begin
        if (reset) begin
            // Si `reset` está activo, no realizar ninguna operación de escritura.
            // Este bloque puede usarse para inicializar valores adicionales si es necesario.
        end else begin
            // Escribir en el archivo el valor del PC y los datos de memoria.
            // Formato: "PC_out: [dirección en hexadecimal] | Mem_Data: [datos en hexadecimal]"
            $fwrite(file, "PC_out: %h | Mem_Data: 0x%h\n", PC_out, mem_data);
        end

        // Condición para detener la simulación: si `PC_out` supera 0x84.
        if (PC_out > 32'h84) begin
            // Mostrar mensaje en consola.
            $display("PC_out ha superado 0x84. Deteniendo la simulación.");
            // Cerrar el archivo antes de finalizar.
            $fclose(file);
            // Finalizar la simulación.
            $finish;
        end
    end

    // Cierre del archivo al final de la simulación
    initial begin
        #1000;                 // Espera 1000 unidades de tiempo de simulación (ajustable según el diseño).
        $fclose(file);         // Cierra el archivo automáticamente después de este tiempo.
    end

endmodule

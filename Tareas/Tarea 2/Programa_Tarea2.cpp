#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>

int main() {
    // Archivo donde se guardarán los números
    const std::string filename = "numeros.txt";

    // Crear y abrir el archivo
    std::ofstream outfile(filename);

    if (!outfile) {
        std::cerr << "No se pudo abrir el archivo para escritura." << std::endl;
        return 1;
    }

    // Iniciar el contador de tiempo
    auto start_time = std::chrono::high_resolution_clock::now();

    // Escribir números del 0 al 100 en el archivo
    for (int i = 0; i <= 100; ++i) {
        outfile << i << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    // Finalizar el contador de tiempo
    auto end_time = std::chrono::high_resolution_clock::now();

    // Calcular la duración en segundos
    std::chrono::duration<double> elapsed_seconds = end_time - start_time;

    // Mostrar el tiempo transcurrido en generar los números
    std::cout << "Tiempo transcurrido en generar los números: " << elapsed_seconds.count() << " segundos." << std::endl;

    outfile.close();

    // Abrir el archivo para lectura
    std::ifstream infile(filename);

    if (!infile) {
        std::cerr << "No se pudo abrir el archivo para lectura." << std::endl;
        return 1;
    }

    // Leer y mostrar números del archivo en pantalla
    int number;
    while (infile >> number) {
        std::cout << number << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    infile.close();

    return 0;
}
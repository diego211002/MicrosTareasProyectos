#include <iostream>
#include <fstream>
#include <chrono>
#include <thread>
#include <mutex>
#include <condition_variable>

std::mutex mtx;
std::condition_variable cv;
bool escrituraCompleta = false;

void escribirNumeros(const std::string& filename) {
    std::ofstream outfile(filename);

    if (!outfile) {
        std::cerr << "No se pudo abrir el archivo para escritura." << std::endl;
        return;
    }

    // Escribir números del 0 al 100 en el archivo
    for (int i = 0; i <= 100; ++i) {
        outfile << i << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    outfile.close();

    // Notificar que la escritura ha terminado
    std::lock_guard<std::mutex> lock(mtx);
    escrituraCompleta = true;
    cv.notify_one();
}

void leerNumeros(const std::string& filename) {
    std::unique_lock<std::mutex> lock(mtx);
    cv.wait(lock, [] { return escrituraCompleta; });

    std::ifstream infile(filename);

    if (!infile) {
        std::cerr << "No se pudo abrir el archivo para lectura." << std::endl;
        return;
    }

    // Leer y mostrar números del archivo en pantalla
    int number;
    while (infile >> number) {
        std::cout << number << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

    infile.close();
}

int main() {
    const std::string filename = "numeros.txt";

    // Iniciar el contador de tiempo
    auto start_time = std::chrono::high_resolution_clock::now();

    // Crear dos hilos: uno para escribir y otro para leer
    std::thread writer_thread(escribirNumeros, filename);
    std::thread reader_thread(leerNumeros, filename);

    // Esperar a que ambos hilos terminen
    writer_thread.join();
    reader_thread.join();

    // Finalizar el contador de tiempo
    auto end_time = std::chrono::high_resolution_clock::now();

    // Calcular la duración en segundos
    std::chrono::duration<double> elapsed_seconds = end_time - start_time;

    // Mostrar el tiempo transcurrido en completar ambas tareas
    std::cout << "Tiempo transcurrido en completar ambas tareas: " << elapsed_seconds.count() << " segundos." << std::endl;

    return 0;
}
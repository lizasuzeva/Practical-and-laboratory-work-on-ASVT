#include <iostream>
#include <iomanip>
#include <windows.h>
using namespace std;

extern "C" float FindMin(float start, float end, float step);

int main() {
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);

    // Фиксированный интервал по варианту 17
    float start = -1.0f;
    float end = 1.0f;
    float step;

    cout << "========================================" << endl;
    cout << "Вариант 17" << endl;
    cout << "Функция: f(x) = (ctg(x) + sin(x)) / sin(x)" << endl;
    cout << "Интервал: [-1; 1]" << endl;
    cout << "========================================" << endl;

    // Пользователь вводит шаг
    cout << "Введите шаг (например, 0.1 или 0.01): ";
    cin >> step;

    float min_value = FindMin(start, end, step);

    cout << fixed << setprecision(6);
    cout << "\nМинимальное значение функции на интервале = " << min_value << endl;

    return 0;
}
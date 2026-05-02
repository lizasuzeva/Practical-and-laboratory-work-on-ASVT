#include <cmath>

extern "C" float func(float x) {
    // Защита от деления на ноль (x = 0)
    if (fabs(x) < 0.0001f) {
        return 1e10f;  // большое число, не влияющее на минимум
    }

    double sin_x = sin(x);
    double cos_x = cos(x);
    double ctg_x = cos_x / sin_x;
    double result = (ctg_x + sin_x) / sin_x;

    return (float)result;
}
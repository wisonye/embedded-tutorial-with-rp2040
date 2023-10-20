#include <stdio.h>
#include "pico/stdlib.h"

typedef uint32_t u32;
typedef volatile u32 reg_u32;

#define LED_PIN 2

//
// Purpose that base metal boot in 48MHz (48,000,000 tick in one second) without clock configuration
//
#define CLK_SPEED 48000000
#define HALF_SECOND_DELAY (u32)(CLK_SPEED/2)
#define ONE_QUARTER_SECOND_DELAY (u32)(CLK_SPEED/4)
#define ONE_EIGHTH_SECOND_DELAY (u32)(CLK_SPEED/8)

//
// Simulate `delay` function
//
void simulate_delay(void) {
	volatile u32 _ = 0;
	for (u32 i=0; i<ONE_QUARTER_SECOND_DELAY; i++) {
		_ = i;
	}
}

//
//
//
int main(void) {
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);
    while (true) {
        gpio_put(LED_PIN, 1);
		simulate_delay();
        gpio_put(LED_PIN, 0);
        simulate_delay();
    }

    return 0;
}

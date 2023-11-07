#include <stdio.h>

#include "pico/stdlib.h"

///
///
///
void print_stack_ptr(void) {
    void *p = NULL;
    printf("\n>>> Stack pointer address: %p", (void *)&p);
}

///
///
///
void* get_program_counter_ptr(void)
{
#ifdef __GNUC__
  void *pc;

  __asm__ __volatile__ ("mov %0, pc" : "=r"(pc));
  return pc;
#else
  #warning "only for GCC"
  return NULL;
#endif
}

///
///
///
int main(void) {
    stdio_init_all();
    printf("\n>>> [ Print Pointer Address Demo]");

	void *pc_ptr = get_program_counter_ptr();
	printf("\n>>> Program counter pointer address: %p", pc_ptr);

	print_stack_ptr();

    while (1) {
    }

    return 0;
}

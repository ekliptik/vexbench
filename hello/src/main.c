// Copyright (c) 2016 Spinal HDL contributors
// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdio.h>

#include "uart.h"

uint64_t start;
extern void _exit(int i);

#define CORETIMETYPE uint64_t
#define read_csr(reg) ({ uint32_t __tmp; \
    asm volatile ("csrr %0, " #reg : "=r"(__tmp)); \
    __tmp; })


void __attribute__ ((noinline))
start_trigger ()
{
    uint32_t hi = read_csr(mcycleh);
    uint32_t lo = read_csr(mcycle);
    start = (uint64_t)(((uint64_t)hi) << 32) | lo;
}

void __attribute__ ((noinline))
stop_trigger ()
{
    uint32_t hi = read_csr(mcycleh);
    uint32_t lo = read_csr(mcycle);
    uint64_t end = (uint64_t)(((uint64_t)hi) << 32) | lo;
    uint64_t delta = end - start;
    char buffer[32];
    printf("mcycle timer delta: 0x%016X\n", delta);
}

int main() {
	start_trigger();
    for (int i = 0; i < 3; i++) {
        printf("Hi from Verilated VexRISCV! Oooh a float: %f\n", (float)i);
    }
	stop_trigger();
	_exit(0);
    return -1;
}

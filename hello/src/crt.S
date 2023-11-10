// Copyright (c) 2016 Spinal HDL contributors
// SPDX-License-Identifier: MIT

.global crtStart
.global main
.global irqCallback

#define MSTATUS_FS          0x00006000
#define MSTATUS_XS          0x00018000

    .section	.start_jump,"ax",@progbits
crtStart:
  //long jump to allow crtInit to be anywhere
  //do it always in 12 bytes
  lui x2,       %hi(crtInit)
  addi x2, x2,  %lo(crtInit)
  jalr x1,x2
  nop

.section .text

.global  trap_entry
.align 5
trap_entry:
  li a0, 55
  j _exit

  .text


crtInit:
  .option push
  .option norelax
  la gp, __global_pointer$
  .option pop
  la sp, _stack_start

bss_init:
  la a0, _bss_start
  la a1, _bss_end
bss_loop:
  beq a0,a1,bss_done
  sw zero,0(a0)
  add a0,a0,4
  j bss_loop
bss_done:

ctors_init:
  la a0, _ctors_start
  addi sp,sp,-4
ctors_loop:
  la a1, _ctors_end
  beq a0,a1,ctors_done
  lw a3,0(a0)
  add a0,a0,4
  sw a0,0(sp)
  jalr  a3
  lw a0,0(sp)
  j ctors_loop
ctors_done:
  addi sp,sp,4


  li t0, MSTATUS_FS | MSTATUS_XS
  csrs mstatus, t0
  call main
infinitLoop:
  ebreak
  j infinitLoop

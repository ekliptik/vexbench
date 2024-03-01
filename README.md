# VexBench: VexRISCV for compiler benchmarking

Adapted HDL and example code from VexRISCV repository for benchmarking compilers for a realistic simulated 32-bit target. Currently available: only RV32IMAFC+Zicsr, no double precision FPU. Tested for hacked-together llvm, and gcc from xpack.

# Prerequisites

+ GNU make
+ a target compiler
+ a host compiler
+ gnu binutils with the `$RISCV_NAME` prefix (feel free to override)
+ verilator

# Build and run

```bash
pushd hello
# If gcc:
# CC=riscv-foo-bar-gcc RISCV_PATH=/gcc/root/dir make
# If clang with missing multilib selection:
MULTILIB_HACK=yes RISCV_PATH=/clang/root/dir make 
popd

pushd cpu
make IBUS=CACHED IBUS_DATA_WIDTH=32 COMPRESSED=yes ATOMIC=yes DBUS=CACHED DBUS_LOAD_DATA_WIDTH=32 DBUS_STORE_DATA_WIDTH=32 MUL=yes DIV=yes SUPERVISOR=no CSR=yes LRSC=yes AMO=yes TRACE=yes TRACE_ACCESS=on DEBUG_PLUGIN=no DBUS=CACHED IBUS=CACHED WITH_RISCV_REF=yes RUN_HEX=on
popd
```

# Regenerate Verilog

+ get `sbt`
+ follow instructions in cpu/VexBencher32.scala comments
+ use above but remove `run` from the `make` invocation in `cpu/`

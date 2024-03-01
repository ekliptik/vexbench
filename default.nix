# Copyright HighTec EDV-Systeme GmbH
# SPDX-License-Identifier: MIT

with import <nixpkgs> {};

clangStdenv.mkDerivation {
  name = "VexBench32";
  buildInputs = with pkgs; [
    gnumake
    which
    (verilator.override { stdenv = pkgs.clangStdenv; })
    llvmPackages.bintools
    zlib
  ];
  propagatedBuildInputs = with pkgs; [ zlib ];

  srcs = [ ./. ];

  buildPhase = ''
    pushd cpu
    # For waveform .fst: TRACE=yes
    make IBUS=CACHED IBUS_DATA_WIDTH=32 COMPRESSED=yes ATOMIC=yes DBUS=CACHED DBUS_LOAD_DATA_WIDTH=32 DBUS_STORE_DATA_WIDTH=32 MUL=yes DIV=yes SUPERVISOR=no CSR=yes LRSC=yes AMO=yes TRACE=no TRACE_ACCESS=off DEBUG_PLUGIN=no DBUS=CACHED IBUS=CACHED WITH_RISCV_REF=no RUN_HEX=on
    popd # cpu
  '';

  installPhase = ''
    mkdir -p $out/
    cp cpu/obj_dir/VVexRiscv $out/
  '';
}

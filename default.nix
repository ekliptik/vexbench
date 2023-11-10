with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "yourBuildName";
  buildInputs = with pkgs; [
    gnumake
    clang
    verilator
    zlib
  ];
  propagatedBuildInputs = with pkgs; [ zlib ];

  srcs = [ ./. ];
  # shellHook = '' IBUS=CACHED IBUS_DATA_WIDTH=32 COMPRESSED=no DBUS=CACHED DBUS_LOAD_DATA_WIDTH=32 DBUS_STORE_DATA_WIDTH=32 MUL=yes DIV=yes SUPERVISOR=no CSR=yes TRACE=on VEXRISCV_FILE=../../../../Murax.v RUN_HEX=/home/emil/work/vexriscv-support/build/gcd_world.hex
  # '';

  buildPhase = ''
    # cd hello
    # make 
    # cd ..
    cd cpu
    make IBUS=CACHED IBUS_DATA_WIDTH=32 COMPRESSED=yes ATOMIC=yes DBUS=CACHED DBUS_LOAD_DATA_WIDTH=32 DBUS_STORE_DATA_WIDTH=32 MUL=yes DIV=yes SUPERVISOR=no CSR=yes LRSC=yes AMO=yes TRACE=yes TRACE_ACCESS=on DEBUG_PLUGIN=no DBUS=CACHED IBUS=CACHED WITH_RISCV_REF=no RUN_HEX=../hello/build/gcd_world.hex
  '';

  installPhase = ''
    mkdir -p $out/logs
    cp *.log* *.gtkw *.fst $out/logs/
  '';
  # dontInstall = true;
}

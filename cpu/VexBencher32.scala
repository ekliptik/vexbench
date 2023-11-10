// Copyright (c) 2016 Spinal HDL contributors
// SPDX-License-Identifier: MIT

package vexriscv.demo

import vexriscv.plugin._
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import vexriscv.{plugin, VexRiscv, VexRiscvConfig}
import spinal.core._
import vexriscv.ip.fpu.FpuParameter


object VexBencher32 extends App{
  def cpu() = new VexRiscv(
    config = VexRiscvConfig(
      plugins = List(
        new StaticMemoryTranslatorPlugin(
          ioRange = (x => x(31 downto 28) === 0xF)
        ),
      new IBusCachedPlugin(
        prediction = DYNAMIC,
        compressedGen = true,
        injectorStage = true, // needed for compressedGen
        config = InstructionCacheConfig( // needed for FPU
          cacheSize = 4096,
          bytePerLine = 32,
          wayCount = 1,
          addressWidth = 32,
          cpuDataWidth = 32,
          memDataWidth = 32,
          catchIllegalAccess = true,
          catchAccessFault = true,
          asyncTagMemory = false,
          twoCycleRam = true,
          twoCycleCache = true
        ),
        memoryTranslatorPortConfig = MmuPortConfig(
          portTlbSize = 4
        )
      ),
      new DBusCachedPlugin(
        config = new DataCacheConfig(
          cacheSize         = 4096,
          bytePerLine       = 32,
          wayCount          = 1,
          addressWidth      = 32,
          cpuDataWidth      = 32, // needed for rv32, forces no double fpu
          memDataWidth      = 32, // needed for rv32, forces no double fpu
          catchAccessError  = true,
          catchIllegal      = true,
          catchUnaligned    = true
        ),
        memoryTranslatorPortConfig = MmuPortConfig(
          portTlbSize = 6
        )
      ),
        new DecoderSimplePlugin(
          catchIllegalInstruction = true
        ),
        new RegFilePlugin(
          regFileReadyKind = plugin.SYNC,
          zeroBoot = false
        ),
        new IntAluPlugin,
        new SrcPlugin(
          separatedAddSub = false,
          executeInsertion = true
        ),
        new FullBarrelShifterPlugin,
        new HazardSimplePlugin(
          bypassExecute           = true,
          bypassMemory            = true,
          bypassWriteBack         = true,
          bypassWriteBackBuffer   = true,
          pessimisticUseSrc       = false,
          pessimisticWriteRegFile = false,
          pessimisticAddressMatch = false
        ),
        new MulPlugin,
        new DivPlugin,
        new CsrPlugin(CsrPluginConfig(
          catchIllegalAccess = false,
          mvendorid      = null,
          marchid        = null,
          mimpid         = null,
          mhartid        = null,
          misaExtensionsInit = 66,
          misaAccess     = CsrAccess.NONE,
          mtvecAccess    = CsrAccess.NONE,
          mtvecInit      = 0x80000020l,
          mepcAccess     = CsrAccess.READ_WRITE,
          mscratchGen    = false,
          mcauseAccess   = CsrAccess.READ_ONLY,
          mbadaddrAccess = CsrAccess.READ_ONLY,
          mcycleAccess   = CsrAccess.READ_ONLY,
          minstretAccess = CsrAccess.NONE,
          ecallGen       = false,
          wfiGenAsWait         = false,
          ucycleAccess   = CsrAccess.NONE,
          uinstretAccess = CsrAccess.NONE
        )),
        new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset"))),
        new BranchPlugin(
          earlyBranch = false,
          catchAddressMisaligned = true
        ),
        new FpuPlugin(
            p = FpuParameter(withDouble = false) // back from true
        ),
        new YamlPlugin("cpu0.yaml")
      )
    )
  )

  SpinalVerilog(cpu())
}

<div align="center">

<img src="https://riscv.org/wp-content/uploads/2020/06/riscv-color.svg" alt="RISC-V Logo" width="220" />

<br><br>

<img src="https://img.shields.io/badge/RISC--V-RV32I-blue?style=for-the-badge&logo=riscv&logoColor=white" />
<img src="https://img.shields.io/badge/HDL-Verilog-orange?style=for-the-badge" />
<img src="https://img.shields.io/badge/Simulation-Vivado-red?style=for-the-badge" />
<img src="https://img.shields.io/badge/Pipeline-5--Stage-green?style=for-the-badge" />
<img src="https://img.shields.io/badge/Status-Verified-brightgreen?style=for-the-badge" />

# RV32I 5-Stage Pipelined RISC-V Processor

**A fully verified, hazard-resilient 32-bit RISC-V processor implementation in Verilog HDL**

[Overview](#-overview) · [Architecture](#-pipeline-architecture) · [Features](#-implemented-isa-features) · [Hazard Handling](#-hazard-handling) · [Verification](#-verification) · [Structure](#-repository-structure) · [Lessons Learned](#-lessons-learned) · [Future Work](#-future-improvements)

</div>

---

## Overview

This project is a complete Verilog implementation of an **RV32I 5-stage pipelined RISC-V processor**, built from scratch to explore the fundamentals of modern processor microarchitecture. It covers the full design flow — from instruction fetch to register writeback — with proper handling of data hazards, control hazards, and pipeline stalls.

Developed as an in-depth study of computer architecture, the design prioritizes correctness, clarity, and performance-oriented techniques.

**Key highlights:**

- Classic 5-stage pipeline: IF → ID → EX → MEM → WB
- Full data forwarding (MEM→EX, WB→EX) to minimize stalls
- Load-use hazard detection with automatic pipeline stalling
- Control hazard resolution via pipeline flushing at the EX stage
- Complete RV32I base integer instruction set support
- Functional verification across 10 targeted test cases — all passing

---

## Pipeline Architecture

```
 ┌─────────────────────────────────────────────────────────────────────┐
 │                    5-Stage Pipeline Datapath                        │
 └─────────────────────────────────────────────────────────────────────┘

  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
  │    IF    │───▶│    ID    │───▶│    EX    │───▶│   MEM    │───▶│    WB  │
  │          │    │          │    │          │    │          │    │          │
  │ PC Update│    │ Decode   │    │ ALU Ops  │    │ LW / SW  │    │ Reg Write│
  │ Inst Mem │    │ Reg Read │    │ Branch   │    │ Data Mem │    │ ALU / Ld │
  │ PC + 4   │    │ Imm Gen  │    │ Jmp Tgt  │    │ Interface│    │ PC+4 Ret │
  │          │    │ Ctrl Sig │    │ Fwd Mux  │    │          │    │          │
  └──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
       │               │               │
       │         ┌─────▼─────┐   ┌─────▼──────────────────────┐
       │         │  Hazard   │   │      Forwarding Unit       │
       └──────▶  │ Detection │  │   MEM→EX  │  WB→EX         │ 
                 │   Unit    │   └────────────────────────────┘
                 └───────────┘
```

### Stage Breakdown

| Stage | Description |
|-------|-------------|
| **IF** — Instruction Fetch | PC update, instruction memory read, PC+4 generation |
| **ID** — Instruction Decode | Register file reads, immediate generation, control signal decode |
| **EX** — Execute | ALU operations, branch comparison, JAL/JALR target calculation |
| **MEM** — Memory Access | Load (`LW`) and store (`SW`) via data memory interface |
| **WB** — Write Back | Result writeback: ALU result, load data, or PC+4 for jumps |

---

## Implemented ISA Features

The processor implements the full **RV32I base integer instruction set**, including arithmetic (`ADD`, `ADDI`, `SUB`), logical (`AND`, `OR`, `XOR`), shift (`SLL`, `SRL`, `SRA`), comparison (`SLT`, `SLTU`), memory (`LW`, `SW`), branch (`BEQ`, `BNE`), jump (`JAL`, `JALR`), and upper immediate (`LUI`, `AUIPC`) instructions.

---

## Hazard Handling

Correct pipelined execution requires resolving three classes of hazards. All three are handled in this design.

### Data Forwarding — RAW Hazard Resolution

Rather than stalling for every dependent instruction, the forwarding unit routes results directly from later pipeline stages back to the EX stage inputs:

```
  EX stage needs x1, but x1 is being written in MEM → forward from MEM/WB register
  EX stage needs x1, but x1 is being written in WB  → forward from WB stage output
```

Forwarding paths implemented:

```
  MEM/WB.ALUResult  ──────▶  EX ALU Input A / B
  WB.WriteData      ──────▶  EX ALU Input A / B
```

### Load-Use Hazard — Pipeline Stall

A `LW` followed immediately by a dependent instruction cannot be resolved by forwarding alone (the data isn't available until after MEM). The hazard detection unit handles this automatically:

```assembly
lw   x1, 0(x0)      ← data available after MEM stage
add  x2, x1, x3     ← needs x1 in EX — one cycle too early!
```

**Resolution:** IF and ID stages are stalled for one cycle; a bubble (NOP) is inserted into EX.

### Control Hazard — Pipeline Flush

Branches are resolved in the EX stage. If a branch is taken or a jump is encountered, the two instructions fetched after it are incorrect and must be discarded.

**Resolution:** Flush logic clears the IF/ID and ID/EX pipeline registers, and the PC is redirected to the branch/jump target.

---

## Major Components

```
riscv-pipelined-processor/
│
├── Program Counter (PC)
├── Instruction Memory
├── Register File (32 × 32-bit)
├── Immediate Generator
├── ALU
├── ALU Decoder
├── Main Control Unit
├── Data Memory
├── Forwarding Unit          ← RAW hazard resolution
├── Hazard Detection Unit    ← load-use stall + control flush
│
└── Pipeline Registers
    ├── IF/ID Register
    ├── ID/EX Register
    ├── EX/MEM Register
    └── MEM/WB Register
```

---

## Verification

The processor was verified using directed assembly test programs, targeting individual features and edge cases.

| Test Case | Result |
|-----------|--------|
| Arithmetic Operations | ✅ PASS |
| Data Forwarding | ✅ PASS |
| Load-Use Hazard Handling | ✅ PASS |
| Store Operations | ✅ PASS |
| Branch Taken | ✅ PASS |
| Branch Not Taken | ✅ PASS |
| JAL Instruction | ✅ PASS |
| JALR Instruction | ✅ PASS |
| Register Writeback | ✅ PASS |
| Pipeline Flush Logic | ✅ PASS |

### Example Test Program

```assembly
# Arithmetic + branch test
addi x1, x0, 10       # x1 = 10
addi x2, x0, 20       # x2 = 20

add  x3, x1, x2       # x3 = 30  (tests forwarding)
add  x4, x3, x1       # x4 = 40  (tests forwarding)
sub  x5, x4, x2       # x5 = 20

beq  x5, x1, label    # not taken (20 ≠ 10)
addi x6, x0, 99       # x6 = 99  (executes)

label:
addi x7, x0, 44       # x7 = 44  (executes)
```

**Expected register state after execution:**

```
x1 = 10 | x2 = 20 | x3 = 30 | x4 = 40 | x5 = 20 | x6 = 99 | x7 = 44
```

---

## Repository Structure

```
riscv-pipelined-processor/
│
├── src/
│   ├── top_pipelined.v        ← Top-level integration
│   ├── alu.v
│   ├── register_file.v
│   ├── forwarding_unit.v
│   ├── hazard_unit.v
│   ├── if_id_reg.v
│   ├── id_ex_reg.v
│   ├── ex_mem_reg.v
│   ├── mem_wb_reg.v
│   ├── data_mem.v
│   └── inst_mem.v
│
├── tb/
│   └── tb.v                   ← Simulation testbench
│
├── test_programs/
│   ├── arithmetic.mem
│   ├── branch_taken.mem
│   ├── branch_not_taken.mem
│   ├── jal.mem
│   └── jalr.mem
│
├── docs/                      ← Architecture documentation
├── README.md
└── .gitignore
```

---

## Lessons Learned

This project provided deep, hands-on experience across the full spectrum of processor design:

- **RISC-V ISA implementation** — translating the specification into working hardware logic
- **Datapath design** — connecting functional units across pipeline stages with correct control flow
- **Pipeline architecture** — structuring concurrent multi-stage execution for throughput improvement
- **Hazard mitigation** — understanding and resolving RAW, load-use, and control hazards at the microarchitecture level
- **Verilog RTL development** — writing synthesizable, well-structured register-transfer level code
- **Functional verification** — building directed test programs to isolate and confirm individual behaviors
- **Debugging complex interactions** — tracing multi-cycle bugs across pipeline registers and forwarding paths

The transition from a single-cycle processor to a pipelined architecture was the most impactful learning experience — it made the real cost of hazards and the elegance of forwarding solutions tangible in a way that theory alone cannot convey.

---

## Future Improvements

- **Branch Prediction** — Static and dynamic predictor with Branch Target Buffer (BTB)
- **RV32M Extension** — Hardware multiply and divide support
- **Cache Subsystem** — Direct-mapped or set-associative instruction/data caches
- **Bus Interface** — APB/AHB integration for SoC compatibility
- **Formal Verification** — UVM-based constrained-random testbench environment
- **Performance Benchmarking** — CPI analysis and bottleneck profiling

---

## References

- Sarah Harris & David Harris — *Digital Design and Computer Architecture: RISC-V Edition*
- [The RISC-V Instruction Set Manual](https://riscv.org/technical/specifications/)
- Xilinx Vivado Design Suite Documentation

---

## Author

**Hemanth**
Designed and implemented as part of an in-depth exploration of computer architecture and digital design, using Verilog HDL and Xilinx Vivado simulation tools.

---

<div align="center">

If this project helped you, consider giving it a ⭐ on GitHub!

</div>

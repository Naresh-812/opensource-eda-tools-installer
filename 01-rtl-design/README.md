# 📦 RTL Design & Simulation

### CIRCUIT_IQ — circuits to silicon

Tools for writing, synthesizing, and simulating digital RTL designs.

## Tools in this category

| Tool | Purpose | Script | Storage |
|------|---------|--------|---------|
| **Yosys** | RTL Synthesis — converts Verilog to gate-level netlists | `install_yosys.sh` | ~200 MB |
| **Verilator** | Fast simulator — compiles Verilog to C++ models | `install_verilator.sh` | ~800 MB |
| **Icarus Verilog** | Verilog simulation and synthesis | `install_iverilog.sh` | ~50 MB |
| **GTKWave** | Waveform viewer for VCD/FST simulation dumps | `install_gtkwave.sh` | ~50 MB |

## Install all RTL tools
```bash
../install.sh --rtl
```

## Install individually
```bash
./install_yosys.sh
./install_verilator.sh
./install_iverilog.sh
./install_gtkwave.sh
```

## Typical workflow
1. Write Verilog RTL → `vim design.v`
2. Simulate → `iverilog -o sim design.v testbench.v && vvp sim`
3. View waveforms → `gtkwave dump.vcd`
4. Synthesize → `yosys -p "read_verilog design.v; synth; write_verilog netlist.v"`

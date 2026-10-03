# 📐 Analog / Custom IC Design

### Naresh Lankalapalli

Tools for analog and custom IC design, simulation, and verification.

| Tool | Purpose | Script | Storage |
|------|---------|--------|---------|
| **Ngspice** | SPICE simulator for analog/mixed-signal circuits | `install_ngspice.sh` | ~500 MB |
| **Xschem** | Schematic capture — generates SPICE netlists | `install_xschem.sh` | ~200 MB |
| **Magic VLSI** | Layout editor with DRC, extraction, LVS | `install_magic.sh` | ~300 MB |
| **Netgen** | Netlist comparison for LVS verification | `install_netgen.sh` | ~100 MB |

## Typical Analog Workflow
1. Draw schematic → **Xschem**
2. Simulate circuit → **Ngspice**
3. Create layout → **Magic**
4. Verify LVS → **Netgen** (compare schematic vs. layout)

## Install all analog tools
```bash
../install.sh --analog
```

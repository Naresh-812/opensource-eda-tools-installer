# ⚡ Open Source EDA Tools Installer

### by **CIRCUIT_IQ** — *circuits to silicon* — Made with ❤️

---

> One-stop, modular installer for the complete Open-Source ASIC Design Flow — from RTL to GDSII.
> Pick individual tools, entire categories, or install everything with a single command.

---

## 🎯 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/opensource-eda-tools-installer.git

# 2. Enter the directory
cd opensource-eda-tools-installer

# 3. Make scripts executable
chmod +x install.sh verify.sh
chmod +x **/*.sh

# 4. Launch the interactive installer
./install.sh

# OR install a specific category directly
./install.sh --rtl
./install.sh --analog
./install.sh --all
```

---

## 📦 What's Included

### Complete ASIC Design Flow Tools

| # | Category | Tools | Storage | Build Time |
|---|----------|-------|---------|------------|
| 1 | **📦 RTL Design & Simulation** | Yosys, Verilator 5.038, Icarus Verilog, GTKWave | ~2 GB | ~25 min |
| 2 | **⏱️ Static Timing Analysis** | OpenSTA, OpenTimer | ~500 MB | ~15 min |
| 3 | **🏭 Physical Design (PnR)** | OpenROAD + deps, KLayout | ~15 GB | ~90 min |
| 4 | **📐 Analog / Custom IC** | Ngspice, Xschem, Magic VLSI, Netgen | ~3 GB | ~30 min |
| 5 | **🧬 SKY130 PDK** | SkyWater 130nm PDK + launcher wrappers | ~10 GB | ~60 min |
| 6 | **🚀 OpenLane** | Docker + OpenLane RTL-to-GDSII | ~20 GB | ~45 min |
| 7 | **🎁 Extras** | RISC-V Toolchain, IRSIM | ~200 MB | ~5 min |
| | **TOTAL** | **17+ tools** | **~50 GB** | **~4-5 hrs** |

---

## 🔧 Tool Descriptions

### 📦 RTL Design & Simulation

| Tool | What It Does | Official Repo |
|------|-------------|---------------|
| **Yosys** | RTL synthesis — converts Verilog/SystemVerilog to gate-level netlists | [YosysHQ/yosys](https://github.com/YosysHQ/yosys) |
| **Verilator** | Fast Verilog/SystemVerilog simulator — compiles HDL to C++ models | [verilator/verilator](https://github.com/verilator/verilator) |
| **Icarus Verilog** | Verilog simulation & synthesis tool for digital design | [steveicarus/iverilog](https://github.com/steveicarus/iverilog) |
| **GTKWave** | Waveform viewer for VCD/FST/LXT simulation output files | [gtkwave.sourceforge.net](http://gtkwave.sourceforge.net/) |

### ⏱️ Static Timing Analysis

| Tool | What It Does | Official Repo |
|------|-------------|---------------|
| **OpenSTA** | Static timing analysis on gate-level netlists (setup/hold checks) | [OpenROAD/OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA) |
| **OpenTimer** | High-performance STA engine with incremental timing updates | [OpenTimer](https://github.com/OpenTimer/OpenTimer) |

### 🏭 Physical Design (Place & Route)

| Tool | What It Does | Official Repo |
|------|-------------|---------------|
| **OpenROAD** | Autonomous place-and-route: floorplan, placement, CTS, routing | [OpenROAD](https://github.com/The-OpenROAD-Project/OpenROAD) |
| **KLayout** | GDSII/OASIS layout viewer and editor | [KLayout](https://github.com/KLayout/klayout) |

### 📐 Analog / Custom IC Design

| Tool | What It Does | Official Repo |
|------|-------------|---------------|
| **Ngspice** | SPICE simulator for analog, digital, and mixed-signal circuits | [ngspice](https://ngspice.sourceforge.io/) |
| **Xschem** | Schematic capture tool — generates SPICE netlists for simulation | [xschem](https://github.com/StefanSchippers/xschem) |
| **Magic VLSI** | Layout editor with built-in DRC, parasitic extraction, LVS | [magic](https://github.com/RTimothyEdwards/magic) |
| **Netgen** | Netlist comparison tool for LVS (Layout vs. Schematic) | [netgen](http://opencircuitdesign.com/netgen/) |

### 🚀 OpenLane

| Tool | What It Does | Official Repo |
|------|-------------|---------------|
| **Docker** | Container platform — OpenLane runs inside Docker | [docker.com](https://www.docker.com/) |
| **OpenLane** | Automated RTL-to-GDSII flow using OpenROAD, Yosys, Magic | [OpenLane](https://github.com/The-OpenROAD-Project/OpenLane) |

---

## 🗺️ ASIC Design Flow Map

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  RTL Design │───▶│  Synthesis  │───▶│    STA      │───▶│ Floorplan   │
│  (Verilog)  │    │  (Yosys)    │    │ (OpenSTA)   │    │ (OpenROAD)  │
└─────────────┘    └─────────────┘    └─────────────┘    └──────┬──────┘
                                                                │
       ┌────────────────────────────────────────────────────────┘
       ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Placement  │───▶│    CTS      │───▶│   Routing   │───▶│   Sign-off  │
│ (OpenROAD)  │    │ (OpenROAD)  │    │ (OpenROAD)  │    │  DRC / LVS  │
└─────────────┘    └─────────────┘    └─────────────┘    └──────┬──────┘
                                                                │
       ┌────────────────────────────────────────────────────────┘
       ▼
┌─────────────┐    ┌─────────────┐
│   GDSII     │───▶│   Tapeout   │
│ (KLayout)   │    │   🎉        │
└─────────────┘    └─────────────┘


Simulation: Verilator / Icarus Verilog + GTKWave (waveform viewing)
Analog:     Xschem (schematic) → Ngspice (simulation) → Magic (layout) → Netgen (LVS)
PDK:        SKY130 provides process-specific rules for all tools above
```

---

## 🖥️ Supported Platforms

| Platform | Status |
|----------|--------|
| Ubuntu 22.04 / 24.04 Native | ✅ Fully Supported |
| Ubuntu on VirtualBox | ✅ Fully Supported |
| WSL2 (Windows 11) | ✅ Fully Supported |
| WSL2 (Windows 10) | ⚠️ Needs X Server (VcXsrv/Xming) |
| Multi-user Linux Labs | ✅ Supported |

---

## 💻 System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **RAM** | 8 GB | 16 GB or higher |
| **CPU** | 2 Cores | 4+ Cores |
| **Storage** | 30 GB free | 60+ GB free |
| **OS** | Ubuntu 22.04 | Ubuntu 24.04 |
| **Internet** | Required | Required |

---

## 📁 Repository Structure

```
opensource-eda-tools-installer/
│
├── install.sh                    🎯 Interactive master installer
├── verify.sh                     ✅ Verify all installed tools
├── README.md                     📖 This file
├── LICENSE                       📜 MIT License
│
├── common/                       🔧 Shared utilities
│   └── common.sh                    Colors, logging, checks, helpers
│
├── 01-rtl-design/                📦 RTL Design & Simulation
│   ├── install_yosys.sh
│   ├── install_verilator.sh
│   ├── install_iverilog.sh
│   └── install_gtkwave.sh
│
├── 02-sta-timing/                ⏱️ Static Timing Analysis
│   ├── install_opensta.sh
│   └── install_opentimer.sh
│
├── 03-physical-design/           🏭 Physical Design (PnR)
│   ├── install_openroad_deps.sh     Dependencies for OpenROAD
│   ├── install_openroad.sh          OpenROAD itself
│   └── install_klayout.sh
│
├── 04-analog-design/             📐 Analog / Custom IC Design
│   ├── install_ngspice.sh
│   ├── install_xschem.sh
│   ├── install_magic.sh
│   └── install_netgen.sh
│
├── 05-pdk/                       🧬 Process Design Kit
│   ├── install_sky130_pdk.sh
│   └── install_sky130_launchers.sh
│
├── 06-openlane/                  🚀 OpenLane (RTL-to-GDSII)
│   ├── install_docker.sh
│   └── install_openlane.sh
│
├── 07-extras/                    🎁 Extra Tools
│   ├── install_riscv_toolchain.sh
│   └── install_irsim.sh
│
├── docs/                         📖 Documentation
│   ├── TROUBLESHOOTING.md
│   └── STORAGE_GUIDE.md
│
└── logs/                         📋 Build logs (auto-created)
```

---

## 🚀 Usage

### Interactive Mode (Recommended for beginners)

```bash
./install.sh
```

This opens a menu where you can pick categories to install.

### CLI Mode (Direct commands)

```bash
# Install a specific category
./install.sh --rtl          # RTL Design tools
./install.sh --sta          # Static Timing Analysis
./install.sh --physical     # Physical Design (OpenROAD + deps)
./install.sh --analog       # Analog Design tools
./install.sh --pdk          # SKY130 PDK
./install.sh --openlane     # Docker + OpenLane
./install.sh --extras       # RISC-V toolchain, IRSIM
./install.sh --all          # Everything!
./install.sh --verify       # Check what's installed
```

### Install a Single Tool

```bash
./01-rtl-design/install_yosys.sh         # Just Yosys
./04-analog-design/install_ngspice.sh    # Just Ngspice
./06-openlane/install_docker.sh          # Just Docker
```

### Script Options

Every script supports these flags:
```bash
./01-rtl-design/install_verilator.sh --force       # Reinstall even if exists
./01-rtl-design/install_verilator.sh --skip-deps   # Skip apt dependencies
./01-rtl-design/install_verilator.sh --help        # Show help
```

### Verify Installation

```bash
./verify.sh
```

---

## 🔍 Troubleshooting

### Docker Permission Error
```bash
sudo usermod -aG docker $USER
# Then logout and login again
```

### GUI Not Opening in WSL
```bash
# Windows 11 (WSLg built-in — should work automatically)
# Windows 10: Install VcXsrv and run:
export DISPLAY=:0
```

### OpenGL / Mesa Issues
```bash
sudo apt install mesa-utils x11-apps -y
```

### Build Fails with "out of memory"
Reduce parallel jobs:
```bash
export JOBS=2
```

### Verify Docker Works
```bash
docker run hello-world
```

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for more solutions.

---

## 📜 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

## 👤 Author

**CIRCUIT_IQ** — *circuits to silicon*

Made with ❤️

---

## ⚠️ Disclaimer

These scripts are provided "as is" without warranties of any kind. The author is not responsible for any damage, data loss, or system issues resulting from use of these scripts.

- Review scripts before running them
- Test in a VM or backup environment first
- Intended for educational, research, and development purposes

---

## 🌟 Support

If this helped you, give it a ⭐ on GitHub!

Found a bug? Open an issue.

Want to contribute? Pull requests are welcome!

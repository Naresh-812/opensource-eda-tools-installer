# Open Source EDA Tools Installer

**CIRCUIT_IQ** — circuits to silicon

This repository provides an automated, easy-to-use installer for open-source ASIC design tools on Ubuntu. It covers the complete flow from RTL design down to GDSII layout.

If you are a beginner, you don't need to worry about complex build steps. Just run the interactive installer and select what you need by typing a number or a letter.

---

## Quick Start

1. Clone the repository and enter the directory:
   ```bash
   git clone https://github.com/YOUR_USERNAME/opensource-eda-tools-installer.git
   cd opensource-eda-tools-installer
   ```

2. Make the scripts executable:
   ```bash
   chmod +x install.sh verify.sh
   chmod +x **/*.sh
   ```

3. Run the installer:
   ```bash
   ./install.sh
   ```

When the menu opens, simply type the number corresponding to the tools you want to install (for example, `1` for RTL tools) or `A` to install everything, then press Enter.

---

## What is Included?

The tools are grouped into the following categories:

1. **RTL Design & Simulation:** Yosys, Verilator, Icarus Verilog, GTKWave
2. **Static Timing Analysis:** OpenSTA, OpenTimer
3. **Physical Design (PnR):** OpenROAD, KLayout
4. **Analog / Custom IC:** Ngspice, Xschem, Magic VLSI, Netgen
5. **SKY130 PDK:** SkyWater 130nm process design kit
6. **OpenLane:** Full Docker-based RTL-to-GDSII flow
7. **Extras:** RISC-V Toolchain, IRSIM

You can install all tools at once, or just pick the specific categories you need.

---

## Advanced Usage and Information

If you want more details about the tools, how much storage they require, or how to install them individually without the menu, please check out the specific category folders (e.g., `01-rtl-design/README.md`).

For more detailed information, please refer to:
- **[Storage Guide](docs/STORAGE_GUIDE.md):** Disk space and build time estimates for each tool.
- **[Windows WSL Guide](docs/WINDOWS_WSL_GUIDE.md):** Step-by-step setup for Windows users.
- **[Troubleshooting](docs/TROUBLESHOOTING.md):** Common errors, WSL setup, Docker issues, and fixes.

---

---

## Support

If you find this project helpful, please give us a ⭐️ on GitHub! It helps others discover the tools and supports the open-source community.

## Disclaimer

These scripts have been carefully written and tested to help the VLSI community set up open-source EDA tools with ease. We strive to provide reliable and beginner-friendly installation scripts.

However, as with any software that modifies system configurations and installs packages, we kindly recommend:
- Reviewing the scripts if you are unsure what they do.
- Testing in a virtual machine first if you are trying this for the first time.
- Keeping backups of important data.

These scripts are provided under the MIT License for educational and development purposes. The author is not liable for any unintended issues that may arise from usage. 

Happy designing!

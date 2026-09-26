#!/bin/bash
# ============================================================
#  Install Icarus Verilog — Verilog Simulation & Synthesis
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : Icarus Verilog (iverilog) is an open-source Verilog
#                 simulation and synthesis tool for digital design.
#  Used in      : RTL Design → Simulation / Testbench Verification
#  Storage      : ~50 MB (apt install)
#  Build time   : ~2 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "Icarus Verilog" "Open-source Verilog simulation and synthesis tool"

check_sudo
if check_already_installed "Icarus Verilog" "iverilog"; then
    print_footer
    exit 0
fi

check_disk_space 1 "Icarus Verilog"

log_step 1 2 "Installing Icarus Verilog via apt..."
sudo apt-get update -y
sudo apt-get install -y iverilog

log_step 2 2 "Verifying installation..."
if print_tool_info "Icarus Verilog" "iverilog"; then
    print_done "Icarus Verilog"
else
    print_failed "Icarus Verilog"
    exit 1
fi

print_footer

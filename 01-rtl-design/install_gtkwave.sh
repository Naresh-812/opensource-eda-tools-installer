#!/bin/bash
# ============================================================
#  Install GTKWave — Waveform Viewer
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : GTKWave is a waveform viewer for VCD, LXT, FST
#                 and other signal dump formats from simulations.
#  Used in      : RTL Design → Viewing simulation waveforms
#  Storage      : ~50 MB (apt install)
#  Build time   : ~2 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "GTKWave" "Waveform viewer for simulation output (VCD/FST/LXT)"

check_sudo
if check_already_installed "GTKWave" "gtkwave"; then
    print_footer
    exit 0
fi

check_disk_space 1 "GTKWave"

log_step 1 2 "Installing GTKWave via apt..."
sudo apt-get update -y
sudo apt-get install -y gtkwave

log_step 2 2 "Verifying installation..."
if print_tool_info "GTKWave" "gtkwave"; then
    print_done "GTKWave"
else
    print_failed "GTKWave"
    exit 1
fi

print_footer

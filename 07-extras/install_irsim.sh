#!/bin/bash
# ============================================================
#  Install IRSIM — Switch-Level Simulator
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : IRSIM is a switch-level simulator for MOS circuits.
#  Used in      : Digital Design → Switch-level simulation
#  Storage      : ~50 MB (apt install)
#  Build time   : ~2 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "IRSIM" "Switch-level simulator for MOS circuits"

check_sudo
if check_already_installed "IRSIM" "irsim"; then
    print_footer
    exit 0
fi

log_step 1 2 "Installing IRSIM via apt..."
sudo apt-get update -y
sudo apt-get install -y irsim

log_step 2 2 "Verifying installation..."
if print_tool_info "IRSIM" "irsim"; then
    print_done "IRSIM"
else
    print_failed "IRSIM"
    exit 1
fi

print_footer

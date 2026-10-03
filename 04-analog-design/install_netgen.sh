#!/bin/bash
# ============================================================
#  Install Netgen — LVS (Layout vs. Schematic)
#  Author  : Naresh Lankalapalli — Made with ❤️
#
#  What it does : Netgen is a tool for comparing netlists
#                 (Layout vs. Schematic verification / LVS).
#  Used in      : Analog Design → LVS verification
#  Storage      : ~100 MB (apt install)
#  Build time   : ~2 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "Netgen" "Netlist comparison tool for LVS (Layout vs. Schematic)"

check_sudo
if check_already_installed "Netgen" "netgen"; then
    print_footer
    exit 0
fi

check_disk_space 1 "Netgen"

log_step 1 2 "Installing Netgen via apt..."
sudo apt-get update -y
sudo apt-get install -y netgen

log_step 2 2 "Verifying installation..."
if print_tool_info "Netgen" "netgen"; then
    print_done "Netgen"
else
    print_failed "Netgen"
    exit 1
fi

print_footer

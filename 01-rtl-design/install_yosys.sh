#!/bin/bash
# ============================================================
#  Install Yosys — RTL Synthesis Framework
#  Author  : Naresh Lankalapalli — Made with ❤️
#
#  What it does : Yosys is an open-source RTL synthesis tool.
#                 It converts Verilog RTL code into gate-level netlists.
#  Used in      : RTL Design → Synthesis stage of the ASIC flow
#  Storage      : ~200 MB (apt install)
#  Build time   : ~2 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "Yosys" "Open-source RTL synthesis framework — converts Verilog to gate-level netlists"

# Pre-flight checks
check_sudo
if check_already_installed "Yosys" "yosys"; then
    print_footer
    exit 0
fi

check_disk_space 1 "Yosys"

# Install
log_step 1 2 "Installing Yosys via apt..."
sudo apt-get update -y
sudo apt-get install -y yosys

log_step 2 2 "Verifying installation..."
if print_tool_info "Yosys" "yosys"; then
    print_done "Yosys"
else
    print_failed "Yosys"
    exit 1
fi

print_footer

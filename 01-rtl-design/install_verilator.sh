#!/bin/bash
# ============================================================
#  Install Verilator 5.038 — Fast Verilog/SystemVerilog Simulator
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : Verilator compiles synthesizable Verilog/SystemVerilog
#                 into fast C++/SystemC models for simulation.
#  Used in      : RTL Design → Functional Verification / Simulation
#  Storage      : ~800 MB (source build)
#  Build time   : ~15-20 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "Verilator 5.038" "Fast Verilog/SystemVerilog simulator — compiles HDL to C++ models"

# Pre-flight checks
check_sudo
if check_already_installed "Verilator" "verilator"; then
    print_footer
    exit 0
fi

check_disk_space 2 "Verilator"
check_internet
ensure_build_dir

# Dependencies
if [ "$SKIP_DEPS" != "1" ]; then
    log_step 1 4 "Installing build dependencies..."
    sudo apt-get install -y \
        build-essential git autoconf flex bison \
        help2man gperf libfl-dev \
        perl python3 make
fi

# Clone and build
log_step 2 4 "Cloning Verilator v5.038..."
cd "$EDA_BUILD_DIR"
safe_git_clone "https://github.com/verilator/verilator.git" "verilator" "v5.038"

log_step 3 4 "Building Verilator (this takes ~15-20 minutes)..."
cd "$EDA_BUILD_DIR/verilator"
autoconf
./configure || { print_failed "Verilator"; exit 1; }
make -j"$JOBS" 2>&1 | tee "$EDA_LOG_DIR/verilator_build.log"
sudo make install

# Verify
log_step 4 4 "Verifying installation..."
if print_tool_info "Verilator" "verilator"; then
    print_done "Verilator 5.038"
else
    print_failed "Verilator"
    exit 1
fi

print_footer

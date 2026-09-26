#!/bin/bash
# ============================================================
#  Install Xschem — Schematic Editor
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : Xschem is a schematic capture tool designed for
#                 analog, digital, and mixed-signal circuit design.
#                 Generates SPICE netlists for simulation.
#  Used in      : Analog Design → Schematic Capture
#  Storage      : ~200 MB (source build)
#  Build time   : ~5 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "Xschem" "Schematic capture tool for analog/mixed-signal design"

check_sudo
if check_already_installed "Xschem" "xschem"; then
    print_footer
    exit 0
fi

check_disk_space 1 "Xschem"
check_internet
ensure_build_dir

if [ "$SKIP_DEPS" != "1" ]; then
    log_step 1 4 "Installing build dependencies..."
    sudo apt-get install -y \
        build-essential git \
        tcl-dev tk-dev \
        libcairo2-dev \
        libx11-dev libxpm-dev libxrender-dev libxext-dev \
        flex bison \
        libreadline-dev
fi

log_step 2 4 "Cloning Xschem..."
cd "$EDA_BUILD_DIR"
safe_git_clone "https://github.com/StefanSchippers/xschem.git" "xschem"

log_step 3 4 "Building Xschem..."
cd "$EDA_BUILD_DIR/xschem"
./configure
make -j"$JOBS" 2>&1 | tee "$EDA_LOG_DIR/xschem_build.log"
sudo make install

# Update library
cd "$EDA_BUILD_DIR/xschem/xschem_library"
sudo git pull 2>/dev/null || true

log_step 4 4 "Verifying installation..."
if print_tool_info "Xschem" "xschem"; then
    print_done "Xschem"
else
    # Check if it was wrapped
    if command -v xschem_bin &>/dev/null; then
        log_success "Xschem installed as xschem_bin (wrapper exists)"
        print_done "Xschem"
    else
        print_failed "Xschem"
        exit 1
    fi
fi

print_footer

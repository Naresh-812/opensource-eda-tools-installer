#!/bin/bash
# ============================================================
#  Install Magic VLSI — Layout Editor + DRC/LVS
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : Magic is a VLSI layout editor with built-in
#                 DRC (Design Rule Check), extraction, and LVS.
#  Used in      : Analog/Custom IC → Layout editing, DRC, extraction
#  Storage      : ~300 MB (source build)
#  Build time   : ~10 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "Magic VLSI" "VLSI layout editor with DRC, extraction, and LVS"

check_sudo
if check_already_installed "Magic" "magic"; then
    print_footer
    exit 0
fi

check_disk_space 1 "Magic"
check_internet
ensure_build_dir

if [ "$SKIP_DEPS" != "1" ]; then
    log_step 1 4 "Installing build dependencies..."
    sudo apt-get install -y \
        build-essential git \
        tcl-dev tk-dev \
        libcairo2-dev \
        libx11-dev libxpm-dev libxaw7-dev \
        libglu1-mesa-dev freeglut3-dev mesa-common-dev \
        m4 csh
fi

log_step 2 4 "Cloning Magic..."
cd "$EDA_BUILD_DIR"
safe_git_clone "https://github.com/RTimothyEdwards/magic.git" "magic"

log_step 3 4 "Building Magic..."
cd "$EDA_BUILD_DIR/magic"
./configure
make -j"$JOBS" 2>&1 | tee "$EDA_LOG_DIR/magic_build.log"
sudo make install
hash -r

log_step 4 4 "Verifying installation..."
if print_tool_info "Magic" "magic"; then
    print_done "Magic VLSI"
else
    print_failed "Magic VLSI"
    exit 1
fi

print_footer

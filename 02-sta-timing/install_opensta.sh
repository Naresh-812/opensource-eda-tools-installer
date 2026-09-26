#!/bin/bash
# ============================================================
#  Install OpenSTA — Static Timing Analysis
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : OpenSTA performs static timing analysis on
#                 gate-level netlists to check setup/hold violations.
#  Used in      : Synthesis → STA / Physical Design → Sign-off STA
#  Storage      : ~300 MB (source build)
#  Build time   : ~10 minutes
#  Note         : OpenSTA is also bundled inside OpenROAD, but this
#                 installs it as a standalone tool.
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "OpenSTA" "Static Timing Analysis engine — checks timing on gate-level netlists"

check_sudo
if check_already_installed "OpenSTA" "sta"; then
    print_footer
    exit 0
fi

check_disk_space 1 "OpenSTA"
check_internet
ensure_build_dir

if [ "$SKIP_DEPS" != "1" ]; then
    log_step 1 4 "Installing build dependencies..."
    sudo apt-get install -y \
        build-essential cmake git \
        tcl-dev swig \
        bison flex
fi

log_step 2 4 "Cloning OpenSTA..."
cd "$EDA_BUILD_DIR"
safe_git_clone "https://github.com/The-OpenROAD-Project/OpenSTA.git" "OpenSTA"

log_step 3 4 "Building OpenSTA..."
cd "$EDA_BUILD_DIR/OpenSTA"
mkdir -p build && cd build
cmake .. 2>&1 | tee "$EDA_LOG_DIR/opensta_cmake.log"
make -j"$JOBS" 2>&1 | tee "$EDA_LOG_DIR/opensta_build.log"
sudo make install

log_step 4 4 "Verifying installation..."
if print_tool_info "OpenSTA" "sta"; then
    print_done "OpenSTA"
else
    print_failed "OpenSTA"
    exit 1
fi

print_footer

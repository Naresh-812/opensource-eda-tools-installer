#!/bin/bash
# ============================================================
#  Install Ngspice — SPICE Circuit Simulator
#  Author  : Naresh Lankalapalli — Made with ❤️
#
#  What it does : Ngspice is an open-source SPICE simulator for
#                 analog, digital, and mixed-signal circuit simulation.
#  Used in      : Analog Design → Circuit Simulation
#  Storage      : ~500 MB (source build)
#  Build time   : ~10-15 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "Ngspice" "Open-source SPICE simulator for analog/mixed-signal circuits"

check_sudo
if check_already_installed "Ngspice" "ngspice"; then
    print_footer
    exit 0
fi

check_disk_space 1 "Ngspice"
check_internet
ensure_build_dir

if [ "$SKIP_DEPS" != "1" ]; then
    log_step 1 4 "Installing build dependencies..."
    sudo apt-get install -y \
        build-essential git autoconf automake libtool \
        libreadline-dev libx11-dev libxaw7-dev \
        libxpm-dev libxext-dev libxrender-dev \
        libncurses-dev libglu1-mesa-dev freeglut3-dev \
        bison flex m4 xterm
fi

log_step 2 4 "Cloning Ngspice..."
cd "$EDA_BUILD_DIR"
safe_git_clone "https://git.code.sf.net/p/ngspice/ngspice" "ngspice"

log_step 3 4 "Building Ngspice (this takes ~10-15 minutes)..."
cd "$EDA_BUILD_DIR/ngspice"
./autogen.sh
mkdir -p release && cd release
../configure \
    --with-x \
    --enable-xspice \
    --disable-debug \
    --enable-cider \
    --with-readline=yes \
    --enable-openmp \
    --enable-osdi
make -j"$JOBS" 2>&1 | tee "$EDA_LOG_DIR/ngspice_build.log"
sudo make install

log_step 4 4 "Verifying installation..."
if print_tool_info "Ngspice" "ngspice"; then
    print_done "Ngspice"
else
    print_failed "Ngspice"
    exit 1
fi

print_footer

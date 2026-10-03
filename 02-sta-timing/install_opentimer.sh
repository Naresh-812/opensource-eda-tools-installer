#!/bin/bash
# ============================================================
#  Install OpenTimer — Static Timing Analysis
#  Author  : Naresh Lankalapalli — Made with ❤️
#
#  What it does : OpenTimer is a high-performance static timing
#                 analysis tool with incremental timing updates.
#  Used in      : Post-synthesis / Post-layout Timing Analysis
#  Storage      : ~200 MB (source build)
#  Build time   : ~5 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "OpenTimer" "High-performance static timing analysis tool"

check_sudo
if check_already_installed "OpenTimer" "ot-shell"; then
    print_footer
    exit 0
fi

check_disk_space 1 "OpenTimer"
check_internet
ensure_build_dir

if [ "$SKIP_DEPS" != "1" ]; then
    log_step 1 4 "Installing build dependencies..."
    sudo apt-get install -y build-essential cmake git
fi

log_step 2 4 "Cloning OpenTimer..."
cd "$EDA_BUILD_DIR"
safe_git_clone "https://github.com/OpenTimer/OpenTimer.git" "OpenTimer"

log_step 3 4 "Building OpenTimer..."
cd "$EDA_BUILD_DIR/OpenTimer"
mkdir -p build && cd build
cmake .. 2>&1 | tee "$EDA_LOG_DIR/opentimer_cmake.log"
make -j"$JOBS" 2>&1 | tee "$EDA_LOG_DIR/opentimer_build.log"
sudo make install

# If the binary isn't auto-installed, copy manually
if [ -f "$EDA_BUILD_DIR/OpenTimer/bin/ot-shell" ] && ! command -v ot-shell &>/dev/null; then
    sudo cp "$EDA_BUILD_DIR/OpenTimer/bin/ot-shell" /usr/local/bin/ot-shell
    sudo chmod +x /usr/local/bin/ot-shell
fi

log_step 4 4 "Verifying installation..."
if print_tool_info "OpenTimer" "ot-shell"; then
    print_done "OpenTimer"
else
    print_failed "OpenTimer"
    exit 1
fi

print_footer

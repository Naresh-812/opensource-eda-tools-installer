#!/bin/bash
# ============================================================
#  Install OpenROAD — Open-source Place & Route
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : OpenROAD is an autonomous digital layout
#                 (place-and-route) tool for ASIC design.
#                 Performs floorplanning, placement, CTS, routing.
#  Used in      : Physical Design → Place & Route stage
#  Storage      : ~5 GB (source build, excluding deps)
#  Build time   : ~30-60 minutes
#  Prerequisite : Run install_openroad_deps.sh first!
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "OpenROAD" "Autonomous digital place-and-route tool for ASIC design"

check_sudo
if check_already_installed "OpenROAD" "openroad"; then
    print_footer
    exit 0
fi

check_disk_space 5 "OpenROAD"
check_internet
ensure_build_dir

# Apply env vars
export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH:-}"
export LIBRARY_PATH="/usr/local/lib:${LIBRARY_PATH:-}"
export CMAKE_PREFIX_PATH="/usr/local;/usr/lib/x86_64-linux-gnu"
export Qt5_DIR="/usr/lib/x86_64-linux-gnu/cmake/Qt5"
export LEMON_DIR="/usr/local/lib/cmake/lemon"

# Check if dependencies are installed
if ! command -v swig &>/dev/null; then
    log_warn "OpenROAD dependencies may not be installed."
    log_info "Running dependency installer first..."
    bash "$SCRIPT_DIR/install_openroad_deps.sh"
fi

log_step 1 4 "Cloning OpenROAD..."
cd "$EDA_BUILD_DIR"
safe_git_clone "https://github.com/The-OpenROAD-Project/OpenROAD.git" "OpenROAD"

log_step 2 4 "Initializing submodules (this may take a few minutes)..."
cd "$EDA_BUILD_DIR/OpenROAD"
git submodule update --init --recursive

# Enable optional modules
sed -i 's/^#add_subdirectory(gpl)/add_subdirectory(gpl)/' src/CMakeLists.txt 2>/dev/null || true
sed -i 's/^#add_subdirectory(mpl)/add_subdirectory(mpl)/' src/CMakeLists.txt 2>/dev/null || true
sed -i 's/^#add_subdirectory(par)/add_subdirectory(par)/' src/CMakeLists.txt 2>/dev/null || true

log_step 3 4 "Building OpenROAD (this takes ~30-60 minutes)..."
rm -rf build
mkdir -p build && cd build

cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=20 \
    -DENABLE_TESTS=OFF \
    -DSPDLOG_FMT_EXTERNAL=OFF \
    -DFMT_EXTERNAL=OFF \
    -DCMAKE_DISABLE_FIND_PACKAGE_ortools=OFF 2>&1 | tee "$EDA_LOG_DIR/openroad_cmake.log"

if [ ! -f Makefile ]; then
    log_error "CMake configure failed! Check $EDA_LOG_DIR/openroad_cmake.log"
    print_failed "OpenROAD"
    exit 1
fi

make -j"$JOBS" 2>&1 | tee "$EDA_LOG_DIR/openroad_build.log"
sudo make install
sudo ldconfig

log_step 4 4 "Verifying installation..."
if print_tool_info "OpenROAD" "openroad"; then
    print_done "OpenROAD"
else
    print_failed "OpenROAD"
    exit 1
fi

print_footer

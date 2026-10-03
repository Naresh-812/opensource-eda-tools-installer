#!/bin/bash
# ============================================================
#  Install OpenROAD Dependencies
#  Author  : Naresh Lankalapalli — Made with ❤️
#
#  What it does : Installs all the libraries OpenROAD needs:
#                 Abseil, YAML-CPP, CUDD, GTest, SWIG, OR-Tools,
#                 Boost 1.87, Lemon Graph, spdlog, CMake
#  Storage      : ~8-10 GB
#  Build time   : ~30-45 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "OpenROAD Dependencies" "Building all required libraries for OpenROAD"

check_sudo
check_internet
ensure_build_dir
check_disk_space 10 "OpenROAD Dependencies"

DEPS_DIR="$EDA_BUILD_DIR/openroad-deps"
mkdir -p "$DEPS_DIR"

TOTAL_STEPS=9

# ---- 1. CMake via pipx ----
log_step 1 $TOTAL_STEPS "Installing CMake 3.29.6 via pipx..."
sudo apt-get install -y pipx
pipx ensurepath
export PATH="$HOME/.local/bin:$PATH"
pipx install cmake==3.29.6 2>/dev/null || pipx upgrade cmake 2>/dev/null || true
log_success "CMake ready"

# ---- 2. SWIG 4.3.0 ----
log_step 2 $TOTAL_STEPS "Building SWIG 4.3.0..."
sudo apt-get install -y libpcre2-dev
cd "$DEPS_DIR"
if [ ! -d "swig-4.3.0" ]; then
    wget -q https://github.com/swig/swig/archive/refs/tags/v4.3.0.tar.gz
    tar -xzf v4.3.0.tar.gz
    rm -f v4.3.0.tar.gz
fi
cd swig-4.3.0
./autogen.sh
./configure
make -j"$JOBS"
sudo make install
log_success "SWIG 4.3.0 installed"

# ---- 3. Abseil ----
log_step 3 $TOTAL_STEPS "Building Abseil C++..."
cd "$DEPS_DIR"
safe_git_clone "https://github.com/abseil/abseil-cpp.git" "abseil-cpp" "20240116.2"
cd abseil-cpp
mkdir -p build && cd build
cmake .. -DCMAKE_CXX_STANDARD=17
make -j"$JOBS"
sudo make install
log_success "Abseil installed"

# ---- 4. YAML-CPP ----
log_step 4 $TOTAL_STEPS "Building YAML-CPP..."
cd "$DEPS_DIR"
safe_git_clone "https://github.com/jbeder/yaml-cpp.git" "yaml-cpp"
cd yaml-cpp
mkdir -p build && cd build
cmake ..
make -j"$JOBS"
sudo make install
log_success "YAML-CPP installed"

# ---- 5. CUDD ----
log_step 5 $TOTAL_STEPS "Building CUDD (BDD library)..."
cd "$DEPS_DIR"
safe_git_clone "https://github.com/ivmai/cudd.git" "cudd"
cd cudd
autoreconf -i
./configure
make -j"$JOBS"
sudo make install
log_success "CUDD installed"

# ---- 6. GoogleTest ----
log_step 6 $TOTAL_STEPS "Building GoogleTest..."
cd "$DEPS_DIR"
safe_git_clone "https://github.com/google/googletest.git" "googletest"
cd googletest
mkdir -p build && cd build
cmake ..
make -j"$JOBS"
sudo make install
log_success "GoogleTest installed"

# ---- 7. OR-Tools v9.8 ----
log_step 7 $TOTAL_STEPS "Building Google OR-Tools v9.8 (this takes ~15-20 minutes)..."
cd "$DEPS_DIR"
safe_git_clone "https://github.com/google/or-tools.git" "or-tools" "v9.8"
cd or-tools
mkdir -p build && cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_DEPS=ON 2>&1 | tee "$EDA_LOG_DIR/ortools_cmake.log"
make -j"$JOBS" 2>&1 | tee "$EDA_LOG_DIR/ortools_build.log"
sudo make install
log_success "OR-Tools v9.8 installed"

# ---- 8. Boost 1.87 ----
log_step 8 $TOTAL_STEPS "Building Boost 1.87..."
cd "$DEPS_DIR"
if [ ! -d "boost_1_87_0" ]; then
    wget -q -O boost_1_87_0.tar.gz https://archives.boost.io/release/1.87.0/source/boost_1_87_0.tar.gz
    tar -xf boost_1_87_0.tar.gz
    rm -f boost_1_87_0.tar.gz
fi
cd boost_1_87_0
./bootstrap.sh
sudo ./b2 -j"$JOBS" install
log_success "Boost 1.87 installed"

# ---- 9. Lemon Graph ----
log_step 9 $TOTAL_STEPS "Building Lemon Graph library..."
cd "$DEPS_DIR"
if [ ! -d "lemon-graph-master" ]; then
    wget -q https://github.com/The-OpenROAD-Project/lemon-graph/archive/refs/heads/master.tar.gz
    tar -xzf master.tar.gz
    rm -f master.tar.gz
fi
cd lemon-graph-master
mkdir -p build && cd build
cmake .. \
    -DLEMON_ENABLE_ILOG=OFF \
    -DLEMON_ENABLE_GLPK=OFF \
    -DLEMON_ENABLE_COIN=OFF \
    -DLEMON_ENABLE_SOPLEX=OFF
make -j"$JOBS"
sudo make install
log_success "Lemon Graph installed"

# ---- spdlog (bundled) ----
log_info "Building spdlog with internal fmt..."
sudo apt-get remove -y libfmt-dev libspdlog-dev 2>/dev/null || true
cd "$DEPS_DIR"
safe_git_clone "https://github.com/gabime/spdlog.git" "spdlog"
cd spdlog
mkdir -p build && cd build
cmake .. -DSPDLOG_FMT_EXTERNAL=OFF
make -j"$JOBS"
sudo make install
log_success "spdlog installed"

# ---- Environment Variables ----
log_info "Setting up environment variables..."

# Only add if not already present
grep -q 'EDA_TOOLS_ENV' ~/.bashrc 2>/dev/null || {
    cat >> ~/.bashrc << 'ENVBLOCK'

# ---- EDA Tools Environment (Naresh Lankalapalli) ---- EDA_TOOLS_ENV
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH:-}
export LIBRARY_PATH=/usr/local/lib:${LIBRARY_PATH:-}
export CMAKE_PREFIX_PATH="/usr/local;/usr/lib/x86_64-linux-gnu"
export Qt5_DIR=/usr/lib/x86_64-linux-gnu/cmake/Qt5
export LEMON_DIR=/usr/local/lib/cmake/lemon
ENVBLOCK
}

# Apply for current session
export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH:-}"
export LIBRARY_PATH="/usr/local/lib:${LIBRARY_PATH:-}"
export CMAKE_PREFIX_PATH="/usr/local;/usr/lib/x86_64-linux-gnu"
export Qt5_DIR="/usr/lib/x86_64-linux-gnu/cmake/Qt5"
export LEMON_DIR="/usr/local/lib/cmake/lemon"

sudo ldconfig

print_done "All OpenROAD Dependencies"
print_footer

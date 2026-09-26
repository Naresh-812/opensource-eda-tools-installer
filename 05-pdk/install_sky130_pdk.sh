#!/bin/bash
# ============================================================
#  Install SKY130 OpenPDKs — Process Design Kit
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : Installs the SkyWater SKY130 open-source PDK
#                 through the OpenPDKs framework. Includes
#                 technology files for Magic, Xschem, Ngspice, etc.
#  Used in      : ALL stages — provides process-specific data
#  Storage      : ~8-10 GB
#  Build time   : ~30-60 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "SKY130 OpenPDKs" "SkyWater 130nm open-source Process Design Kit"

check_sudo
check_internet
ensure_build_dir
check_disk_space 12 "SKY130 PDK"

# Check if already installed
if [ -d "/usr/local/share/pdk/sky130A" ] || [ -d "/usr/local/share/pdk/sky130B" ]; then
    if [ "$FORCE_INSTALL" != "1" ]; then
        log_success "SKY130 PDK is already installed"
        [ -d "/usr/local/share/pdk/sky130A" ] && log_info "  SKY130A → /usr/local/share/pdk/sky130A"
        [ -d "/usr/local/share/pdk/sky130B" ] && log_info "  SKY130B → /usr/local/share/pdk/sky130B"
        echo -e "       ${DIM}Use --force to reinstall${NC}"
        print_footer
        exit 0
    fi
fi

if [ "$SKIP_DEPS" != "1" ]; then
    log_step 1 4 "Installing build dependencies..."
    sudo apt-get install -y \
        build-essential git autoconf automake libtool \
        python3 m4 tcl-dev tk-dev
fi

log_step 2 4 "Cloning OpenPDKs (this downloads a LOT of data)..."
cd "$EDA_BUILD_DIR"
safe_git_clone "git://opencircuitdesign.com/open_pdks" "open_pdks"

log_step 3 4 "Configuring and building SKY130 PDK (this takes ~30-60 minutes)..."
cd "$EDA_BUILD_DIR/open_pdks"
./configure --enable-sky130-pdk
make 2>&1 | tee "$EDA_LOG_DIR/sky130_build.log"
sudo make install

log_step 4 4 "Verifying installation..."
echo ""
if [ -d "/usr/local/share/pdk/sky130A" ]; then
    log_success "SKY130A PDK → /usr/local/share/pdk/sky130A"
else
    log_error "SKY130A PDK not found"
fi

if [ -d "/usr/local/share/pdk/sky130B" ]; then
    log_success "SKY130B PDK → /usr/local/share/pdk/sky130B"
else
    log_warn "SKY130B PDK not found (may not be enabled)"
fi

print_done "SKY130 OpenPDKs"
print_footer

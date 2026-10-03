#!/bin/bash
# ============================================================
#  Install SKY130 Launcher Wrappers for Magic & Xschem
#  Author  : Naresh Lankalapalli — Made with ❤️
#
#  What it does : Creates smart launcher wrappers for Magic and
#                 Xschem that let users choose between normal mode
#                 and SKY130-enabled mode.
#  Prerequisite : Magic, Xschem, and SKY130 PDK must be installed.
#  Storage      : Negligible
#  Build time   : Instant
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "SKY130 Launchers" "Smart launcher wrappers for Magic and Xschem with SKY130 support"

check_sudo

# ---- Xschem Launcher ----
log_step 1 2 "Creating Xschem SKY130 launcher..."

if [ -f /usr/local/bin/xschem ] && [ ! -f /usr/local/bin/xschem_bin ]; then
    sudo mv /usr/local/bin/xschem /usr/local/bin/xschem_bin
    log_info "Backed up original xschem → xschem_bin"
fi

if [ -f /usr/local/bin/xschem_bin ]; then
    sudo tee /usr/local/bin/xschem > /dev/null << 'XSCHEM_WRAPPER'
#!/bin/bash
# Xschem Launcher — Naresh Lankalapalli
echo "╔══════════════════════════════════╗"
echo "║       XSCHEM LAUNCHER           ║"
echo "║   Naresh Lankalapalli   ║"
echo "╠══════════════════════════════════╣"
echo "║  1. Normal Xschem               ║"
echo "║  2. SKY130-enabled Xschem       ║"
echo "╚══════════════════════════════════╝"
echo ""

read -p "Select option [1-2]: " choice

case $choice in
    1)
        echo "Launching normal Xschem..."
        TEMP_HOME="/tmp/xschem_clean_home"
        mkdir -p "$TEMP_HOME"
        HOME="$TEMP_HOME" xschem_bin
        ;;
    2)
        echo "Launching SKY130-enabled Xschem..."
        PROJECT_DIR="$HOME/xschem_sky130_project"
        mkdir -p "$PROJECT_DIR"
        echo 'source /usr/local/share/pdk/sky130B/libs.tech/xschem/xschemrc' > "$PROJECT_DIR/xschemrc"
        cd "$PROJECT_DIR"
        xschem_bin
        ;;
    *)
        echo "Invalid option."
        exit 1
        ;;
esac
XSCHEM_WRAPPER
    sudo chmod +x /usr/local/bin/xschem
    log_success "Xschem launcher wrapper installed"
else
    log_warn "Xschem not found — skipping launcher creation"
fi

# ---- Magic Launcher ----
log_step 2 2 "Creating Magic SKY130 launcher..."

if [ -f /usr/local/bin/magic ] && [ ! -f /usr/local/bin/magic_bin ]; then
    sudo mv /usr/local/bin/magic /usr/local/bin/magic_bin
    log_info "Backed up original magic → magic_bin"
fi

if [ -f /usr/local/bin/magic_bin ]; then
    sudo tee /usr/local/bin/magic > /dev/null << 'MAGIC_WRAPPER'
#!/bin/bash
# Magic Launcher — Naresh Lankalapalli
echo "╔══════════════════════════════════╗"
echo "║       MAGIC LAUNCHER            ║"
echo "║   Naresh Lankalapalli   ║"
echo "╠══════════════════════════════════╣"
echo "║  1. Normal Magic                ║"
echo "║  2. SKY130-enabled Magic        ║"
echo "╚══════════════════════════════════╝"
echo ""

read -p "Select option [1-2]: " choice

case $choice in
    1)
        echo "Launching normal Magic..."
        magic_bin
        ;;
    2)
        echo "Launching SKY130-enabled Magic..."
        PROJECT_DIR="$HOME/magic_sky130_project"
        mkdir -p "$PROJECT_DIR"
        cd "$PROJECT_DIR"
        magic_bin -rcfile /usr/local/share/pdk/sky130B/libs.tech/magic/sky130B.magicrc
        ;;
    *)
        echo "Invalid option."
        exit 1
        ;;
esac
MAGIC_WRAPPER
    sudo chmod +x /usr/local/bin/magic
    log_success "Magic launcher wrapper installed"
else
    log_warn "Magic not found — skipping launcher creation"
fi

print_done "SKY130 Launchers"
print_footer

#!/bin/bash
# ============================================================
#  Open Source EDA Tools Installer — Master Installer
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  Interactive menu-driven installer for all EDA tools.
#  Users can pick categories or individual tools.
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common/common.sh"

# ============================================================
#  Category Installers
# ============================================================
install_rtl_design() {
    log_info "═══ Installing RTL Design & Simulation tools ═══"
    bash "$SCRIPT_DIR/01-rtl-design/install_yosys.sh" "$@"
    bash "$SCRIPT_DIR/01-rtl-design/install_verilator.sh" "$@"
    bash "$SCRIPT_DIR/01-rtl-design/install_iverilog.sh" "$@"
    bash "$SCRIPT_DIR/01-rtl-design/install_gtkwave.sh" "$@"
}

install_sta() {
    log_info "═══ Installing Static Timing Analysis tools ═══"
    bash "$SCRIPT_DIR/02-sta-timing/install_opensta.sh" "$@"
    bash "$SCRIPT_DIR/02-sta-timing/install_opentimer.sh" "$@"
}

install_physical_design() {
    log_info "═══ Installing Physical Design tools ═══"
    bash "$SCRIPT_DIR/03-physical-design/install_openroad_deps.sh" "$@"
    bash "$SCRIPT_DIR/03-physical-design/install_openroad.sh" "$@"
    bash "$SCRIPT_DIR/03-physical-design/install_klayout.sh" "$@"
}

install_analog_design() {
    log_info "═══ Installing Analog / Custom IC Design tools ═══"
    bash "$SCRIPT_DIR/04-analog-design/install_ngspice.sh" "$@"
    bash "$SCRIPT_DIR/04-analog-design/install_xschem.sh" "$@"
    bash "$SCRIPT_DIR/04-analog-design/install_magic.sh" "$@"
    bash "$SCRIPT_DIR/04-analog-design/install_netgen.sh" "$@"
}

install_pdk() {
    log_info "═══ Installing SKY130 PDK ═══"
    bash "$SCRIPT_DIR/05-pdk/install_sky130_pdk.sh" "$@"
    bash "$SCRIPT_DIR/05-pdk/install_sky130_launchers.sh" "$@"
}

install_openlane() {
    log_info "═══ Installing OpenLane (Docker-based RTL-to-GDSII) ═══"
    bash "$SCRIPT_DIR/06-openlane/install_docker.sh" "$@"
    bash "$SCRIPT_DIR/06-openlane/install_openlane.sh" "$@"
}

install_extras() {
    log_info "═══ Installing Extra tools ═══"
    bash "$SCRIPT_DIR/07-extras/install_riscv_toolchain.sh" "$@"
    bash "$SCRIPT_DIR/07-extras/install_irsim.sh" "$@"
}

install_all() {
    log_info "═══ Installing ALL EDA Tools ═══"
    install_base_dependencies
    install_rtl_design "$@"
    install_sta "$@"
    install_physical_design "$@"
    install_analog_design "$@"
    install_pdk "$@"
    install_openlane "$@"
    install_extras "$@"
}

# ============================================================
#  CLI Mode (non-interactive)
# ============================================================
for arg in "$@"; do
    case $arg in
        --rtl)       install_base_dependencies; install_rtl_design; exit 0 ;;
        --sta)       install_base_dependencies; install_sta; exit 0 ;;
        --physical)  install_base_dependencies; install_physical_design; exit 0 ;;
        --analog)    install_base_dependencies; install_analog_design; exit 0 ;;
        --pdk)       install_base_dependencies; install_pdk; exit 0 ;;
        --openlane)  install_openlane; exit 0 ;;
        --extras)    install_base_dependencies; install_extras; exit 0 ;;
        --all)       install_all; exit 0 ;;
        --verify)    bash "$SCRIPT_DIR/verify.sh"; exit 0 ;;
    esac
done

# ============================================================
#  Interactive Menu
# ============================================================
show_menu() {
    clear
    print_banner

    echo -e "${BOLD}  Select what to install:${NC}\n"

    echo -e "  ${CYAN}[1]${NC} 📦 ${BOLD}RTL Design & Simulation${NC}           ${DIM}(~2 GB, ~25 min)${NC}"
    echo -e "      ${DIM}Yosys, Verilator, Icarus Verilog, GTKWave${NC}"
    echo ""
    echo -e "  ${CYAN}[2]${NC} ⏱️  ${BOLD}Static Timing Analysis${NC}             ${DIM}(~500 MB, ~15 min)${NC}"
    echo -e "      ${DIM}OpenSTA, OpenTimer${NC}"
    echo ""
    echo -e "  ${CYAN}[3]${NC} 🏭 ${BOLD}Physical Design (Place & Route)${NC}    ${DIM}(~15 GB, ~90 min)${NC}"
    echo -e "      ${DIM}OpenROAD + all dependencies, KLayout${NC}"
    echo ""
    echo -e "  ${CYAN}[4]${NC} 📐 ${BOLD}Analog / Custom IC Design${NC}          ${DIM}(~3 GB, ~30 min)${NC}"
    echo -e "      ${DIM}Ngspice, Xschem, Magic, Netgen${NC}"
    echo ""
    echo -e "  ${CYAN}[5]${NC} 🧬 ${BOLD}SKY130 PDK${NC}                         ${DIM}(~10 GB, ~60 min)${NC}"
    echo -e "      ${DIM}SkyWater 130nm PDK + launcher wrappers${NC}"
    echo ""
    echo -e "  ${CYAN}[6]${NC} 🚀 ${BOLD}OpenLane (Docker-based)${NC}            ${DIM}(~20 GB, ~45 min)${NC}"
    echo -e "      ${DIM}Docker + OpenLane RTL-to-GDSII flow${NC}"
    echo ""
    echo -e "  ${CYAN}[7]${NC} 🎁 ${BOLD}Extras${NC}                             ${DIM}(~200 MB, ~5 min)${NC}"
    echo -e "      ${DIM}RISC-V Toolchain, IRSIM${NC}"
    echo ""
    echo -e "  ${GREEN}[A]${NC} ⚡ ${BOLD}Install ALL tools${NC}                  ${DIM}(~50 GB, ~4-5 hrs)${NC}"
    echo -e "  ${BLUE}[V]${NC} ✅ ${BOLD}Verify installed tools${NC}"
    echo -e "  ${BLUE}[D]${NC} 📋 ${BOLD}Install base dependencies only${NC}"
    echo -e "  ${RED}[Q]${NC} 🚪 ${BOLD}Quit${NC}"
    echo ""
}

while true; do
    show_menu
    echo -e "${BOLD}"
    read -p "  Select options (e.g., 1 3 4  or  A for all): " -a choices
    echo -e "${NC}"

    if [ ${#choices[@]} -eq 0 ]; then
        continue
    fi

    # Install base deps first unless only verifying
    NEED_DEPS=0
    for choice in "${choices[@]}"; do
        case "$choice" in
            [1-7]|a|A) NEED_DEPS=1 ;;
        esac
    done

    if [ "$NEED_DEPS" = "1" ]; then
        install_base_dependencies
    fi

    for choice in "${choices[@]}"; do
        case "$choice" in
            1)   install_rtl_design ;;
            2)   install_sta ;;
            3)   install_physical_design ;;
            4)   install_analog_design ;;
            5)   install_pdk ;;
            6)   install_openlane ;;
            7)   install_extras ;;
            a|A) install_all ;;
            v|V) bash "$SCRIPT_DIR/verify.sh" ;;
            d|D) install_base_dependencies ;;
            q|Q) echo -e "\n${DIM}Goodbye! — CIRCUIT_IQ${NC}\n"; exit 0 ;;
            *)   log_warn "Unknown option: $choice" ;;
        esac
    done

    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Selected installations complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo ""
    read -p "  Press Enter to return to menu (or 'q' to quit): " cont
    if [ "$cont" = "q" ] || [ "$cont" = "Q" ]; then
        echo -e "\n${DIM}Goodbye! — CIRCUIT_IQ${NC}\n"
        exit 0
    fi
done

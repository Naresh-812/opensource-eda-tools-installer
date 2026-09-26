#!/bin/bash
# ============================================================
#  Verify All Installed EDA Tools
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common/common.sh"

print_banner

echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${CYAN}      EDA Tools — Installation Verification        ${NC}"
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════${NC}"

INSTALLED=0
MISSING=0
MISSING_LIST=""

check_and_count() {
    local name="$1"
    local cmd="$2"
    if print_tool_info "$name" "$cmd"; then
        INSTALLED=$((INSTALLED + 1))
    else
        MISSING=$((MISSING + 1))
        MISSING_LIST="$MISSING_LIST  • $name\n"
    fi
}

echo -e "\n${BOLD}📦 RTL Design & Simulation${NC}"
echo -e "${DIM}──────────────────────────${NC}"
check_and_count "Yosys" "yosys"
check_and_count "Verilator" "verilator"
check_and_count "Icarus Verilog" "iverilog"
check_and_count "GTKWave" "gtkwave"

echo -e "\n${BOLD}⏱️  Static Timing Analysis${NC}"
echo -e "${DIM}──────────────────────────${NC}"
check_and_count "OpenSTA" "sta"
check_and_count "OpenTimer" "ot-shell"

echo -e "\n${BOLD}🏭 Physical Design (Place & Route)${NC}"
echo -e "${DIM}──────────────────────────────────${NC}"
check_and_count "OpenROAD" "openroad"
check_and_count "KLayout" "klayout"

echo -e "\n${BOLD}📐 Analog / Custom IC Design${NC}"
echo -e "${DIM}────────────────────────────${NC}"
check_and_count "Magic VLSI" "magic"
check_and_count "Xschem" "xschem"
check_and_count "Ngspice" "ngspice"
check_and_count "Netgen" "netgen"

echo -e "\n${BOLD}🚀 RTL-to-GDSII Flow${NC}"
echo -e "${DIM}────────────────────${NC}"
check_and_count "Docker" "docker"
check_and_count "OpenLane" "openlane"

echo -e "\n${BOLD}🎁 Extras${NC}"
echo -e "${DIM}─────────${NC}"
check_and_count "RISC-V Toolchain" "riscv64-unknown-elf-gcc"
check_and_count "IRSIM" "irsim"
check_and_count "CMake" "cmake"
check_and_count "SWIG" "swig"

echo -e "\n${BOLD}🧬 PDK${NC}"
echo -e "${DIM}──────${NC}"
if [ -d "/usr/local/share/pdk/sky130A" ]; then
    echo -e "  ${GREEN}✅${NC} ${BOLD}SKY130A PDK${NC} → /usr/local/share/pdk/sky130A"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${RED}❌${NC} ${BOLD}SKY130A PDK${NC} → NOT INSTALLED"
    MISSING=$((MISSING + 1))
    MISSING_LIST="$MISSING_LIST  • SKY130A PDK\n"
fi

if [ -d "/usr/local/share/pdk/sky130B" ]; then
    echo -e "  ${GREEN}✅${NC} ${BOLD}SKY130B PDK${NC} → /usr/local/share/pdk/sky130B"
    INSTALLED=$((INSTALLED + 1))
else
    echo -e "  ${RED}❌${NC} ${BOLD}SKY130B PDK${NC} → NOT INSTALLED"
    MISSING=$((MISSING + 1))
    MISSING_LIST="$MISSING_LIST  • SKY130B PDK\n"
fi

TOTAL=$((INSTALLED + MISSING))

echo ""
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════${NC}"
echo -e "${BOLD}  Summary: ${GREEN}$INSTALLED${NC}/${BOLD}$TOTAL${NC} tools installed"

if [ "$MISSING" -gt 0 ]; then
    echo -e "\n${YELLOW}  Missing tools:${NC}"
    echo -e "${YELLOW}$(echo -e "$MISSING_LIST")${NC}"
fi

echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════${NC}"

print_footer

#!/bin/bash
# ============================================================
#  Common Utilities for Open Source EDA Tools Installer
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
# ============================================================

# ---- Colors ----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ---- Default Paths ----
export EDA_BUILD_DIR="${EDA_BUILD_DIR:-$HOME/eda-tools-build}"
export EDA_LOG_DIR="${EDA_BUILD_DIR}/logs"

# ---- Detect CPU Cores ----
CORES=$(nproc 2>/dev/null || echo 2)
if [ "$CORES" -ge 8 ]; then
    JOBS=4
elif [ "$CORES" -ge 4 ]; then
    JOBS=$((CORES - 1))
else
    JOBS=2
fi
export JOBS
export CORES

# ============================================================
#  Logging
# ============================================================
log_info()    { echo -e "${BLUE}[INFO]${NC}    $1"; }
log_success() { echo -e "${GREEN}[  ✅  ]${NC}  $1"; }
log_error()   { echo -e "${RED}[  ❌  ]${NC}  $1"; }
log_warn()    { echo -e "${YELLOW}[  ⚠️  ]${NC}   $1"; }
log_step()    { echo -e "\n${BOLD}${CYAN}[$1/$2]${NC} ${BOLD}$3${NC}\n"; }

# ============================================================
#  Banner
# ============================================================
print_banner() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║     ⚡  Open Source EDA Tools Installer  ⚡               ║"
    echo "║                                                           ║"
    echo "║     Author : CIRCUIT_IQ                                   ║"
    echo "║     Brand  : circuits to silicon                          ║"
    echo "║     Made with ❤️                                           ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_tool_header() {
    local tool_name="$1"
    local description="$2"
    echo -e "\n${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}  🔧 Installing: ${CYAN}$tool_name${NC}"
    echo -e "${DIM}  $description${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# ============================================================
#  Pre-flight Checks
# ============================================================
check_already_installed() {
    local tool_name="$1"
    local check_cmd="$2"

    if [ "${FORCE_INSTALL:-0}" = "1" ]; then
        log_warn "Force mode: reinstalling $tool_name..."
        return 1
    fi

    if command -v "$check_cmd" &>/dev/null; then
        log_success "$tool_name is already installed → $(command -v "$check_cmd")"
        echo -e "       ${DIM}Use --force to reinstall${NC}"
        return 0
    fi
    return 1
}

check_disk_space() {
    local required_gb=$1
    local label="${2:-this tool}"
    local available_gb
    available_gb=$(df -BG --output=avail / 2>/dev/null | tail -1 | tr -d ' G')

    if [ -z "$available_gb" ]; then
        log_warn "Could not determine disk space — proceeding anyway"
        return 0
    fi

    if [ "$available_gb" -lt "$required_gb" ]; then
        log_error "Insufficient disk space for $label!"
        log_error "  Need: ${required_gb} GB  |  Available: ${available_gb} GB"
        echo ""
        read -p "Continue anyway? (y/N): " choice
        case "$choice" in
            y|Y) return 0 ;;
            *)   exit 1 ;;
        esac
    fi
    log_info "Disk space OK: ${available_gb} GB available (need ~${required_gb} GB for $label)"
    return 0
}

check_internet() {
    if ! ping -c 1 -W 3 github.com &>/dev/null; then
        log_error "No internet connection! Cannot reach github.com"
        log_error "Please check your network and try again."
        exit 1
    fi
    log_info "Internet connectivity: OK"
}

check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        log_info "Some steps require sudo. You may be prompted for your password."
        sudo true || { log_error "sudo access required. Aborting."; exit 1; }
    fi
}

check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        log_info "Detected OS: $PRETTY_NAME"
        if [[ "$ID" != "ubuntu" ]]; then
            log_warn "This installer is designed for Ubuntu. Your OS ($ID) may have issues."
        fi
    fi

    # Detect WSL
    if grep -qi microsoft /proc/version 2>/dev/null; then
        log_info "Running inside WSL"
        export IS_WSL=1
    else
        export IS_WSL=0
    fi
}

# ============================================================
#  Build Helpers
# ============================================================
ensure_build_dir() {
    mkdir -p "$EDA_BUILD_DIR"
    mkdir -p "$EDA_LOG_DIR"
}

safe_git_clone() {
    local url="$1"
    local dir="$2"
    local branch="${3:-}"

    if [ -d "$dir" ]; then
        log_warn "Directory '$dir' already exists — using existing"
    else
        log_info "Cloning $url ..."
        git clone "$url" "$dir" || { log_error "Git clone failed: $url"; return 1; }
    fi

    if [ -n "$branch" ]; then
        cd "$dir" || return 1
        git checkout "$branch" 2>/dev/null || log_warn "Could not checkout branch: $branch"
        cd - >/dev/null || true
    fi
}

safe_mkdir_cd() {
    mkdir -p "$1"
    cd "$1" || { log_error "Cannot cd into $1"; exit 1; }
}

# ============================================================
#  Tool Verification
# ============================================================
print_tool_info() {
    local TOOL_NAME="$1"
    local CMD="$2"

    if command -v "$CMD" >/dev/null 2>&1; then
        local VERSION
        VERSION=$(
            "$CMD" --version 2>/dev/null | head -n 1 || \
            "$CMD" -version 2>/dev/null | head -n 1 || \
            "$CMD" -v 2>/dev/null | head -n 1 || true
        )
        echo -e "  ${GREEN}✅${NC} ${BOLD}$TOOL_NAME${NC} → $(command -v "$CMD") ${DIM}${VERSION:+($VERSION)}${NC}"
        return 0
    else
        echo -e "  ${RED}❌${NC} ${BOLD}$TOOL_NAME${NC} → NOT INSTALLED"
        return 1
    fi
}

# ============================================================
#  Completion Messages
# ============================================================
print_done() {
    local tool_name="$1"
    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  ✅  $tool_name — Installation Complete${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_failed() {
    local tool_name="$1"
    echo -e "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}  ❌  $tool_name — Installation FAILED${NC}"
    echo -e "${RED}  Check logs in: $EDA_LOG_DIR/${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_footer() {
    echo -e "\n${DIM}─────────────────────────────────────────────────────${NC}"
    echo -e "${DIM}  CIRCUIT_IQ — circuits to silicon — Made with ❤️${NC}"
    echo -e "${DIM}─────────────────────────────────────────────────────${NC}\n"
}

# ============================================================
#  System Dependencies Installer
# ============================================================
install_base_dependencies() {
    log_info "Installing base system dependencies..."

    sudo apt-get update -y
    sudo apt-get upgrade -y

    sudo apt-get install -y \
        build-essential gcc g++ make \
        git clang \
        bison flex gawk m4 \
        help2man gperf \
        perl \
        pkg-config \
        libfl-dev libreadline-dev libncurses5-dev \
        tcl tcl-dev tk tk-dev tcllib tclsh tcsh \
        libffi-dev zlib1g-dev \
        libboost-all-dev \
        libx11-dev libxaw7-dev libxft-dev libxrender-dev libxext-dev \
        libglu1-mesa-dev freeglut3-dev \
        libgtk-3-dev \
        qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
        libqt5svg5-dev libqt5charts5-dev \
        automake autoconf libtool \
        libspdlog-dev libfmt-dev \
        graphviz xdot \
        python3 python3-pip python3-dev python3-tk python3-venv pipx \
        gsl-bin libgsl-dev \
        wget curl ca-certificates \
        dos2unix \
        libcairo2-dev libxpm-dev \
        mesa-utils x11-apps xterm \
        libpcre2-dev \
        mesa-common-dev csh

    log_success "Base system dependencies installed"
}

# ============================================================
#  Parse Common Flags
# ============================================================
FORCE_INSTALL=0
SKIP_DEPS=0
for arg in "$@"; do
    case $arg in
        --force)     FORCE_INSTALL=1 ;;
        --skip-deps) SKIP_DEPS=1 ;;
        --help|-h)
            echo "Usage: $(basename "$0") [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --force       Force reinstall even if tool already exists"
            echo "  --skip-deps   Skip installing system dependencies"
            echo "  -h, --help    Show this help message"
            echo ""
            echo "CIRCUIT_IQ — circuits to silicon — Made with ❤️"
            exit 0
            ;;
    esac
done

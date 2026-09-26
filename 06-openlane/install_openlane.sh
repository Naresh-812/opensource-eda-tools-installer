#!/bin/bash
# ============================================================
#  Install OpenLane — Full RTL-to-GDSII Flow
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : OpenLane is an automated RTL-to-GDSII flow
#                 that uses OpenROAD, Yosys, Magic, and more
#                 inside a Docker container.
#  Used in      : Complete ASIC design flow (synthesis → GDSII)
#  Storage      : ~15-20 GB (Docker images + designs)
#  Build time   : ~30-45 minutes
#  Prerequisite : Docker must be installed and working!
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "OpenLane" "Automated RTL-to-GDSII flow (Docker-based)"

check_sudo
check_internet
check_disk_space 20 "OpenLane"

# Check Docker
if ! command -v docker &>/dev/null; then
    log_error "Docker is not installed! Please run install_docker.sh first."
    log_info "Run: ./06-openlane/install_docker.sh"
    exit 1
fi

# Check if user can run docker
if ! docker info &>/dev/null; then
    log_warn "Docker requires elevated permissions."
    log_info "Attempting with sudo for this session..."
fi

OPENLANE_DIR="${EDA_BUILD_DIR}/OpenLane"

TOTAL_STEPS=5

log_step 1 $TOTAL_STEPS "Creating OpenLane directory..."
ensure_build_dir
cd "$EDA_BUILD_DIR"

log_step 2 $TOTAL_STEPS "Cloning OpenLane repository..."
safe_git_clone "https://github.com/The-OpenROAD-Project/OpenLane" "OpenLane"
git config --global --add safe.directory "$OPENLANE_DIR" 2>/dev/null || true

log_step 3 $TOTAL_STEPS "Downloading OpenLane CI designs..."
if [ ! -d "$EDA_BUILD_DIR/openlane-ci-designs" ]; then
    git clone https://github.com/efabless/openlane-ci-designs.git "$EDA_BUILD_DIR/openlane-ci-designs"
fi
cp -r "$EDA_BUILD_DIR/openlane-ci-designs/"* "$OPENLANE_DIR/designs/" 2>/dev/null || true
rm -rf "$EDA_BUILD_DIR/openlane-ci-designs"

log_step 4 $TOTAL_STEPS "Building OpenLane (downloading Docker image — this takes a while)..."
cd "$OPENLANE_DIR"
rm -rf venv

# Build in a newgrp session for docker access
if groups | grep -q docker; then
    make 2>&1 | tee "$EDA_LOG_DIR/openlane_build.log"
    make test 2>&1 | tee "$EDA_LOG_DIR/openlane_test.log" || log_warn "OpenLane test had issues (may be OK)"
else
    sudo -E make 2>&1 | tee "$EDA_LOG_DIR/openlane_build.log"
    log_warn "Docker group not active yet. Re-login for full access."
fi

log_step 5 $TOTAL_STEPS "Creating OpenLane launcher command..."

sudo bash -c "cat > /usr/local/bin/openlane << 'LAUNCHER_EOF'
#!/bin/bash

# OpenLane Launcher — CIRCUIT_IQ — circuits to silicon

OPENLANE_ROOT=\"\${OPENLANE_ROOT:-$OPENLANE_DIR}\"
USER_OL_DIR=\"\$HOME/OpenLaneUser\"

mkdir -p \"\$USER_OL_DIR/designs\"

# Copy example designs on first run
if [ ! -d \"\$USER_OL_DIR/designs/spm\" ]; then
    echo \"[INFO] Copying example designs to your workspace...\"
    cp -r \"\$OPENLANE_ROOT/designs/\"* \"\$USER_OL_DIR/designs/\" 2>/dev/null || true
fi

echo \"╔══════════════════════════════════════╗\"
echo \"║  OpenLane — CIRCUIT_IQ              ║\"
echo \"║  circuits to silicon                ║\"
echo \"╠══════════════════════════════════════╣\"
echo \"║  User     : \$USER\"
echo \"║  Workspace: \$USER_OL_DIR\"
echo \"╚══════════════════════════════════════╝\"

# Allow Docker GUI access
xhost +local:docker >/dev/null 2>&1 || true

docker run --rm \\
    -v \"\$OPENLANE_ROOT\":/openlane \\
    -v \"\$OPENLANE_ROOT/designs\":/openlane/install \\
    -v \"\$HOME\":\"\$HOME\" \\
    -v \"\$HOME/.ciel\":\"\$HOME/.ciel\" \\
    -e PDK_ROOT=\"\$HOME/.ciel\" \\
    -e PDK=sky130A \\
    --user \$(id -u):\$(id -g) \\
    -e DISPLAY=\$DISPLAY \\
    -v /tmp/.X11-unix:/tmp/.X11-unix \\
    --network host \\
    --security-opt seccomp=unconfined \\
    -ti ghcr.io/the-openroad-project/openlane:ff5509f65b17bfa4068d5336495ab1718987ff69-amd64
LAUNCHER_EOF"

sudo chmod +x /usr/local/bin/openlane

if print_tool_info "OpenLane" "openlane"; then
    print_done "OpenLane"
    echo -e "${YELLOW}"
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║  ⚠️  IMPORTANT: Please logout and login again      ║"
    echo "║     Then launch OpenLane by typing: openlane      ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
else
    print_failed "OpenLane"
    exit 1
fi

print_footer

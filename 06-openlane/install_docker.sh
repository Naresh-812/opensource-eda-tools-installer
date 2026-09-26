#!/bin/bash
# ============================================================
#  Install Docker — Container Runtime
#  Author  : CIRCUIT_IQ — circuits to silicon
#  Made with ❤️
#
#  What it does : Docker is a container platform. OpenLane runs
#                 inside a Docker container for reproducible builds.
#  Used in      : Required for OpenLane RTL-to-GDSII flow
#  Storage      : ~1-2 GB
#  Build time   : ~5 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "Docker" "Container platform required for OpenLane"

check_sudo
if check_already_installed "Docker" "docker"; then
    # Verify docker actually works
    if docker run --rm hello-world &>/dev/null; then
        log_success "Docker is working correctly"
        print_footer
        exit 0
    else
        log_warn "Docker is installed but may not be configured properly"
    fi
fi

check_disk_space 3 "Docker"
check_internet

TOTAL_STEPS=5

log_step 1 $TOTAL_STEPS "Installing Docker prerequisites..."
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates curl \
    x11-xserver-utils xauth \
    mesa-utils libgl1 libglx-mesa0 libgl1-mesa-dri x11-apps

log_step 2 $TOTAL_STEPS "Adding Docker repository..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

log_step 3 $TOTAL_STEPS "Installing Docker packages..."
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

log_step 4 $TOTAL_STEPS "Starting Docker service..."
if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl start docker
    sudo systemctl enable docker
else
    sudo service docker start
fi

# Configure permissions
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"

log_step 5 $TOTAL_STEPS "Verifying Docker..."
sudo docker run --rm hello-world 2>&1 | head -5

if print_tool_info "Docker" "docker"; then
    print_done "Docker"
    echo -e "${YELLOW}"
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║  ⚠️  IMPORTANT: Please logout and login again      ║"
    echo "║     to apply Docker group permissions.            ║"
    echo "║                                                   ║"
    echo "║     After re-login, run: docker run hello-world   ║"
    echo "║     to verify Docker works without sudo.          ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
else
    print_failed "Docker"
    exit 1
fi

print_footer

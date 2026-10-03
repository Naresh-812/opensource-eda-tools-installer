#!/bin/bash
# ============================================================
#  Install RISC-V GCC Cross-Compiler Toolchain
#  Author  : Naresh Lankalapalli — Made with ❤️
#
#  What it does : Installs the RISC-V bare-metal GCC cross-compiler
#                 for compiling programs targeting RISC-V processors.
#  Used in      : RISC-V processor design verification
#  Storage      : ~200 MB (apt install)
#  Build time   : ~2 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "RISC-V Toolchain" "RISC-V bare-metal GCC cross-compiler"

check_sudo
if check_already_installed "RISC-V GCC" "riscv64-unknown-elf-gcc"; then
    print_footer
    exit 0
fi

check_disk_space 1 "RISC-V Toolchain"

log_step 1 2 "Installing RISC-V GCC toolchain via apt..."
sudo apt-get update -y
sudo apt-get install -y gcc-riscv64-unknown-elf

log_step 2 2 "Verifying installation..."
if print_tool_info "RISC-V GCC" "riscv64-unknown-elf-gcc"; then
    print_done "RISC-V Toolchain"
else
    print_failed "RISC-V Toolchain"
    exit 1
fi

print_footer

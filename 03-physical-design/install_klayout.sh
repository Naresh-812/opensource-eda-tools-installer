#!/bin/bash
# ============================================================
#  Install KLayout — Layout Viewer & Editor
#  Author  : Naresh Lankalapalli — Made with ❤️
#
#  What it does : KLayout is a layout viewer and editor for
#                 GDSII and OASIS file formats.
#  Used in      : Physical Design → Layout viewing and editing
#  Storage      : ~200 MB (apt install)
#  Build time   : ~2 minutes
# ============================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/common.sh"

print_banner
print_tool_header "KLayout" "Layout viewer/editor for GDSII and OASIS files"

check_sudo
if check_already_installed "KLayout" "klayout"; then
    print_footer
    exit 0
fi

check_disk_space 1 "KLayout"

log_step 1 2 "Installing KLayout via apt..."
sudo apt-get update -y
sudo apt-get install -y klayout

log_step 2 2 "Verifying installation..."
if print_tool_info "KLayout" "klayout"; then
    print_done "KLayout"
else
    print_failed "KLayout"
    exit 1
fi

print_footer

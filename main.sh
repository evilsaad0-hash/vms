#!/bin/bash
set -Eeuo pipefail

# Resolve the toolkit directory. If this script is launched through process
# substitution (for example: bash <(curl ...)), BASH_SOURCE points to /dev/fd;
# in that case, use the current directory containing the companion scripts.
SCRIPT_PATH="${BASH_SOURCE[0]}"
if [[ -f "$SCRIPT_PATH" ]]; then
    SCRIPT_DIR="$(cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"
else
    SCRIPT_DIR="$PWD"
fi
if [[ ! -f "$SCRIPT_DIR/lxc-setup.sh" && -f "$PWD/lxc-setup.sh" ]]; then
    SCRIPT_DIR="$PWD"
fi

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

show_header() {
    clear
    printf '%b' "$CYAN"
    cat <<'EOF'
 ███████╗██╗   ██╗██╗██╗      ███████╗ █████╗  █████╗ ██████╗
 ██╔════╝██║   ██║██║██║      ██╔════╝██╔══██╗██╔══██╗██╔══██╗
 █████╗  ██║   ██║██║██║      ███████╗███████║███████║██║  ██║
 ██╔══╝  ╚██╗ ██╔╝██║██║      ╚════██║██╔══██║██╔══██║██║  ██║
 ███████╗ ╚████╔╝ ██║███████╗ ███████║██║  ██║██║  ██║██████╔╝
 ╚══════╝  ╚═══╝  ╚═╝╚══════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝
EOF
    printf '%b' "$RESET"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${GREEN}                 EVILSAAD VM TOOLKIT${RESET}"
    echo -e "${YELLOW}                   MAIN MENU${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}

pause_menu() {
    echo
    read -r -p "Press Enter to return to the main menu..."
}

while true; do
    show_header
    echo -e "${GREEN}1)${RESET} LXC-INSTALLER"
    echo -e "${GREEN}2)${RESET} PROOT START"
    echo -e "${GREEN}3)${RESET} VM MAKER"
    echo -e "${RED}4)${RESET} EXIT"
    echo
    read -r -p "Select an option [1-4]: " choice

    case "$choice" in
        1)
            if [[ ! -f "$SCRIPT_DIR/lxc-setup.sh" ]]; then
                echo -e "${RED}[ERROR] lxc-setup.sh not found.${RESET}"
                pause_menu
                continue
            fi
            bash "$SCRIPT_DIR/lxc-setup.sh"
            pause_menu
            ;;
        2)
            if [[ ! -f "$SCRIPT_DIR/root-maker.sh" ]]; then
                echo -e "${RED}[ERROR] root-maker.sh not found.${RESET}"
                pause_menu
                continue
            fi
            bash "$SCRIPT_DIR/root-maker.sh"
            pause_menu
            ;;
        3)
            if [[ ! -f "$SCRIPT_DIR/vm-maker.sh" ]]; then
                echo -e "${RED}[ERROR] vm-maker.sh not found.${RESET}"
                pause_menu
                continue
            fi
            bash "$SCRIPT_DIR/vm-maker.sh"
            pause_menu
            ;;
        4)
            echo -e "${YELLOW}Exiting EVILSAAD VM Toolkit...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please select 1, 2, 3, or 4.${RESET}"
            sleep 1
            ;;
    esac
done

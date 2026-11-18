#!/bin/bash
set -Eeuo pipefail

# Resolve the toolkit directory. When launched as:
# bash <(curl -fsSL https://raw.githubusercontent.com/evilsaad0-hash/vms/main/main.sh)
# this file is only streamed, so clone the full repository before showing menu.
REPO_URL="https://github.com/evilsaad0-hash/vms.git"
INSTALL_DIR="${VMS_INSTALL_DIR:-$HOME/vms}"
SCRIPT_PATH="${BASH_SOURCE[0]}"

if [[ -f "$SCRIPT_PATH" ]]; then
    SCRIPT_DIR="$(cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"
else
    SCRIPT_DIR="$PWD"
fi

# A complete checkout contains all three menu scripts.
if [[ ! -f "$SCRIPT_DIR/lxc-setup.sh" || ! -f "$SCRIPT_DIR/root-maker.sh" || ! -f "$SCRIPT_DIR/vm-maker.sh" ]]; then
    echo "[INFO] Full toolkit not found. Preparing repository..."
    if ! command -v git >/dev/null 2>&1; then
        echo "[INFO] Installing Git..."
        if command -v apt-get >/dev/null 2>&1; then
            apt-get update && apt-get install -y git
        else
            echo "[ERROR] Git is required. Install Git and run this command again."
            exit 1
        fi
    fi

    if [[ -d "$INSTALL_DIR/.git" ]]; then
        echo "[INFO] Repository already exists: $INSTALL_DIR"
    elif [[ -e "$INSTALL_DIR" ]]; then
        echo "[ERROR] $INSTALL_DIR exists but is not a Git repository."
        echo "Set VMS_INSTALL_DIR to another path and try again."
        exit 1
    else
        mkdir -p "$(dirname -- "$INSTALL_DIR")"
        git clone "$REPO_URL" "$INSTALL_DIR" || {
            echo "[ERROR] Git clone failed. Check the repository URL and internet connection."
            exit 1
        }
    fi

    SCRIPT_DIR="$(cd -- "$INSTALL_DIR" && pwd)"
    if [[ ! -f "$SCRIPT_DIR/lxc-setup.sh" || ! -f "$SCRIPT_DIR/root-maker.sh" || ! -f "$SCRIPT_DIR/vm-maker.sh" ]]; then
        echo "[ERROR] Repository clone is missing one or more required scripts."
        exit 1
    fi
    exec bash "$SCRIPT_DIR/main.sh" "$@"
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

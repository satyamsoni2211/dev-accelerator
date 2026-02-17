#!/bin/bash

# =============================================================================
# Ghostty Terminal Setup - One-Click Installer
# =============================================================================
# Usage: curl -fsSL https://raw.githubusercontent.com/satyamsoni2211/ghostty-terminal-setup/main/install.sh | bash
# Or: ./install.sh
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Unicode symbols
CHECK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"
ARROW="${CYAN}→${NC}"
BULLET="${MAGENTA}•${NC}"
STAR="${YELLOW}★${NC}"
ROCKET="${GREEN}🚀${NC}"

# Variables
REPO_URL="${REPO_URL:-https://github.com/satyamsoni2211/dev-accelerator.git}"
INSTALL_DIR="${HOME}/.ghostty-setup"

# Print banner
print_banner() {
    printf "\033[2J\033[H"
    printf "${CYAN}"
    printf "╔═══════════════════════════════════════════════════════════════════╗\n"
    printf "║                                                                   ║\n"
    printf "║   ${WHITE}${BOLD}dev-accelerator${NC}${CYAN}                                          ║\n"
    printf "║   ${DIM}Ship code faster with a productivity-powered terminal${NC}${CYAN}       ║\n"
    printf "║                                                                   ║\n"
    printf "╚═══════════════════════════════════════════════════════════════════╝\n"
    printf "${NC}\n"
    echo ""
}

# Print section header
print_section() {
    echo -e "\n${WHITE}${BOLD}━━━ $1 ━━━${NC}\n"
}

# Print success message
print_success() {
    echo -e "${CHECK} ${GREEN}$1${NC}"
}

# Print info message
print_info() {
    echo -e "${ARROW} ${CYAN}$1${NC}"
}

# Print warning message
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_section "Checking Prerequisites"

    # Check for macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${CROSS} This script is designed for macOS only."
        exit 1
    fi
    print_success "macOS detected"

    # Check for Homebrew
    if ! command -v brew &> /dev/null; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_success "Homebrew installed"
    else
        print_success "Homebrew already installed ($(brew --version | head -1))"
    fi

    # Check for git
    if ! command -v git &> /dev/null; then
        print_info "Installing git..."
        brew install git
    fi
    print_success "git available"
}

# Clone repository
clone_repo() {
    print_section "Cloning Repository"

    # Remove old installation if exists
    if [ -d "$INSTALL_DIR" ]; then
        print_info "Removing old installation..."
        rm -rf "$INSTALL_DIR"
    fi

    print_info "Cloning ${REPO_URL}..."
    git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    print_success "Repository cloned to ${INSTALL_DIR}"
}

# Source setup.sh to use its functions
source_setup() {
    print_section "Loading Setup Functions"

    if [ -f "./setup.sh" ]; then
        # Source setup.sh - this makes its functions available
        # Note: setup.sh functions will override any local functions with same names
        source ./setup.sh
        print_success "Setup functions loaded"
    else
        print_warning "setup.sh not found"
        return 1
    fi
}

# Run installation - calls setup.sh functions directly after sourcing
do_install() {
    print_section "Installing Tools"

    # After sourcing setup.sh, these functions are available in global scope
    # Call setup.sh's install_tools function
    install_tools

    # Call setup.sh's install_oh_my_zsh function
    install_oh_my_zsh

    print_success "All tools installed!"
}

# Setup configurations using setup.sh's functions
setup_configs() {
    print_section "Setting Up Configurations"

    # Setup Zsh
    if declare -f setup_zsh > /dev/null 2>&1; then
        setup_zsh
    fi

    # Setup Starship
    if declare -f setup_starship > /dev/null 2>&1; then
        setup_starship
    fi

    # Setup Ghostty
    if declare -f setup_ghostty > /dev/null 2>&1; then
        setup_ghostty
    fi

    print_success "Configurations complete!"
}

# Set zsh as default shell
set_default_shell() {
    print_section "Setting Default Shell"

    if declare -f set_zsh_default > /dev/null 2>&1; then
        set_zsh_default
    else
        # Fallback implementation
        ZSH_PATH=$(which zsh)
        if [ "$SHELL" != "$ZSH_PATH" ]; then
            print_info "Adding zsh to allowed shells..."
            echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null 2>&1 || true

            print_info "Changing default shell to zsh..."
            chsh -s "$ZSH_PATH"
            print_success "Default shell set to zsh"
        else
            print_success "zsh is already your default shell"
        fi
    fi
}

# Cleanup
cleanup() {
    print_section "Cleaning Up"

    print_info "Removing temporary installation directory..."
    rm -rf "$INSTALL_DIR"
    print_success "Cleanup complete"
}

# Final message
print_final_message() {
    printf "\033[2J\033[H"
    printf "${GREEN}"
    printf "╔═══════════════════════════════════════════════════════════════════╗\n"
    printf "║                                                                   ║\n"
    printf "║   ${WHITE}${BOLD}${ROCKET}  Setup Complete!  ${ROCKET}${NC}${GREEN}                                        ║\n"
    printf "║                                                                   ║\n"
    printf "╚═══════════════════════════════════════════════════════════════════╝\n"
    printf "${NC}\n"

    printf "${WHITE}${BOLD}Installed Tools:${NC}\n"
    printf "${BULLET} ${CYAN}Ghostty${NC}        - GPU-accelerated terminal\n"
    printf "${BULLET} ${CYAN}Oh My Zsh${NC}     - Zsh framework\n"
    printf "${BULLET} ${CYAN}Zsh${NC}           - Shell with plugins\n"
    printf "${BULLET} ${CYAN}Zsh Plugins${NC}   - Autosuggestions, Syntax highlighting\n"
    printf "${BULLET} ${CYAN}Starship${NC}       - Cross-shell prompt\n"
    printf "${BULLET} ${CYAN}Atuin${NC}         - Shell history\n"
    printf "${BULLET} ${CYAN}Zoxide${NC}        - Smarter cd\n"
    printf "${BULLET} ${CYAN}FZF${NC}          - Fuzzy finder\n"
    printf "${BULLET} ${CYAN}Mise${NC}          - Runtime manager\n"
    printf "${BULLET} ${CYAN}FNM${NC}          - Node.js manager\n"
    printf "${BULLET} ${CYAN}Pyenv${NC}         - Python version manager\n"
    printf "${BULLET} ${CYAN}Uv${NC}            - Python package manager\n"
    printf "${BULLET} ${CYAN}Eza${NC}          - Modern ls\n"
    printf "${BULLET} ${CYAN}Bat${NC}           - Modern cat\n"
    printf "${BULLET} ${CYAN}Yazi${NC}          - File manager\n"
    printf "${BULLET} ${CYAN}Htop${NC}          - Process viewer\n"
    printf "${BULLET} ${CYAN}Direnv${NC}        - Environment manager\n"
    printf "${BULLET} ${CYAN}Jq${NC}            - JSON processor\n"
    printf "${BULLET} ${CYAN}TheFuck${NC}       - Command corrector\n"
    printf "${BULLET} ${CYAN}Fd${NC}            - Fast finder\n"
    printf "${BULLET} ${CYAN}Ripgrep${NC}       - Fast grep\n"
    echo ""

    printf "${WHITE}${BOLD}What's Next:${NC}\n"
    printf "  ${ARROW} Open Ghostty: ${CYAN}open -a Ghostty${NC}\n"
    printf "  ${ARROW} Or run:       ${CYAN}ghostty${NC}\n"
    echo ""

    printf "${YELLOW}${DIM}Note: Restart your terminal or run 'exec zsh' to apply changes${NC}\n"
    echo ""
}

# Open Ghostty
open_ghostty() {
    print_section "Opening Ghostty"

    if command -v ghostty &> /dev/null; then
        print_info "Launching Ghostty..."
        open -a Ghostty || ghostty &
        sleep 2
        print_success "Ghostty opened!"
    else
        print_warning "Ghostty not found in PATH. Please open manually: open -a Ghostty"
    fi
}

# Main
main() {
    print_banner

    # Trap for cleanup on error
    trap 'echo -e "\n${CROSS} Installation interrupted"; exit 1' INT TERM

    check_prerequisites
    clone_repo
    source_setup
    do_install
    setup_configs
    set_default_shell
    cleanup
    print_final_message
    open_ghostty
}

main "$@"

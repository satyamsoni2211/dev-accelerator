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
        source ./setup.sh
        print_success "Setup functions loaded"
    else
        print_warning "setup.sh not found, using built-in functions"
        return 1
    fi
}

# Install tools using setup.sh's install_tools function
install_tools() {
    print_section "Installing Tools"

    # Call setup.sh's install_tools function
    if declare -f install_tools > /dev/null 2>&1; then
        install_tools
    else
        print_warning "install_tools function not available"
        return 1
    fi

    # Call setup.sh's install_oh_my_zsh function
    if declare -f install_oh_my_zsh > /dev/null 2>&1; then
        install_oh_my_zsh
    else
        print_warning "install_oh_my_zsh function not available"
    fi

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
    clear
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                   ║"
    echo "║   ${WHITE}${BOLD}${ROCKET}  Setup Complete!  ${ROCKET}${NC}${GREEN}                                        ║"
    echo "║                                                                   ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    echo -e "${WHITE}${BOLD}Installed Tools:${NC}"
    echo -e "${BULLET} ${CYAN}Ghostty${NC}        - GPU-accelerated terminal"
    echo -e "${BULLET} ${CYAN}Oh My Zsh${NC}     - Zsh framework"
    echo -e "${BULLET} ${CYAN}Zsh${NC}           - Shell with plugins"
    echo -e "${BULLET} ${CYAN}Starship${NC}       - Cross-shell prompt"
    echo -e "${BULLET} ${CYAN}Atuin${NC}         - Shell history"
    echo -e "${BULLET} ${CYAN}Zoxide${NC}        - Smarter cd"
    echo -e "${BULLET} ${CYAN}FZF${NC}          - Fuzzy finder"
    echo -e "${BULLET} ${CYAN}Mise${NC}          - Runtime manager"
    echo -e "${BULLET} ${CYAN}FNM${NC}          - Node.js manager"
    echo -e "${BULLET} ${CYAN}Eza${NC}          - Modern ls"
    echo -e "${BULLET} ${CYAN}Bat${NC}           - Modern cat"
    echo -e "${BULLET} ${CYAN}Yazi${NC}          - File manager"
    echo -e "${BULLET} ${CYAN}Pet${NC}           - Snippet manager"
    echo -e "${BULLET} ${CYAN}Htop${NC}          - Process viewer"
    echo -e "${BULLET} ${CYAN}Direnv${NC}        - Environment manager"
    echo -e "${BULLET} ${CYAN}Jq${NC}            - JSON processor"
    echo -e "${BULLET} ${CYAN}TheFuck${NC}       - Command corrector"
    echo -e "${BULLET} ${CYAN}Uv${NC}            - Python package manager"
    echo -e "${BULLET} ${CYAN}Fd${NC}            - Fast finder"
    echo -e "${BULLET} ${CYAN}Ripgrep${NC}       - Fast grep"
    echo ""

    echo -e "${WHITE}${BOLD}What's Next:${NC}"
    echo -e "  ${ARROW} Open Ghostty: ${CYAN}open -a Ghostty${NC}"
    echo -e "  ${ARROW} Or run:       ${CYAN}ghostty${NC}"
    echo ""

    echo -e "${YELLOW}${DIM}Note: Restart your terminal or run 'exec zsh' to apply changes${NC}"
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
    install_tools
    setup_configs
    set_default_shell
    cleanup
    print_final_message
    open_ghostty
}

main "$@"

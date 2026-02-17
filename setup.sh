#!/bin/bash

# Ghostty Terminal Setup Script
# This script sets up Ghostty and all required tools on macOS
# Usage: ./setup.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Ghostty Terminal Setup ===${NC}"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}This script is designed for macOS only.${NC}"
    exit 1
fi

# Check for Homebrew and install if not available
check_brew() {
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}Homebrew is not installed.${NC}"
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo -e "${GREEN}Homebrew installed successfully!${NC}"
    fi
}

# Install required tools
install_tools() {
    echo -e "${YELLOW}Checking and installing missing tools...${NC}"

    # Check if zsh is installed via any method
    check_zsh_installed() {
        # Check if zsh exists in common locations
        if command -v zsh &> /dev/null; then
            return 0
        elif [ -f "/bin/zsh" ] || [ -f "/usr/bin/zsh" ]; then
            return 0
        elif [ -d "$HOME/.oh-my-zsh" ]; then
            # Oh My Zsh includes zsh
            return 0
        fi
        return 1
    }

    # Install zsh if not found
    if check_zsh_installed; then
        echo -e "${GREEN}✓${NC} zsh already installed"
    else
        echo -e "${YELLOW}→${NC} Installing zsh..."
        brew install zsh --quiet
        echo -e "${GREEN}✓${NC} zsh installed"
    fi

    # Define packages to check (formulae) - skip zsh since we handled it above
    local formulae=(
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "fzf"
        "fd"
        "zoxide"
        "yazi"
        "ripgrep"
        "atuin"
        "starship"
        "thefuck"
        "direnv"
        "mise"
        "fnm"
        "uv"
        "jq"
        "eza"
        "bat"
        "htop"
    )

    # Define casks to check
    local casks=(
        "ghostty"
    )

    # Check and install missing formulae
    for formula in "${formulae[@]}"; do
        if brew list "$formula" &> /dev/null; then
            echo -e "${GREEN}✓${NC} $formula already installed"
        else
            echo -e "${YELLOW}→${NC} Installing $formula..."
            brew install "$formula" --quiet
            echo -e "${GREEN}✓${NC} $formula installed"
        fi
    done

    # Check and install missing casks
    # For ghostty, also check if command exists (may be installed via DMG/pkg)
    for cask in "${casks[@]}"; do
        local is_installed=false

        # Check via brew cask first
        if brew list --cask "$cask" &> /dev/null; then
            is_installed=true
        # For ghostty, also check if command exists (installed via DMG/pkg)
        elif [ "$cask" = "ghostty" ] && command -v ghostty &> /dev/null; then
            is_installed=true
        fi

        if [ "$is_installed" = true ]; then
            echo -e "${GREEN}✓${NC} $cask already installed"
        else
            echo -e "${YELLOW}→${NC} Installing $cask..."
            brew install --cask "$cask" --quiet
            echo -e "${GREEN}✓${NC} $cask installed"
        fi
    done

    echo -e "${GREEN}All tools checked and installed successfully!${NC}"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    echo -e "${YELLOW}Installing Oh My Zsh...${NC}"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${GREEN}✓${NC} Oh My Zsh already installed"
    else
        echo -e "${YELLOW}Note:${NC} Any previous .zshrc will be renamed to .zshrc.pre-oh-my-zsh"
        echo -e "${YELLOW}After installation, you can move the configuration you want to preserve into the new .zshrc${NC}"
        echo ""

        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

        # Set ZSH_CUSTOM
        export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

        echo -e "${GREEN}✓${NC} Oh My Zsh installed"
    fi

    # Set ZSH_CUSTOM even if already installed
    export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
}

# Setup Zsh configuration
setup_zsh() {
    echo -e "${YELLOW}Setting up Zsh configuration...${NC}"

    # Create config directory
    local config_dir="$HOME/.config/ghostty-setup"
    mkdir -p "$config_dir"

    # Backup existing .zshrc if it exists and hasn't been backed up
    if [ -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.zshrc.backup" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
        echo -e "${GREEN}✓${NC} Backed up existing .zshrc to .zshrc.backup"
    fi

    # Create .zshrc if it doesn't exist
    if [ ! -f "$HOME/.zshrc" ]; then
        touch "$HOME/.zshrc"
    fi

    # Create the separate config file
    if [ ! -f "$config_dir/zsh.env" ]; then
        cp ./zsh.env "$config_dir/zsh.env"
        echo -e "${GREEN}✓${NC} Created config file at $config_dir/zsh.env"
    else
        echo -e "${YELLOW}Config file already exists, skipping.${NC}"
    fi

    # Add source line to .zshrc only if not present
    local source_line="# Source Ghostty Terminal Setup config"
    if ! grep -q "ghostty-setup/zsh.env" "$HOME/.zshrc" 2>/dev/null; then
        cat >> "$HOME/.zshrc" << 'EOF'

# === Ghostty Terminal Setup ===
# Initialized by setup.sh

EOF
        echo "source \"$config_dir/zsh.env\"" >> "$HOME/.zshrc"
        echo -e "${GREEN}✓${NC} Added source line to .zshrc"
    else
        echo -e "${YELLOW}Source line already in .zshrc, skipping.${NC}"
    fi
}

# Setup Starship prompt
setup_starship() {
    echo -e "${YELLOW}Setting up Starship prompt...${NC}"

    # Create starship config directory
    mkdir -p "$HOME/.config"

    # Create starship config only if it doesn't exist
    if [ ! -f "$HOME/.config/starship.toml" ]; then
        starship preset gruvbox-rainbow -o "$HOME/.config/starship.toml" 2>/dev/null || {
            # Fallback if preset command not available
            cat > "$HOME/.config/starship.toml" << 'EOF'
format = "$username$hostname$directory$git_branch$git_status$nodejs$python$rust$golang$context$character"
[username]
show_always = true
style_root = "bold red"
style_user = "bold blue"
[hostname]
show_always = true
style = "bold blue"
[directory]
style = "bold cyan"
truncation_symbol = ""
home_symbol = "~"
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"
[nodejs]
symbol = "node "
style = "bold green"
[python]
symbol = "py "
style = "bold yellow"
[rust]
symbol = "rs "
style = "bold red"
EOF
        }
        echo -e "${GREEN}Starship config created!${NC}"
    else
        echo -e "${YELLOW}Starship config already exists, skipping.${NC}"
    fi

    # Add starship init to .zshrc only if not present
    if ! grep -q "starship init" "$HOME/.zshrc"; then
        echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
        echo -e "${GREEN}Starship init added to .zshrc!${NC}"
    else
        echo -e "${YELLOW}Starship init already in .zshrc, skipping.${NC}"
    fi
}

# Setup Ghostty configuration
setup_ghostty() {
    echo -e "${YELLOW}Setting up Ghostty configuration...${NC}"

    # Create ghostty config directory
    mkdir -p "$HOME/.config/ghostty"

    # Create ghostty config only if it doesn't exist
    if [ ! -f "$HOME/.config/ghostty/config" ]; then
        cp ghostty_config "$HOME/.config/ghostty/config"
        echo -e "${GREEN}Ghostty configuration created!${NC}\n"
    else
        # backup existing config if it exists and hasn't been backed up
        echo -e "${YELLOW}Ghostty configuration already exists.${NC}"
    fi
}

# Set zsh as default shell
set_zsh_default() {
    echo -e "${YELLOW}Setting Zsh as default shell...${NC}"

    # Add zsh to allowed shells if not already
    if ! grep -q "$(which zsh)" /etc/shells 2>/dev/null; then
        echo "$(which zsh)" | sudo tee -a /etc/shells
    fi

    # Change default shell
    chsh -s "$(which zsh)"

    echo -e "${GREEN}Zsh set as default shell!${NC}"
}

# Main menu
main() {
    check_brew

    echo "Select installation method:"
    echo "1) Full setup (install all tools + configure)"
    echo "2) Install tools only"
    echo "3) Configure only (assumes tools are installed)"
    echo "4) Quit"
    echo ""

    read -p "Enter choice [1-4]: " choice
    echo ""

    case $choice in
        1)
            install_tools
            install_oh_my_zsh
            setup_zsh
            setup_starship
            setup_ghostty
            set_zsh_default
            echo ""
            echo -e "${GREEN}=== Setup Complete! ===${NC}"
            echo "Please restart your terminal or run: exec zsh"
            ;;
        2)
            install_tools
            install_oh_my_zsh
            echo ""
            echo -e "${GREEN}=== Tools Installed! ===${NC}"
            echo "Run option 3 to configure the tools."
            ;;
        3)
            install_oh_my_zsh
            setup_zsh
            setup_starship
            setup_ghostty
            set_zsh_default
            echo ""
            echo -e "${GREEN}=== Configuration Complete! ===${NC}"
            echo "Please restart your terminal or run: exec zsh"
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice.${NC}"
            exit 1
            ;;
    esac
}

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

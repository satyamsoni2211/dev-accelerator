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

# Install Ghostty
install_ghostty() {
    echo -e "${YELLOW}Installing Ghostty via Brewfile...${NC}"
    brew bundle install --file="$(dirname "$0")/Brewfile"
    echo -e "${GREEN}Ghostty installed successfully!${NC}"
}

# Install required tools
install_tools() {
    echo -e "${YELLOW}Installing required tools via Brewfile...${NC}"

    # Use Brewfile for all installations
    brew bundle install --file="$(dirname "$0")/Brewfile"

    echo -e "${GREEN}All tools installed successfully!${NC}"
}

# Setup Zsh configuration
setup_zsh() {
    echo -e "${YELLOW}Setting up Zsh configuration...${NC}"

    # Create .zshrc if it doesn't exist
    if [ ! -f "$HOME/.zshrc" ]; then
        touch "$HOME/.zshrc"
    fi

    # Marker to track if our config was added
    MARKER="# === Ghostty Terminal Setup ==="

    # Only add if marker not present
    if ! grep -q "$MARKER" "$HOME/.zshrc" 2>/dev/null; then
        cat >> "$HOME/.zshrc" << 'EOF'

# === Ghostty Terminal Setup ===
# Initialized by setup.sh

# --- zsh-autosuggestions Configuration ---
# Fish-like autosuggestions based on history
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Optimization: Limit buffer size for better performance
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Enable async mode for faster suggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# Customize suggestion color (subtle gray)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"

# Suggest from history and completion
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# --- zsh-syntax-highlighting Configuration ---
# Must be loaded AFTER zsh-autosuggestions
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set up zoxide
eval "$(zoxide init zsh)"

# Set up atuin
eval "$(atuin init zsh)"

# PET snippet manager
export PET_CONFIG="$HOME/.config/pet/config.toml"

# --- fzf Configuration ---
# Fuzzy finder for files, history, and more
source <(fzf --zsh)

# Configure fzf
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --color=always --tree --level=2 {}'"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude '.git'"

# Use eza instead of ls
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# General aliases
alias cat='bat --style=auto'
alias find='fd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Correct command with thefuck
eval "$(thefuck --alias)"

# Enable direnv
eval "$(direnv hook zsh)"

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

# Node.js version manager (fnm)
eval "$(fnm env)"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Starship prompt
eval "$(starship init zsh)"

# Mise version manager
eval "$(mise activate zsh)"

# Enable color support
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Set language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
EOF
        echo -e "${GREEN}Zsh configuration added!${NC}"
    else
        echo -e "${YELLOW}Zsh configuration already exists, skipping.${NC}"
    fi
}

# Setup Starship prompt
setup_starship() {
    echo -e "${YELLOW}Setting up Starship prompt...${NC}"

    # Create starship config directory
    mkdir -p "$HOME/.config"

    # Create starship config only if it doesn't exist
    if [ ! -f "$HOME/.config/starship.toml" ]; then
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
        cat > "$HOME/.config/ghostty/config" << 'EOF'
# Ghostty Configuration

# Font configuration
font-family = JetBrains Mono
font-size = 13
font-weight = 400

# Catppuccin Mocha theme
background = #1e1e2e
foreground = #cdd6f4
cursor-color = #f5e0dc
selection-background = #45475a
selection-foreground = #cdd6f4

# Window settings
window-padding-x = 10
window-padding-y = 10
window-padding-display = centered
window-title = @{title}

# Tab bar
tab-bar = always
tab-bar-font-size = 12
tab-bar-background = #181825
tab-bar-foreground = #cdd6f4
tab-bar-mode = flex
tab-title = @{window-title}

# Shell
shell-integration-features = no-cursor

# Keybindings
keybindings = cmd-t: new_tab
keybindings = cmd-w: close_tab
keybindings = cmd-shift-bracketright: next_tab
keybindings = cmd-shift-bracketleft: previous_tab
keybindings = cmd-shift-n: new_window
keybindings = cmd-plus: font_size_increase
keybindings = cmd-minus: font_size_decrease
keybindings = cmd-0: font_size_reset

# Mouse
mouse-hide = true

# Bell
bell = none
EOF
        echo -e "${GREEN}Ghostty configuration created!${NC}"
    else
        echo -e "${YELLOW}Ghostty config already exists, skipping.${NC}"
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
            echo ""
            echo -e "${GREEN}=== Tools Installed! ===${NC}"
            echo "Run option 3 to configure the tools."
            ;;
        3)
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

main "$@"

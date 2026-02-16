# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository is for Ghostty terminal configuration and setup. It supports three installation methods:
1. **One-Click Installer** - Dynamic package checking, auto-detects installed tools
2. **Homebrew + Setup Script** - Interactive setup
3. **Shell Script Only** - Manual setup

Ghostty is a GPU-accelerated terminal emulator built with Zig.

## Project Structure

```
dev-accelerator/
├── flake.nix              # Nix flake entry point
├── Brewfile               # Homebrew dependencies
├── install.sh             # One-click installer
├── setup.sh               # Interactive setup script
├── README.md              # Setup instructions
├── CLAUDE.md              # This file
├── home/
│   └── configuration.nix  # Home Manager config
├── ghostty/
│   └── ghostty.nix        # Ghostty terminal config
├── zsh/
│   └── zshrc.nix          # Zsh configuration
└── tests/
    ├── docker/            # Docker test images
    │   ├── Dockerfile.nix
    │   ├── Dockerfile.homebrew
    │   ├── Dockerfile.script
    │   └── docker-compose.yml
    ├── run-tests.sh       # Test runner
    └── README.md          # Test documentation
```

## Installation Methods

### Method 1: One-Click Installer (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/satyamsoni2211/dev-accelerator/main/install.sh | bash
```

Features:
- Dynamically checks for installed packages (only installs missing ones)
- Auto-detects zsh if installed via any method
- Backs up existing .zshrc before modifications
- Uses gruvbox-rainbow Starship preset

### Method 2: Homebrew + Setup Script

```bash
# Install dependencies
brew bundle install

# Configure everything
./setup.sh
```

### Method 3: Shell Script

```bash
# Run setup script
chmod +x setup.sh
./setup.sh
```

## Key Features

- **Dynamic package checking** - Only installs missing packages via `brew list`
- **Zsh auto-detection** - Checks PATH, system locations, and Oh My Zsh
- **Safe .zshrc handling** - Creates backup at `~/.zshrc.backup`
- **Ghostty config** - Uses valid options only (keybind, shell-integration, etc.)
- **Starship** - gruvbox-rainbow preset

## Common Commands

### Building Ghostty from source
```bash
# Clone and build Ghostty
git clone https://github.com/ghostty-org/ghostty
cd ghostty
zig build -Drelease-safe

# Or use the released binary
brew install ghostty
```

### Configuration
Ghostty uses a configuration file at `~/.config/ghostty/config`. Valid options include:
- `keybind` - Keybindings (not `keybindings`)
- `shell-integration` - Enable shell integration
- `shell-integration-features` - Features like no-title, cursor, sudo
- `title` - Window title

## Notes

- This repository is initialized with permissions for ghostty.org, nix.dev, github.io, and github.com
- Ghostty uses a custom configuration syntax documented at https://ghostty.org/docs/config
- Tools included: ghostty, zsh, zsh-autosuggestions, zsh-syntax-highlighting, fzf, fd, zoxide, yazi, ripgrep, atuin, starship, mise, fnm, uv, jq, thefuck, eza, bat, htop, direnv, pet
- Note: `git` is assumed to be pre-installed and not installed by the scripts
- The Brewfile also includes `knqyf263/pet/pet` for snippet management

## Testing

Docker/Podman-based tests for validation:
```bash
cd tests
./run-tests.sh all           # Auto-detect Docker or Podman
./run-tests-docker.sh all      # Force Docker
./run-tests-podman.sh all     # Force Podman

# Run specific test
./run-tests.sh nix            # Test Nix flake
./run-tests.sh homebrew       # Test Homebrew
./run-tests.sh script         # Test shell script
```

Test files in `tests/docker/`:
- `Dockerfile.nix` - Nix flakes test
- `Dockerfile.homebrew` - Homebrew test
- `Dockerfile.script` - Shell script test
- `docker-compose.yml` - Run all tests

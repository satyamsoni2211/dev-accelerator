# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository is for Ghostty terminal configuration and setup. It supports three installation methods:
1. **Nix Flakes** - Declarative configuration with Home Manager
2. **Homebrew** - Using Brewfile
3. **Shell Script** - Manual setup script

Ghostty is a GPU-accelerated terminal emulator built with Zig.

## Project Structure

```
ghostty-terminal-setup/
├── flake.nix              # Nix flake entry point
├── Brewfile               # Homebrew dependencies
├── setup.sh               # Shell script setup
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

### Method 1: Nix Flakes (Recommended for Nix users)

```bash
# Configure Nix
mkdir -p ~/.config/nix
echo 'experimental-features = flakes nix-command' > ~/.config/nix/nix.conf

# Clone and activate
git clone <repo> && cd repo
home-manager switch --flake .#<username>@<hostname>
```

### Method 2: Homebrew

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
Ghostty uses a configuration file at `~/.config/ghostty/config`. Key configuration options include:
- `font-family` - Terminal font
- `font-size` - Font size
- `theme` - Color theme
- `shell` - Default shell to use

### Development commands
```bash
# Run Ghostty in development mode
zig build run

# Run tests
zig build test
```

## Architecture

This is a terminal emulator configuration project with three setup methods:

- **Nix** - Declarative using flake.nix and Home Manager
- **Homebrew** - Using Brewfile for dependencies
- **Shell Script** - Interactive setup.sh script

### Key Components

- **Ghostty** - Terminal emulator (GPU-accelerated)
- **Zsh** - Shell with plugins
- **Starship** - Cross-shell prompt
- **Atuin** - Shell history
- **Zoxide** - Smart cd
- **FZF** - Fuzzy finder

## Notes

- This repository is initialized with permissions for ghostty.org, nix.dev, github.io, and github.com
- Ghostty uses a custom configuration syntax documented at https://ghostty.org/docs/config
- Tools included: gh, git, fzf, fd, zoxide, yazi, atuin, starship, mise, fnm, uv, jq, thefuck, eza, bat, htop, direnv, pet

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

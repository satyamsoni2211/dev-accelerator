# dev-accelerator - Developer Productivity Terminal Setup

A Nix flake-based configuration to install and set up Ghostty terminal on macOS with all required plugins and tools. Also includes Homebrew and shell script fallbacks.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/satyamsoni2211/dev-accelerator/main/install.sh | bash
```

Or download and run manually:
```bash
curl -fsSL https://github.com/satyamsoni2211/dev-accelerator/archive/main.zip -o dev-accelerator.zip
unzip dev-accelerator.zip
cd dev-accelerator
chmod +x install.sh
./install.sh
```

> Note: Replace `satyamsoni2211` with your GitHub username after forking this repo.

## Features

- **Ghostty** - GPU-accelerated terminal emulator
- **Zsh** - Shell with plugins
- **Starship** - Cross-shell prompt
- **Atuin** - Shell history with sync
- **Zoxide** - Smarter cd command
- **FZF** - Fuzzy finder
- **Mise** - Runtime manager
- **And more tools...**

## Installation Methods

Choose one of the three methods below:

### Method 1: Homebrew (Recommended for most users)

The easiest way to get started:

```bash
# Install Homebrew if you haven't already
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone this repository
git clone https://github.com/satyamsoni2211/dev-accelerator.git
cd dev-accelerator

# Install all tools via Homebrew Bundle
brew bundle install

# Run the setup script to configure everything
./setup.sh
```

Or manually:
```bash
# Install Ghostty
brew install ghostty

# Install all tools
brew install git gh zsh zsh-autosuggestions zsh-syntax-highlighting fzf fd zoxide atuin starship thefuck direnv mise fnm uv jq eza bat htop

# Configure zsh
./setup.sh  # Select option 3 for configure only
```

### Method 2: Shell Script (No package manager)

If you prefer manual installation:

```bash
# Clone this repository
git clone https://github.com/satyamsoni2211/dev-accelerator.git
cd dev-accelerator

# Make script executable
chmod +x setup.sh

# Run the setup script
./setup.sh
```

The script will:
- Install Homebrew if not present
- Install Ghostty and all tools
- Configure Zsh with plugins
- Set up Starship prompt
- Create Ghostty configuration
- Set Zsh as default shell

### Method 3: Nix Flakes (For Nix users)

For advanced users who want declarative configuration:

#### Prerequisites

1. **Nix installed** - Install via:
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. **macOS** - This configuration is designed for macOS

3. **Apple Silicon or Intel Mac** - Works on both architectures

#### Quick Install

### Step 1: Configure Nix

```bash
# Create nix config directory
mkdir -p ~/.config/nix

# Enable flakes and nix-command
echo 'experimental-features = flakes nix-command' > ~/.config/nix/nix.conf
```

For daemon mode (recommended on macOS):
```bash
# Backup existing config if any
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.bak 2>/dev/null || true

# Create new nix config
sudo mkdir -p /etc/nix
echo 'experimental-features = flakes nix-command' | sudo tee /etc/nix/nix.conf

# Restart nix-daemon
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

### Step 2: Clone and Setup

```bash
# Clone this repository
git clone https://github.com/satyamsoni2211/ghostty-nix.git
cd ghostty-nix

# Generate lock file
nix flake update
```

### Step 3: Activate Configuration

```bash
# Replace 'satyam' with your username
home-manager switch --flake .#satyam@Satyams-MacBook-Pro
```

> **Note**: Replace `Satyams-MacBook-Pro` with your actual hostname. You can find it with: `hostname`

## Configuration Customization

### Change Username/Hostname

Edit `home/configuration.nix` and update:
```nix
home = {
  username = "your-username";
  homeDirectory = "/Users/your-username";
};
```

### Add More Packages

Edit `home/configuration.nix` and add packages to the list:
```nix
home.packages = with pkgs; [
  # Add your packages here
  tmux
  neovim
  # ...
];
```

### Customize Ghostty

Edit `ghostty/ghostty.nix` to change:
- Font family and size
- Color theme
- Keybindings
- Window settings

### Customize Zsh

Edit `zsh/zshrc.nix` to:
- Add custom aliases
- Configure plugins
- Add environment variables

## Tools Included

| Tool | Description |
|------|-------------|
| `gh` | GitHub CLI |
| `git` | Version control |
| `zsh-autosuggestions` | Zsh plugin for command suggestions |
| `zsh-syntax-highlighting` | Zsh plugin for syntax highlighting |
| `fzf` | Fuzzy finder |
| `fd` | Fast file finder |
| `zoxide` | Smarter cd command |
| `yazi` | Blazing fast file manager |
| `atuin` | Shell history with sync |
| `starship` | Cross-shell prompt |
| `mise` | Runtime version manager |
| `fnm` | Node.js version manager |
| `uv` | Python package manager |
| `jq` | JSON processor |
| `thefuck` | Command correction |
| `pet` | Snippet manager |
| `eza` | Modern ls replacement |
| `bat` | Modern cat replacement |
| `htop` | Interactive process viewer |
| `direnv` | Environment variable loader |

## Troubleshooting

### Nix Daemon Issues

If you encounter permission errors:
```bash
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

### Ghostty Not Found

The configuration builds Ghostty from source. If you want to use the binary instead:
```bash
# Install via Homebrew instead
brew install ghostty

# Then remove ghostty from the overlay in flake.nix
```

### Update Configuration

To update all packages:
```bash
nix flake update
home-manager switch --flake .#satyam@Satyams-MacBook-Pro
```

## Uninstall

```bash
# Remove the generated files
rm -rf ~/.config/ghostty
rm -rf ~/.config/starship.toml

# Remove nix configuration
rm -rf ~/.config/nix
sudo rm -rf /etc/nix
```

## Testing

Docker-based tests are provided to validate all three installation methods:

```bash
# Run all tests
cd tests
./run-tests.sh all

# Run specific test
./run-tests.sh nix       # Test Nix flake setup
./run-tests.sh homebrew  # Test Homebrew setup
./run-tests.sh script    # Test shell script setup
```

See `tests/README.md` for more details.

## Credits

- [Ghostty](https://ghostty.org) - Terminal emulator
- [Nix](https://nixos.org) - Package manager
- [Home Manager](https://github.com/nix-community/home-manager) - Nix-based dotfile management
- [Catppuccin](https://github.com/catppuccin/catppuccin) - Color theme

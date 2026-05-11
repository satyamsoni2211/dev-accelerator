# dev-accelerator

> ⚡ A one-command macOS terminal setup — Ghostty + Zsh + 30 modern CLI tools, ready in minutes.

```
╭─────────────────────────────────────────────────────────────────────────╮
│  dev-accelerator  ─  Ghostty + Zsh + 30 modern CLI tools                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ❯ ls                                                                    │
│  󰉋 src/   󰉋 tests/   󰉋 docs/    setup.sh   install.sh   README.md      │
│                                                                          │
│  ❯ git log --oneline                                                     │
│  a3f1c2e  feat: add zoxide smart cd integration                          │
│  b89d041  fix: backup .zshrc before modification                         │
│  c12e8a3  chore: add atuin shell history sync                            │
│                                                                          │
│  ❯ btm                          ❯ fzf                                    │
│  CPU  [████████░░░░] 42%        ╭──────────────────────╮                 │
│  MEM  [█████░░░░░░░] 51%        │ > install.sh         │                 │
│  NET  ↑ 1.2 MB/s ↓ 840 KB/s    │   setup.sh           │                 │
│                                 │   flake.nix          │                 │
│  ❯ z dev   # zoxide jump        ╰──────────────────────╯                 │
│  ~/projects/dev-accelerator                                              │
│                                                                          │
│  satyam@macbook  ~/projects/dev-accelerator  main ✓  took 0.3s          │
╰─────────────────────────────────────────────────────────────────────────╯
```

<p align="center">
  <a href="https://github.com/satyamsoni2211/dev-accelerator/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/satyamsoni2211/dev-accelerator" alt="License: MIT">
  </a>
  <a href="https://github.com/satyamsoni2211/dev-accelerator/stargazers">
    <img src="https://img.shields.io/github/stars/satyamsoni2211/dev-accelerator?style=social" alt="GitHub Stars">
  </a>
  <img src="https://img.shields.io/badge/platform-macOS-lightgrey?logo=apple" alt="macOS">
  <img src="https://img.shields.io/badge/shell-zsh-green?logo=gnu-bash" alt="Zsh">
</p>

---

## Why dev-accelerator?

Setting up a productive macOS terminal from scratch takes hours — installing tools one by one, configuring plugins, tweaking dotfiles. **dev-accelerator** does it all in a single command:

- ✅ Ghostty GPU-accelerated terminal with a beautiful Catppuccin theme
- ✅ Zsh with autosuggestions, syntax highlighting, and smart history
- ✅ 30+ modern CLI tools replacing outdated Unix defaults
- ✅ Smart installer — only installs what's missing, backs up your existing `.zshrc`
- ✅ Three setup paths: one-click, Homebrew, or Nix Flakes

---

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

> **Note:** After forking, replace `satyamsoni2211` with your GitHub username in the curl URL.

---

## Features

- **Ghostty** — GPU-accelerated terminal emulator with Catppuccin theme
- **Zsh** — shell with plugins (auto-detects if already installed)
- **Starship** — cross-shell prompt with gruvbox-rainbow preset
- **Atuin** — shell history with sync across machines
- **Zoxide** — smarter `cd` that learns your habits
- **FZF** — fuzzy finder wired into your shell
- **Mise** — runtime version manager for Node, Python, Ruby, and more
- **Dynamic package checking** — only installs what's missing
- **Safe `.zshrc` handling** — creates a backup before any modifications
- **Improved error handling** — graceful recovery from install failures

---

## Installation Methods

### Method 1: One-Click Installer (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/satyamsoni2211/dev-accelerator/main/install.sh | bash
```

This script checks for Homebrew, installs only missing packages, configures Zsh with all plugins, sets up Starship with gruvbox-rainbow, creates a Ghostty config with Catppuccin, backs up your existing `.zshrc`, and sets Zsh as your default shell.

---

### Method 2: Homebrew + Setup Script

```bash
# Install Homebrew if you haven't already
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone this repository
git clone https://github.com/satyamsoni2211/dev-accelerator.git
cd dev-accelerator

# Run the setup script (interactively selects options)
./setup.sh
```

---

### Method 3: Manual Setup Script Only

```bash
git clone https://github.com/satyamsoni2211/dev-accelerator.git
cd dev-accelerator
chmod +x setup.sh
./setup.sh
```

---

### Method 4: Nix Flakes (For Nix users)

For advanced users who want a fully declarative configuration:

**Prerequisites:** Nix installed, macOS (Apple Silicon or Intel)

```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable flakes
mkdir -p ~/.config/nix
echo 'experimental-features = flakes nix-command' > ~/.config/nix/nix.conf

# Clone and activate
git clone https://github.com/satyamsoni2211/dev-accelerator.git
cd dev-accelerator
nix flake update

# Replace 'satyam' and 'Satyams-MacBook-Pro' with your username and hostname
home-manager switch --flake .#satyam@Satyams-MacBook-Pro
```

> Find your hostname with: `hostname`

---

## Tools Included

### Core CLI Tools

| Tool | Replaces | Description |
|---|---|---|
| `ghostty` | iTerm2 / Terminal.app | GPU-accelerated terminal emulator |
| `zsh` + plugins | bash | Shell with autosuggestions and syntax highlighting |
| `starship` | plain prompt | Cross-shell prompt (gruvbox-rainbow preset) |
| `eza` | `ls` | Modern file listing with icons |
| `bat` | `cat` | Syntax-highlighted file viewer |
| `ripgrep` | `grep` | Blazing fast text search |
| `fd` | `find` | Intuitive file finder |
| `zoxide` | `cd` | Smart directory jumping |
| `fzf` | — | Fuzzy finder for files, history, and more |
| `atuin` | shell history | Shell history with sync and search |
| `yazi` | — | Terminal file manager |
| `lazygit` | git CLI | TUI for git |
| `jq` | — | JSON processor |
| `direnv` | — | Per-directory environment variables |
| `mise` | nvm/pyenv/rbenv | Unified runtime version manager |
| `fnm` | nvm | Fast Node.js version manager |
| `pyenv` | — | Python version manager |
| `uv` | pip | Ultra-fast Python package manager |
| `thefuck` | — | Corrects your previous command |
| `htop` | top | Interactive process viewer |

### 2025/2026 Productivity Tools

| Tool | Description |
|---|---|
| `bottom` (`btm`) | Modern system monitor |
| `tealdeer` | Fast `tldr` client |
| `delta` | Git diff with syntax highlighting |
| `tokei` | Code statistics (lines of code) |
| `zellij` | Terminal workspace (tmux alternative) |
| `gitui` | Git TUI |
| `procs` | Modern `ps` replacement |
| `ouch` | All-in-one compression/decompression |

> `git` is assumed pre-installed and is not managed by these scripts.

---

## Configuration Customization

### Change Username/Hostname (Nix method)

Edit `home/configuration.nix`:

```nix
home = {
  username = "your-username";
  homeDirectory = "/Users/your-username";
};
```

### Add More Packages (Nix method)

```nix
home.packages = with pkgs; [
  tmux
  neovim
  # add packages here
];
```

### Customize Ghostty

Edit `ghostty/ghostty.nix` or `ghostty_config` to change font, color theme, keybindings, and window settings.

### Customize Zsh

Edit `zsh/zshrc.nix` or the files under `zsh/` to add aliases, configure plugins, and set environment variables.

---

## Testing

Docker-based tests validate all installation methods:

```bash
cd tests

# Run all tests
./run-tests.sh all

# Run a specific test
./run-tests.sh nix       # Nix flake setup
./run-tests.sh homebrew  # Homebrew setup
./run-tests.sh script    # Shell script setup
```

See `tests/README.md` for full details.

---

## Uninstall

```bash
rm -rf ~/.config/ghostty
rm -rf ~/.config/starship.toml

# Restore .zshrc backup if needed
# cp ~/.zshrc.backup ~/.zshrc

# Remove Nix configuration (if using Nix method)
rm -rf ~/.config/nix
sudo rm -rf /etc/nix
```

---

## Troubleshooting

**Nix daemon issues:**
```bash
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

**Ghostty not found (Nix method):**
```bash
# Install via Homebrew instead
brew install ghostty
# Then remove ghostty from the overlay in flake.nix
```

**Update everything (Nix method):**
```bash
nix flake update
home-manager switch --flake .#satyam@Satyams-MacBook-Pro
```

---

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to add tools, fix bugs, or improve documentation.

---

## Credits

- [Ghostty](https://ghostty.org) — terminal emulator
- [Nix](https://nixos.org) — package manager
- [Home Manager](https://github.com/nix-community/home-manager) — Nix-based dotfile management
- [Catppuccin](https://github.com/catppuccin/catppuccin) — color theme
- [Starship](https://starship.rs) — shell prompt

---

## License

[MIT](LICENSE) © 2025 Satyam Soni
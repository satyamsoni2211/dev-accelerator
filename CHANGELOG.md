# Changelog

All notable changes to **dev-accelerator** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

> Changes that are merged but not yet tagged as a release.

---

## [1.0.0] - 2025-05-01

### Added
- Initial release of dev-accelerator
- One-click installer via `install.sh` with automatic Homebrew detection
- Homebrew-based setup via `setup.sh` with interactive options
- Nix Flakes support for declarative macOS configuration
- **Ghostty** GPU-accelerated terminal with Catppuccin theme pre-configured
- **Zsh** setup with the following plugins:
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
- **Starship** prompt with gruvbox-rainbow preset
- **Atuin** shell history with sync support
- **Zoxide** smarter `cd` replacement
- **FZF** fuzzy finder with shell integration
- **Mise** runtime version manager
- **Yazi** blazing fast terminal file manager
- Core CLI tools: `ripgrep`, `fd`, `bat`, `eza`, `jq`, `htop`, `direnv`, `lazygit`, `thefuck`
- 2025/2026 productivity tools: `bottom`, `tealdeer`, `delta`, `tokei`, `zellij`, `gitui`, `procs`, `ouch`
- Dynamic package checking — only installs missing packages
- Safe `.zshrc` handling with automatic backup before modifications
- Docker-based test suite covering all three installation methods
- `CLAUDE.md` for AI-assisted development context

### Changed
- N/A (initial release)

### Fixed
- N/A (initial release)

---

## How to Read This File

- **Added** — new features or tools
- **Changed** — changes to existing functionality
- **Deprecated** — features that will be removed in a future release
- **Removed** — features removed in this release
- **Fixed** — bug fixes
- **Security** — security-related fixes

[Unreleased]: https://github.com/satyamsoni2211/dev-accelerator/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/satyamsoni2211/dev-accelerator/releases/tag/v1.0.0
# Contributing to dev-accelerator

Thank you for your interest in contributing! This project welcomes improvements, bug fixes, new tool suggestions, and documentation enhancements.

## Table of Contents

- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Types of Contributions](#types-of-contributions)
- [Development Setup](#development-setup)
- [Testing](#testing)
- [Pull Request Guidelines](#pull-request-guidelines)
- [Code Style](#code-style)

---

## Getting Started

1. **Fork** the repository on GitHub.
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dev-accelerator.git
   cd dev-accelerator
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

---

## How to Contribute

### Reporting Bugs

Open a [GitHub Issue](https://github.com/satyamsoni2211/dev-accelerator/issues) and include:
- macOS version and architecture (Apple Silicon / Intel)
- Shell version (`zsh --version`)
- The exact command you ran
- Full error output

### Suggesting New Tools

Before suggesting a tool, check that it:
- Is actively maintained
- Improves developer productivity
- Works well on macOS
- Is installable via Homebrew or Nix

Open an issue with the label `tool-suggestion` and describe the tool and its use case.

### Improving Documentation

Typo fixes, clearer instructions, and better examples are always welcome — feel free to open a PR directly for doc changes without an issue.

---

## Types of Contributions

| Type | Description |
|---|---|
| 🐛 Bug fix | Fix a broken install step, script error, or config issue |
| ✨ New tool | Add a new CLI tool to the Brewfile or Nix config |
| 📖 Docs | Improve README, add examples, fix typos |
| 🧪 Tests | Improve Docker-based test coverage |
| 🎨 Config | Improve Ghostty, Zsh, Starship, or tmux defaults |
| ♻️ Refactor | Clean up shell scripts without changing behaviour |

---

## Development Setup

You only need a macOS machine to work on most parts of this repo. For testing installation scripts in isolation, Docker is used.

```bash
# Clone the repo
git clone https://github.com/satyamsoni2211/dev-accelerator.git
cd dev-accelerator

# Make scripts executable
chmod +x install.sh setup.sh

# For Docker-based testing
cd tests
./run-tests.sh all
```

---

## Testing

All three installation methods have Docker-based tests. Please run the relevant tests before submitting a PR:

```bash
cd tests

# Run all tests
./run-tests.sh all

# Run a specific test
./run-tests.sh homebrew   # Homebrew + setup.sh path
./run-tests.sh script     # Shell script path
./run-tests.sh nix        # Nix flakes path
```

If you are adding a new tool, ensure it is covered by the existing test suite or add a test for it.

---

## Pull Request Guidelines

- Keep PRs focused — one feature or fix per PR.
- Write a clear PR title and description explaining *what* and *why*.
- Reference any related issues with `Fixes #123` or `Closes #123`.
- Make sure all tests pass before requesting review.
- If you are changing `install.sh` or `setup.sh`, test locally on macOS before opening the PR.

---

## Code Style

### Shell Scripts

- Use `#!/usr/bin/env bash` as the shebang.
- Use `set -euo pipefail` at the top of scripts for safety.
- Prefer `[[ ]]` over `[ ]` for conditionals.
- Add comments for non-obvious logic.
- Use lowercase variable names for locals; UPPERCASE for exported/env vars.

### Nix

- Follow the existing formatting in `flake.nix` and `home/configuration.nix`.
- Run `nixfmt` if available before committing Nix changes.

---

## Questions?

Open an issue or start a [GitHub Discussion](https://github.com/satyamsoni2211/dev-accelerator/discussions) — happy to help!
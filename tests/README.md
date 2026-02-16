# Ghostty Setup Tests

This directory contains Docker-based tests for validating all three installation methods.
Supports both Docker and Podman.

## Test Structure

```
tests/
├── docker/
│   ├── Dockerfile.nix          # Nix flakes test image
│   ├── Dockerfile.homebrew    # Homebrew test image
│   ├── Dockerfile.script      # Shell script test image
│   └── docker-compose.yml    # Run all tests together
├── run-tests.sh              # Auto-detects Docker or Podman
├── run-tests-docker.sh       # Force Docker
├── run-tests-podman.sh       # Force Podman
└── README.md                 # This file
```

## Running Tests

### Auto-detect (Docker or Podman)
```bash
cd tests
./run-tests.sh all
```

### Force specific runtime
```bash
./run-tests-docker.sh all    # Use Docker only
./run-tests-podman.sh all   # Use Podman only
```

### Run specific test
```bash
./run-tests.sh nix          # Test Nix flake setup
./run-tests.sh homebrew     # Test Homebrew setup
./run-tests.sh script       # Test shell script setup
```

### Using Docker Compose
```bash
cd tests/docker
docker-compose up --build
```

Or with Podman:
```bash
cd tests/docker
podman-compose up --build
```

## Container Runtime Detection

The test runner automatically detects available container runtime:
1. Checks for `podman` first
2. Falls back to `docker` if Podman not found
3. Skips container tests if neither is available

## Test Details

### Nix Test
- Uses `nixos/nix` base image
- Validates flake.nix syntax
- Attempts flake metadata evaluation
- Tests Home Manager availability

### Homebrew Test
- Uses `debian:bookworm-slim` base image
- Installs Homebrew in Linuxbrew mode
- Validates Brewfile
- Checks tool availability

### Shell Script Test
- Uses `debian:bookworm-slim` base image
- Tests script syntax (bash/zsh)
- Validates config file generation
- Tests script execution

## Requirements

- Docker OR Podman installed
- For local syntax testing: Nix (optional)
- For local Homebrew testing: Homebrew (optional)

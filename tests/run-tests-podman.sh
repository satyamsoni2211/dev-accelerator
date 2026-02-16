#!/bin/bash

# Run tests using Podman exclusively
# Usage: ./run-tests-podman.sh [nix|homebrew|script|all]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if podman is available
if ! command -v podman &> /dev/null; then
    echo "Error: Podman is not installed"
    echo "Install Podman: https://podman.io/getting-started/installation"
    exit 1
fi

# Run the main test script with podman override
CONTAINER_RUNTIME=podman "$SCRIPT_DIR/run-tests.sh" "$@"

#!/bin/bash

# Run tests using Docker exclusively
# Usage: ./run-tests-docker.sh [nix|homebrew|script|all]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed"
    echo "Install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Run the main test script with docker override
CONTAINER_RUNTIME=docker "$SCRIPT_DIR/run-tests.sh" "$@"

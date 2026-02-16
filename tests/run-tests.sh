#!/bin/bash

# Ghostty Terminal Setup - Test Runner
# Runs tests for all three installation methods
# Supports both Docker and Podman
# Usage: ./run-tests.sh [nix|homebrew|script|all]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$SCRIPT_DIR/docker"

# Detect container runtime (docker or podman)
detect_container_runtime() {
    if command -v podman &> /dev/null; then
        echo "podman"
    elif command -v docker &> /dev/null; then
        echo "docker"
    else
        echo ""
    fi
}

CONTAINER_RUNTIME=$(detect_container_runtime)

# Parse arguments
TEST_TYPE="${1:-all}"

echo -e "${BLUE}=== Ghostty Setup Test Runner ===${NC}"
echo ""

# Check container runtime
if [ -z "$CONTAINER_RUNTIME" ]; then
    echo -e "${YELLOW}Warning: Neither Docker nor Podman is available${NC}"
    echo "Container-based tests will be skipped"
    echo ""
else
    echo -e "${CYAN}Using container runtime: ${CONTAINER_RUNTIME}${NC}"
    echo ""
fi

# Function to run a test
run_test() {
    local test_name="$1"
    local dockerfile="$2"

    echo -e "${CYAN}Running ${test_name} test...${NC}"

    if [ -z "$CONTAINER_RUNTIME" ]; then
        echo -e "${YELLOW}Skipping ${test_name} - no container runtime${NC}"
        return 0
    fi

    # Build the image
    $CONTAINER_RUNTIME build -f "$DOCKER_DIR/$dockerfile" -t "ghostty-test-$test_name" "$SCRIPT_DIR/../" 2>&1

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ ${test_name} test passed${NC}"
    else
        echo -e "${RED}✗ ${test_name} test failed${NC}"
        return 1
    fi
}

# Validate Nix flake syntax (no container needed)
test_nix_syntax() {
    echo -e "${CYAN}Testing Nix flake syntax...${NC}"

    cd "$SCRIPT_DIR/../"

    # Check if nix is available locally
    if command -v nix &> /dev/null; then
        nix-instantiate --parse flake.nix > /dev/null && echo "flake.nix: OK"
        nix-instantiate --parse home/configuration.nix > /dev/null && echo "home/configuration.nix: OK"
        nix-instantiate --parse ghostty/ghostty.nix > /dev/null && echo "ghostty/ghostty.nix: OK"
        nix-instantiate --parse zsh/zshrc.nix > /dev/null && echo "zsh/zshrc.nix: OK"
        echo -e "${GREEN}✓ Nix syntax validation passed${NC}"
    else
        echo -e "${YELLOW}Nix not installed locally - skipping syntax check${NC}"
        echo "(${CONTAINER_RUNTIME:+$CONTAINER_RUNTIME test will still run if available})"
    fi
}

# Test Nix setup
test_nix() {
    echo -e "\n${YELLOW}--- Testing Nix Flakes Setup ---${NC}"
    test_nix_syntax
    run_test "nix" "Dockerfile.nix"
}

# Test Homebrew setup
test_homebrew() {
    echo -e "\n${YELLOW}--- Testing Homebrew Setup ---${NC}"

    # Always try local brew test if available
    if command -v brew &> /dev/null; then
        echo -e "${CYAN}Testing Brewfile locally...${NC}"
        cd "$SCRIPT_DIR/../"
        brew bundle check 2>&1 || echo "Some packages missing (expected)"
    fi

    run_test "homebrew" "Dockerfile.homebrew"
}

# Test shell script setup
test_script() {
    echo -e "\n${YELLOW}--- Testing Shell Script Setup ---${NC}"

    cd "$SCRIPT_DIR/../"

    # Test shell script syntax
    echo -e "${CYAN}Testing script syntax...${NC}"
    bash -n setup.sh && echo "Bash syntax: OK"
    # Test with zsh if available
    if command -v zsh &> /dev/null; then
        zsh -n setup.sh 2>&1 && echo "Zsh syntax: OK" || true
    fi
    file setup.sh

    run_test "script" "Dockerfile.script"
}

# Main
case "$TEST_TYPE" in
    nix)
        test_nix
        ;;
    homebrew)
        test_homebrew
        ;;
    script)
        test_script
        ;;
    all)
        test_nix
        test_homebrew
        test_script
        ;;
    *)
        echo "Usage: $0 [nix|homebrew|script|all]"
        exit 1
        ;;
esac

echo -e "\n${GREEN}=== Tests Complete ===${NC}"

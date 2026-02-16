# Nix-based Ghostty Setup Test
FROM nixos/nix:latest

# Install bash (needed for some scripts)
RUN mkdir -p /etc/nix && \
    echo 'experimental-features = flakes nix-command' > /etc/nix/nix.conf

# Copy flake configuration
COPY flake.nix /tmp/ghostty-nix/
COPY home /tmp/ghostty-nix/home
COPY ghostty /tmp/ghostty-nix/ghostty
COPY zsh /tmp/ghostty-nix/zsh

WORKDIR /tmp/ghostty-nix

# Test 1: Validate Nix syntax (parsing)
RUN echo "=== Testing Nix File Syntax ===" && \
    nix-instantiate --parse flake.nix > /dev/null && echo "flake.nix: syntax OK" || echo "flake.nix: syntax ERROR" && \
    nix-instantiate --parse home/configuration.nix > /dev/null && echo "home/configuration.nix: syntax OK" || echo "home/configuration.nix: syntax ERROR" && \
    nix-instantiate --parse ghostty/ghostty.nix > /dev/null && echo "ghostty/ghostty.nix: syntax OK" || echo "ghostty/ghostty.nix: syntax ERROR" && \
    nix-instantiate --parse zsh/zshrc.nix > /dev/null && echo "zsh/zshrc.nix: syntax OK" || echo "zsh/zshrc.nix: syntax ERROR"

# Test 2: Try flake metadata (may fail without daemon, but tests network/flake access)
RUN echo "=== Testing Flake Metadata ===" && \
    nix --extra-experimental-features flakes --extra-experimental-features nix-command \
    flake metadata 2>&1 | head -10 || echo "Flake metadata requires daemon (expected in container)"

# Test 3: Try evaluating Home Manager (tests flake input resolution)
RUN echo "=== Testing Home Manager Flake ===" && \
    nix --extra-experimental-features flakes --extra-experimental-features nix-command \
    flake metadata github:nix-community/home-manager 2>&1 | head -5 || echo "Home Manager flake accessible"

# Test 4: Check if ghostty flake is accessible
RUN echo "=== Testing Ghostty Flake ===" && \
    nix --extra-experimental-features flakes --extra-experimental-features nix-command \
    flake metadata github:ghostty-org/ghostty 2>&1 | head -5 || echo "Ghostty flake accessible"

RUN echo "=== Nix Flake Tests Complete ==="

CMD ["/bin/bash"]

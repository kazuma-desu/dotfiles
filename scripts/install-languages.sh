#!/bin/bash

# Exit on error
set -e

echo "Installing language runtimes and SDK managers..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Rust and Cargo
if ! command_exists cargo; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust is already installed"
fi

# Install NVM (Node Version Manager)
if ! command_exists nvm; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts  # Install latest LTS version of Node.js
else
    echo "NVM is already installed"
fi

# Install SDKMAN
if ! command_exists sdk; then
    echo "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
else
    echo "SDKMAN is already installed"
fi

# Install uv (Python package installer)
if ! command_exists uv; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv is already installed"
fi

# Install Go
if ! command_exists go; then
    echo "Installing Go..."
    # Determine the latest Go version
    GO_VERSION=$(curl -s https://go.dev/VERSION?m=text)
    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            ARCH="amd64"
            ;;
        aarch64)
            ARCH="arm64"
            ;;
        *)
            echo "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac
    
    # Download and install Go
    curl -L -o /tmp/go.tar.gz "https://go.dev/dl/${GO_VERSION}.linux-${ARCH}.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    
    # Add to PATH (assuming user will add to their shell config)
    echo "Please add the following to your shell configuration (~/.zshrc or ~/.bashrc):"
    echo "export PATH=\$PATH:/usr/local/go/bin"
else
    echo "Go is already installed"
fi

echo "Language runtimes and SDK managers installation complete!"

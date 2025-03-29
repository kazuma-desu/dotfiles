#!/bin/bash

# Exit on error
set -e

echo "Installing required tools and dependencies..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install basic dependencies
if command_exists apt; then
    sudo apt update
    sudo apt install -y git curl wget zsh fzf ripgrep
elif command_exists pacman; then
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm git curl wget zsh fzf ripgrep
fi


# Install Atuin
if ! command_exists atuin; then
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi

# Install Zoxide
if ! command_exists zoxide; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Install Starship
if ! command_exists starship; then
    curl -sS https://starship.rs/install.sh | sh
fi

# Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts  # Install latest LTS version of Node.js
fi

# Install Rust and Cargo
if ! command_exists cargo; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Install SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Install Zellij
if ! command_exists zellij; then
    cargo install zellij
fi

# Make the script executable
chmod +x ~/.zshrc

echo "Installation complete! Please restart your shell or run 'source ~/.zshrc'"

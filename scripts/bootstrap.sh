#!/bin/bash

# Exit on error
set -e

echo "Installing required tools and dependencies..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Rust and Cargo first (needed for many other tools)
if ! command_exists cargo; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust is already installed"
fi

# Array of packages to install
PACKAGES=("git" "curl" "wget" "zsh" "fzf")

# Function to install packages based on available package manager
install_packages() {
    local packages=("$@")
    
    # Check for various package managers and install accordingly
    if command_exists apt; then
        echo "Using apt package manager"
        sudo apt update
        sudo apt install -y "${packages[@]}"
    elif command_exists pacman; then
        echo "Using pacman package manager"
        sudo pacman -Syu --noconfirm
        sudo pacman -S --noconfirm "${packages[@]}"
    elif command_exists dnf; then
        echo "Using dnf package manager"
        sudo dnf install -y "${packages[@]}"
    elif command_exists yum; then
        echo "Using yum package manager"
        sudo yum install -y "${packages[@]}"
    elif command_exists zypper; then
        echo "Using zypper package manager"
        sudo zypper install -y "${packages[@]}"
    elif command_exists emerge; then
        echo "Using portage package manager"
        sudo emerge --ask=n "${packages[@]}"
    else
        echo "No supported package manager found. Please install packages manually:"
        printf '%s\n' "${packages[@]}"
        exit 1
    fi
}

# Check and install system packages
echo "Checking system packages..."
PACKAGES_TO_INSTALL=()
for package in "${PACKAGES[@]}"; do
    if ! command_exists "$package"; then
        echo "$package is not installed"
        PACKAGES_TO_INSTALL+=("$package")
    else
        echo "$package is already installed"
    fi
done

if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo "Installing missing packages: ${PACKAGES_TO_INSTALL[*]}"
    install_packages "${PACKAGES_TO_INSTALL[@]}"
else
    echo "All system packages are already installed"
fi

# Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts  # Install latest LTS version of Node.js
else
    echo "NVM is already installed"
fi

# Install SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
    echo "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
else
    echo "SDKMAN is already installed"
fi

# Array of Cargo packages to install (including zoxide, atuin, starship, and zellij)
CARGO_PACKAGES=("zoxide" "atuin" "starship" "zellij" "eza" "ripgrep")

# Check and install Cargo packages
echo "Checking Cargo packages..."
CARGO_PACKAGES_TO_INSTALL=()
for package in "${CARGO_PACKAGES[@]}"; do
    if ! command_exists "$package"; then
        echo "$package is not installed"
        CARGO_PACKAGES_TO_INSTALL+=("$package")
    else
        echo "$package is already installed"
    fi
done

if [ ${#CARGO_PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo "Installing missing Cargo packages: ${CARGO_PACKAGES_TO_INSTALL[*]}"
    cargo install "${CARGO_PACKAGES_TO_INSTALL[@]}" --locked
else
    echo "All Cargo packages are already installed"
fi

# Make the script executable
chsh -s "$(which zsh)"
chmod +x ~/.zshrc

echo "Installation complete! Please restart your shell or run 'source ~/.zshrc'"

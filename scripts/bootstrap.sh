#!/bin/bash

# Exit on error
set -e

echo "Installing required tools and dependencies..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS and package manager
detect_os() {
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
        PM=""

        # Determine package manager based on OS
        case $ID in
            ubuntu|debian|pop|kali|raspbian)
                PM="apt"
                ;;
            fedora|rhel|centos)
                if command_exists dnf; then
                    PM="dnf"
                else
                    PM="yum"
                fi
                ;;
            arch|manjaro|endeavouros|garuda)
                PM="pacman"
                ;;
            opensuse|sles)
                PM="zypper"
                ;;
            alpine)
                PM="apk"
                ;;
            gentoo)
                PM="emerge"
                ;;
            *)
                # Fallback to checking for package managers directly
                if command_exists apt; then
                    PM="apt"
                elif command_exists dnf; then
                    PM="dnf"
                elif command_exists yum; then
                    PM="yum"
                elif command_exists pacman; then
                    PM="pacman"
                elif command_exists zypper; then
                    PM="zypper"
                elif command_exists apk; then
                    PM="apk"
                elif command_exists emerge; then
                    PM="emerge"
                else
                    echo "Cannot determine package manager for your system"
                    exit 1
                fi
                ;;
        esac
    else
        # Fallback to checking for package managers directly
        if command_exists apt; then
            PM="apt"
        elif command_exists dnf; then
            PM="dnf"
        elif command_exists yum; then
            PM="yum"
        elif command_exists pacman; then
            PM="pacman"
        elif command_exists zypper; then
            PM="zypper"
        elif command_exists apk; then
            PM="apk"
        elif command_exists emerge; then
            PM="emerge"
        else
            echo "Cannot determine package manager for your system"
            exit 1
        fi
    fi

    echo "Detected OS: $OS"
    echo "Using package manager: $PM"
}

# Run the language and SDK managers installation script first
if [ -f "./install-languages.sh" ]; then
    echo "Running language and SDK managers installation script..."
    bash ./install-languages.sh
else
    echo "Language installation script not found. Please run it separately."
    exit 1
fi

# Detect OS and package manager
detect_os

# Array of packages to install
PACKAGES=("git" "curl" "wget" "zsh" "fzf")

# Function to install packages based on detected package manager
install_packages() {
    local packages=("$@")
    
    case $PM in
        apt)
            echo "Using apt package manager"
            sudo apt update
            sudo apt install -y "${packages[@]}"
            ;;
        pacman)
            echo "Using pacman package manager"
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm "${packages[@]}"
            ;;
        dnf)
            echo "Using dnf package manager"
            sudo dnf install -y "${packages[@]}"
            ;;
        yum)
            echo "Using yum package manager"
            sudo yum install -y "${packages[@]}"
            ;;
        zypper)
            echo "Using zypper package manager"
            sudo zypper install -y "${packages[@]}"
            ;;
        apk)
            echo "Using apk package manager"
            sudo apk add "${packages[@]}"
            ;;
        emerge)
            echo "Using portage package manager"
            sudo emerge --ask=n "${packages[@]}"
            ;;
        *)
            echo "Unsupported package manager: $PM"
            echo "Please install packages manually:"
            printf '%s\n' "${packages[@]}"
            exit 1
            ;;
    esac
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
chmod +x ~/.zshrc

echo "Installation complete! Please restart your shell or run 'source ~/.zshrc'"

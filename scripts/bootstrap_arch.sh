#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

print_header() {
    gum style --foreground 212 --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "1 4" "$1"
}

print_step() {
    gum style --foreground 99 --bold "$1"
}

print_info() {
    gum style --foreground 240 "  $1"
}

print_success() {
    gum style --foreground 212 "✓ $1"
}

print_warning() {
    gum style --foreground 214 "⚠ $1"
}

install_packages() {
    local packages=("$@")

    if [ ${#packages[@]} -eq 0 ]; then
        print_info "No packages to install"
        return 0
    fi

    print_info "Installing: ${packages[*]}"
    gum spin --spinner dot --title "Installing packages..." -- \
        sudo pacman -Syu --noconfirm --needed
    gum spin --spinner dot --title "Installing ${packages[*]}..." -- \
        sudo pacman -S --noconfirm --needed "${packages[@]}"
}

if [ -f "$SCRIPT_DIR/tools/install_gum.sh" ]; then
    bash "$SCRIPT_DIR/tools/install_gum.sh"
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi
fi
echo ""

print_header "Arch Linux Dotfiles Bootstrap"
echo ""

PACKAGES=("git" "curl" "wget" "zsh" "stow")

print_step "Step 1: Checking system packages..."
PACKAGES_TO_INSTALL=()
for package in "${PACKAGES[@]}"; do
    if ! command_exists "$package"; then
        print_info "$package - not installed"
        PACKAGES_TO_INSTALL+=("$package")
    else
        print_success "$package - already installed"
    fi
done

if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    install_packages "${PACKAGES_TO_INSTALL[@]}"
    print_success "Packages installed"
else
    print_success "All system packages are already installed"
fi
echo ""

print_step "Step 2: Installing bin (binary manager)..."
if [ -f "$SCRIPT_DIR/tools/install_bin.sh" ]; then
    bash "$SCRIPT_DIR/tools/install_bin.sh"
else
    print_warning "bin installation script not found"
fi
echo ""

print_step "Step 3: Installing language runtimes and SDK managers..."
if [ -f "$SCRIPT_DIR/languages/install_languages.sh" ]; then
    bash "$SCRIPT_DIR/languages/install_languages.sh"
else
    print_warning "Language installation script not found"
fi
echo ""

print_step "Step 4: Installing CLI tools..."
if [ -f "$SCRIPT_DIR/tools/install_cli_tools.sh" ]; then
    bash "$SCRIPT_DIR/tools/install_cli_tools.sh"
else
    print_warning "CLI tools installation script not found"
fi
echo ""

print_header "Bootstrap Complete!"
echo ""
gum style --foreground 99 "Next steps:"
gum style --foreground 240 "  1. Link your dotfiles: cd ~/.dotfiles && stow ."
gum style --foreground 240 "  2. Restart your shell or run: source ~/.zshrc"
gum style --foreground 240 "  3. If you installed new languages, you may need to:"
gum style --foreground 240 "     - Rust: source ~/.cargo/env"
gum style --foreground 240 "     - Node.js: restart your shell (fnm loads automatically via .zshrc)"
gum style --foreground 240 "     - SDKMAN: source ~/.sdkman/bin/sdkman-init.sh"
echo ""

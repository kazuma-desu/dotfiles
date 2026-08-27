#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Degrade gracefully when gum is not installed
if ! command_exists gum; then
    gum() {
        local cmd="$1"
        shift
        case "$cmd" in
            style)
                while [ $# -gt 0 ]; do
                    case "$1" in
                        --*=*) shift ;;
                        --bold|--italic|--faint|--underline|--strikethrough) shift ;;
                        --*) if [ $# -ge 2 ]; then shift 2; else shift; fi ;;
                        *) break ;;
                    esac
                done
                printf '%s\n' "$*"
                ;;
            *) return 1 ;;
        esac
    }
fi

BIN_CONFIG="$DOTFILES_DIR/.config/bin/config.json"
export BIN_CONF="$BIN_CONFIG"

if ! command_exists bin; then
    gum style --foreground 214 "⚠ bin is not installed. Please run install_bin.sh first."
    exit 1
fi

gum style --foreground 99 --bold "Installing CLI tools via bin..."
echo ""

declare -A TOOLS=(
    ["ripgrep"]="BurntSushi/ripgrep"
    ["fzf"]="junegunn/fzf"
    ["zellij"]="zellij-org/zellij"
    ["zoxide"]="ajeetdsouza/zoxide"
    ["eza"]="eza-community/eza"
    ["atuin"]="atuinsh/atuin"
    ["starship"]="starship/starship"
)

for tool in "${!TOOLS[@]}"; do
    repo="${TOOLS[$tool]}"

    if command_exists "$tool"; then
        gum style --foreground 240 "✓ $tool is already installed"
    else
        gum style --foreground 99 "Installing $tool from $repo..."
        bin install "github.com/$repo"
        echo ""

        if command_exists "$tool"; then
            gum style --foreground 212 "✓ $tool installed successfully"
        else
            gum style --foreground 214 "⚠ $tool installation may have failed"
        fi
    fi
done

echo ""
gum style --foreground 212 "✓ CLI tools installation complete!"

#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Degrade gracefully when gum is not installed
if command_exists gum; then
    HAVE_GUM=1
else
    HAVE_GUM=0
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

install_lang() {
    local lang=$1
    local lang_lower
    lang_lower=$(echo "$lang" | tr '[:upper:]' '[:lower:]')
    local script_path="$SCRIPT_DIR/install_$lang_lower.sh"

    if [ ! -f "$script_path" ]; then
        gum style --foreground 214 "⚠ Installation script for $lang not found at $script_path"
        return 1
    fi

    echo "----------------------------------------"
    gum style --foreground 99 --bold "Processing $lang..."
    echo "----------------------------------------"

    bash "$script_path"
}

gum style --foreground 212 --bold "Language Runtimes & SDK Managers"
echo ""

failed=()

if [ "$HAVE_GUM" -eq 1 ] && [ -z "${DOTFILES_NONINTERACTIVE:-}" ]; then
    langs=$(gum choose --no-limit Rust Golang Python Node Java \
        --header "Choose languages to install (Space to select, Enter to confirm):" \
        --cursor.foreground="212" \
        --selected.foreground="212" || echo "")

    if [ -z "$langs" ]; then
        gum style --foreground 214 "No languages selected. Skipping language installation."
        exit 0
    fi

    echo ""
    for lang in $langs; do
        if ! install_lang "$lang"; then
            failed+=("$lang")
        fi
        echo ""
    done
else
    gum style --foreground 99 "Running in non-interactive mode. Installing all languages..."
    echo ""

    for lang in Rust Golang Python Node Java; do
        if ! install_lang "$lang"; then
            failed+=("$lang")
        fi
        echo ""
    done
fi

if [ ${#failed[@]} -gt 0 ]; then
    gum style --foreground 214 "⚠ Failed to install: ${failed[*]}"
    exit 1
fi

gum style --foreground 212 "✓ Language installation complete!"

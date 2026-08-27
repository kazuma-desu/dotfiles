#!/usr/bin/env bash
# Shared helpers for dotfiles install scripts. Source, do not execute.
# shellcheck disable=SC2034  # vars are consumed by the scripts that source this file

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Release asset arch naming differs per project:
#   ARCH_GO  (amd64/arm64)    - Go, bin
#   ARCH_GNU (x86_64/arm64)   - gum
case "$(uname -m)" in
    x86_64)        ARCH_GO="amd64"; ARCH_GNU="x86_64" ;;
    aarch64|arm64) ARCH_GO="arm64"; ARCH_GNU="arm64" ;;
    *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

verify_sha256() {
    local file="$1" expected="$2" actual
    actual=$(sha256sum "$file" | awk '{print $1}')
    if [ "$actual" != "$expected" ]; then
        echo "Checksum mismatch for $(basename "$file")" >&2
        echo "  expected: $expected" >&2
        echo "  actual:   $actual" >&2
        return 1
    fi
}

# Degrade gracefully when gum is not installed
HAVE_GUM=0
if command_exists gum; then
    HAVE_GUM=1
else
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
            spin)
                while [ $# -gt 0 ] && [ "$1" != "--" ]; do shift; done
                [ $# -gt 0 ] && shift
                "$@"
                ;;
            *) return 1 ;;
        esac
    }
fi

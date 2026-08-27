
# =============================================================================
#                               Path Configuration
# =============================================================================

# Deduplicate PATH entries (zsh ties the path array to PATH)
typeset -U path PATH

# Core paths
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/nvim/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/src/flutter/bin:$PATH"

# Tool-specific paths
export PATH="$HOME/.linkerd2/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

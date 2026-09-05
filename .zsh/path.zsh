
# =============================================================================
#                               Path Configuration
# =============================================================================

# Deduplicate PATH entries globally (this file is sourced from a function)
typeset -gU path PATH

# Core paths
export PATH="/opt/nvim/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/src/flutter/bin:$PATH"

# Tool-specific paths
export PATH="$HOME/.linkerd2/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Superfile lastdir shell integration
spf() {
    local os
    os=$(uname -s)

    if [[ "$os" == "Linux" ]]; then
        export SPF_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
    fi

    command spf "$@"

    if [[ -n "${SPF_LAST_DIR:-}" && -f "$SPF_LAST_DIR" ]]; then
        . "$SPF_LAST_DIR"
        rm -f -- "$SPF_LAST_DIR"
    fi
}

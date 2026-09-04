# Essential user-local executables
typeset -U path PATH
path=("$HOME/.local/bin" $path)
export PATH

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

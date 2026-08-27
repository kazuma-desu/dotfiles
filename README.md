# dotfiles

My dotfile configuration, managed with GNU Stow, for a consistent setup across machines.

## layout

```
.zshrc .zshenv .zsh/     zsh configuration (modular: path, plugins, options, completion, aliases, functions)
.config/                 app configs (nvim, ghostty, zellij, starship)
scripts/                 install scripts (Arch Linux)
  bootstrap_arch.sh      entry point: packages, bin, languages, CLI tools
  lib/common.sh          shared helpers (arch detection, gum fallback, checksum verify)
  languages/             per-language runtime installers + dispatcher
  tools/                 gum, bin (binary manager), CLI tool installers
```

## fresh machine setup (arch linux)

```sh
git clone https://github.com/kazuma-desu/dotfiles.git ~/.dotfiles
~/.dotfiles/scripts/bootstrap_arch.sh
cd ~/.dotfiles && stow .
```

`bootstrap_arch.sh` installs system packages (pacman), gum, the bin binary manager,
language runtimes, and CLI tools. Linking the dotfiles with `stow .` is a separate
manual step so you stay in control of what gets linked.

## linking configs

```sh
cd ~/.dotfiles
stow .            # create symlinks
stow -D .         # remove symlinks
stow -R .         # relink
```

## install scripts

Run the full bootstrap, or individual pieces:

```sh
scripts/languages/install_languages.sh   # interactive picker (gum) or all languages
scripts/languages/install_rust.sh        # rustup
scripts/languages/install_node.sh        # fnm + Node LTS
scripts/languages/install_golang.sh      # Go to ~/.local/go
scripts/languages/install_python.sh      # uv
scripts/languages/install_java.sh        # SDKMAN + Temurin
scripts/tools/install_cli_tools.sh       # ripgrep, fzf, zellij, zoxide, eza, atuin, starship via bin
```

### environment knobs

| Variable | Effect |
|---|---|
| `DOTFILES_NONINTERACTIVE=1` | language dispatcher installs everything without prompting |
| `JAVA_VERSION=21.0.5-tem` | override the SDKMAN Java candidate |
| `BIN_CONF=<path>` | point bin at a different config (default: `.config/bin/config.json`) |

## notes

- Prebuilt binaries (eza, atuin, zoxide, ...) are managed by `bin` into `~/.local/bin`;
  its state file `.config/bin/config.json` is machine-local and gitignored.
- Node is managed by fnm (`.zshrc` runs `fnm env --use-on-cd`).
- gum/bin/Go downloads are SHA256-verified during install.

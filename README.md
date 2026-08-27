dotfiles
This repo contains my dotfile configuration, allowing for a consistent computing experience across multiple machines.

I manage the various configuration files in this repo using GNU Stow. This allows me to set up symlinks for all of my dotfiles using a single command:

```
stow .
```

bootstrap (arch linux)

To set up a fresh machine, run the bootstrap script:

```
./scripts/bootstrap_arch.sh
```

It installs gum, system packages via pacman, the bin binary manager (scripts/tools/), language runtimes (scripts/languages/), and CLI tools via bin.

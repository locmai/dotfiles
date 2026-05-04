## Dotfiles

Auto-synchronized from <https://github.com/locmai/macos-setup>.

macOS configs for terminals, editors, window manager, and shell. Files live under `~/.config/` plus top-level `~/.zshrc`, `~/.aliases`.

## Layout

`~/.config/`:

- `nvim/` - Neovim with LazyVim (`init.lua`, `lazy-lock.json`, `lua/{config,plugins}`)
- `aerospace/` - AeroSpace tiling WM (`aerospace.toml`)
- `kitty/` - Kitty terminal (`kitty.conf`, `kitty.d/`)
- `nix/`, `nixpkgs/` - Nix config
- `tfenv/` - terraform version manager
- `neofetch/` - neofetch config

Top-level:

- `~/.zshrc` - zinit, Powerlevel10k, fzf, kubectl-aliases
- `~/.aliases` - general + git shortcuts (`g`, `gs`, `gd`, `gco`, `gl`, ...)
- `~/.p10k.zsh` - Powerlevel10k theme

# Dotfiles

Declarative configuration for my machines, built with Nix flakes, nix-darwin,
NixOS, and home-manager. This repository replaces the older setup where `$HOME`
itself was a Git repository.

Hosts:

| Host            | Platform       | User     | Machine                     |
| --------------- | -------------- | -------- | --------------------------- |
| `AM-H6MRWRT99L` | `aarch64-darwin` | `lmai`   | Work MacBook Pro            |
| `nixos`         | `x86_64-linux`   | `locmai` | Personal ThinkPad X1 Carbon |

No credentials, tokens, or hashed passwords are stored here. Work-only aliases
live in `~/.aliases_axon`, which is sourced when present but never tracked.

## Layout

- `flake.nix`: entrypoint, one output per host
- `base/`: shared baseline for every host
- `hosts/`: one file per machine, each importing the modules it needs
  - `hosts/hardware/`: generated hardware configuration for NixOS hosts
- `modules/`: composable modules that hosts mix and match
  - `agents`: Claude Code and Pi configuration, linked from `~/Workspaces/agent-setup`
  - `cli`: shell tools, language servers, Kubernetes and IaC tooling
  - `dotfiles`: the actual config files under `modules/dotfiles/home`
  - `gui`: desktop applications, fonts, and system defaults
  - `hyprland`: Wayland session for the NixOS host
  - `personal`: personal-machine applications
  - `work`: work-specific packages and casks
- `pkgs/`: custom packages, exposed as `pkgs.unofficial.<name>`
- `scripts/rebuild.py`: platform wrapper around `nixos-rebuild` and `darwin-rebuild`

Modules follow the same shape: `default.nix` as the entrypoint, with
`darwin.nix` and `linux.nix` holding platform-specific parts.

## Dotfiles

Files under `modules/dotfiles/home` are mapped to the same path under `$HOME`.
They are symlinked to this checkout rather than copied into the Nix store, so
editing a config applies immediately without a rebuild. The checkout is
expected at `~/Workspaces/dotfiles`; override `dotfilesRoot` in a host file if
it lives elsewhere.

Adding a new dotfile only requires dropping it in the right place under
`modules/dotfiles/home` and rebuilding once so the symlink is created.

## Usage

Diff the pending configuration against the running system, then apply it:

```sh
make
```

The host defaults to `hostname -s`. Override it to build another machine:

```sh
make build host=nixos
```

Other targets:

```sh
make switch    # apply the configuration
make diff      # show what would change
make update    # update flake.lock
make fmt       # format all Nix files
make check     # nix flake check
make clean     # collect garbage older than 30 days
make optimise  # deduplicate the Nix store
```

## Installation

### macOS

1. Allow Full Disk Access for the terminal in
   `Settings > Privacy & Security > Full Disk Access`
2. Clone this repository to `~/Workspaces/dotfiles`
3. Run `make switch`, which installs Nix and Homebrew if they are missing
4. Reboot

### NixOS

Boot the installer ISO, partition the disk, and generate the hardware
configuration:

```sh
nixos-generate-config --root /mnt
```

Copy the result into `hosts/hardware/nixos.nix`, then install:

```sh
nixos-install --flake .#nixos
```

Set the account password from the installer or a root shell with
`passwd locmai`, since no credentials are committed here.

### Migrating from the `$HOME` Git repository

The previous setup tracked configuration files directly in `$HOME`. After the
first `make switch`, home-manager owns those paths, so remove the old checkout:

```sh
rm -rf ~/.git
```

Any file that home-manager had to move aside is kept with an `.hm-backup`
suffix.

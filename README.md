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
- `base/`: shared baseline for every host, plus the `primaryUser` and
  `dotfilesRoot` options
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
- `.github/workflows/test.yaml`: builds every host on Linux and macOS runners

Modules follow the same shape: `default.nix` as the entrypoint, with
`darwin.nix` and `linux.nix` holding platform-specific parts. `base/` picks the
platform file from `platform.parsed.kernel.name`.

## Inputs and overlays

The flake tracks the `26.05` releases of nixpkgs, nix-darwin, and
home-manager, with `nixpkgs-unstable` alongside them. `nixos-hardware` supplies
the ThinkPad profile, and [`sofka`](https://github.com/nklmilojevic/sofka)
provides its overlay.

Two overlays are applied to every host:

- `pkgs.unstable.<name>`: the same package from `nixpkgs-unstable`
- `pkgs.unofficial.<name>`: packages defined in `pkgs/`

## Host options

Each host file sets `primaryUser.username`; `primaryUser.fullName` defaults to
`Loc Mai` and `primaryUser.authorizedKeys` to an empty list. `dotfilesRoot` is
the checkout path relative to `$HOME` and is only used when `DOTFILES_DIR` is
not set.

## Dotfiles

Files under `modules/dotfiles/home` are mapped to the same path under `$HOME`.
They are symlinked to this checkout rather than copied into the Nix store, so
editing a config applies immediately without a rebuild. The checkout location
is detected automatically from the directory you run `make` in (exported as
`DOTFILES_DIR` with impure eval), so the repo can live anywhere. When built
without that variable it falls back to `dotfilesRoot` (default
`Workspaces/dotfiles`, relative to `$HOME`), which you can override in a host
file.

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

`build` and `switch` run with `--impure` so the dotfiles module can read
`DOTFILES_DIR`. Garbage collection and store optimisation also run
automatically through `nix.gc` and `nix.optimise`.

Nix files are formatted with `nixfmt` (RFC style): run `make fmt` before
committing, and `make check` plus a `make build` for the affected host to
validate a change.

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

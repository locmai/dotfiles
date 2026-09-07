# AGENTS.md

Guidance for AI agents and contributors working in this repository.

## Overview

Loc's personal NixOS and nix-darwin configuration, driven by a single flake.
Two hosts are defined:

- `nixos` — ThinkPad X1 Carbon Gen 10 (`x86_64-linux`, NixOS)
- `AM-H6MRWRT99L` — MacBook Pro work machine (`aarch64-darwin`, nix-darwin)

## Commands

Run these from the repo root. `host` defaults to the current machine's
hostname; override with `make <target> host=nixos`.

- `make build` — build the system for `host` (no activation)
- `make diff` — build, then diff the new closure against the running system
- `make switch` — build and activate (uses `sudo`)
- `make update` — `nix flake update`
- `make fmt` — format all Nix with `nixfmt-tree`
- `make check` — `nix flake check`
- `make clean` — garbage-collect old generations
- `make optimise` — `nix store optimise`

Build/switch pass `DOTFILES_DIR=$(CURDIR)` and `--impure` so the dotfiles
module can symlink to the live checkout wherever it is cloned.

## Layout

- `flake.nix` — inputs, overlay, and the `mkHost` builder wiring modules together
- `base/` — cross-platform config; `linux.nix` / `darwin.nix` are imported by
  platform via `platform.parsed.kernel.name`. Defines `primaryUser` and
  `dotfilesRoot` options.
- `hosts/<host>.nix` — per-machine config; `hosts/hardware/` holds hardware scans
- `modules/` — feature modules: `cli`, `gui`, `hyprland`, `agents`, `personal`,
  `work`, and `dotfiles`. Modules follow the `default.nix` +
  `linux.nix`/`darwin.nix` split where behavior diverges.
- `modules/dotfiles/home/` — plain config files mirrored to `$HOME`; symlinked to
  the checkout (not copied to the store) so edits apply without a rebuild
- `pkgs/` — custom packages exposed as `pkgs.unofficial.<name>`
- `scripts/rebuild.py` — wrapper over `nixos-rebuild` / `darwin-rebuild`
- `.github/workflows/test.yaml` — CI

## Conventions

- Nix files are formatted with `nixfmt` (RFC style). Always run `make fmt`
  before committing.
- Keep platform-specific logic in the matching `linux.nix` / `darwin.nix`;
  keep shared logic in `default.nix`.
- Adding a dotfile: drop it under `modules/dotfiles/home/<path>` (mirroring its
  `$HOME` location) and rebuild once to create the symlink. No module edit needed.
- Unstable packages are available via the `unstable` overlay
  (`pkgs.unstable.<name>`).
- Prefer `make check` and a `make build` for the affected host to validate
  changes before switching.
- Commit messages follow Conventional Commits (e.g. `fix(darwin): ...`,
  `feat(work): ...`).

#!/usr/bin/env python3
"""Thin wrapper around nixos-rebuild and darwin-rebuild.

On a fresh macOS machine, Nix and Homebrew are installed first so that the
initial `make switch` works from a clean system.

Kept compatible with the macOS system Python (3.9), which is the only
interpreter available before Nix is installed.
"""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
import tempfile
import urllib.request

DARWIN_REBUILD_FLAKE = "nix-darwin/nix-darwin-26.05#darwin-rebuild"


def run_installer(url: str, shell: str, env: dict[str, str] | None = None) -> None:
    with tempfile.NamedTemporaryFile(delete=False) as script:
        path = script.name

    try:
        with urllib.request.urlopen(url) as response:
            with open(path, "wb") as file:
                file.write(response.read())

        subprocess.run(
            [shell, path],
            check=True,
            env={**os.environ, **(env or {})},
        )
    finally:
        os.unlink(path)


def ensure_homebrew() -> None:
    if shutil.which("brew") is None:
        run_installer(
            "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh",
            "bash",
            {"NONINTERACTIVE": "1"},
        )


def ensure_nix() -> None:
    if shutil.which("nix") is None:
        run_installer("https://nixos.org/nix/install", "sh")


def main() -> None:
    platform = os.uname().sysname.lower()

    if platform == "linux":
        command = ["nixos-rebuild", *sys.argv[1:]]
    elif platform == "darwin":
        ensure_homebrew()
        ensure_nix()
        command = [
            "/nix/var/nix/profiles/default/bin/nix",
            "--experimental-features",
            "nix-command flakes",
            "run",
            DARWIN_REBUILD_FLAKE,
            "--",
            *sys.argv[1:],
        ]
    else:
        raise SystemExit(f"unsupported platform: {platform}")

    os.execvp(command[0], command)


if __name__ == "__main__":
    main()

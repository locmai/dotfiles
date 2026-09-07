{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    coreutils
    pinentry_mac
  ];

  environment.systemPath = [
    "${config.homebrew.prefix}/bin"
  ];

  homebrew.brews = [
    # Keep the Homebrew list short, these have poor or broken Nix support on Darwin
    "libpq"
    "llvm"
  ];

  # nix-darwin owns /etc/zshrc, which loads the Nix environment. Completion and
  # prompt initialization are handled by zinit in the dotfiles instead.
  programs.zsh = {
    enableBashCompletion = false;
    enableCompletion = false;
    promptInit = "";
  };

  environment.variables.CGO_ENABLED = "1";
}

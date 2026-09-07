{ config, pkgs, ... }:

{
  programs.steam.enable = true;

  home-manager.users.${config.primaryUser.username}.home.packages = with pkgs; [
    audacity
    pokeget-rs
    pear-desktop
    signal-desktop

    # Local models
    ollama
  ];
}

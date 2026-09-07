{ config, lib, ... }:

let
  username = config.primaryUser.username;
in

{
  system.primaryUser = username;

  # TODO drop once https://github.com/LnL7/nix-darwin/issues/682 is fixed
  users.users.${username}.home = "/Users/${username}";

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
  };

  nix.settings = {
    allowed-users = [ "@admin" ];
    trusted-users = [ "@admin" ];
  };

  # Nix cannot build Linux derivations natively on Darwin
  nix.linux-builder = {
    enable = true;
    config.virtualisation = {
      cores = 8;
      darwin-builder = {
        diskSize = 128 * 1024;
        memorySize = 16 * 1024;
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager.users.${username} = {
    home.stateVersion = lib.mkDefault "25.05";
    home.enableNixpkgsReleaseCheck = false;
    programs.home-manager.enable = lib.mkDefault true;
  };

  # Used for backwards compatibility, read the changelog before changing:
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}

{
  lib,
  pkgs,
  platform,
  ...
}:

{
  imports = [
    ./${platform.parsed.kernel.name}.nix
  ];

  options = {
    primaryUser = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "Local account username for this host.";
      };
      fullName = lib.mkOption {
        type = lib.types.str;
        default = "Loc Mai";
        description = "Display name for the primary user.";
      };
      authorizedKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "SSH public keys authorized for the primary user on this host.";
      };
    };

    dotfilesRoot = lib.mkOption {
      type = lib.types.str;
      default = "Workspace/dotfiles";
      description = ''
        Path of this repository relative to the primary user's home directory.
        The dotfiles module symlinks into this checkout instead of the Nix
        store, so edits apply without a rebuild.
      '';
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      curl
      git
      tmux
      tree
      unzip
      watch
      wget
    ];

    environment.variables = {
      EDITOR = "nvim";
      KUBE_EDITOR = "nvim";
    };

    programs = {
      zsh.enable = true;
      direnv = {
        enable = true;
        silent = true;
      };
    };

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      optimise.automatic = true;
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };
    };

    nixpkgs.config.allowUnfree = true;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      # Existing files are renamed instead of failing the activation, which
      # matters when migrating a machine that had real dotfiles in place
      backupFileExtension = "hm-backup";
    };
  };
}

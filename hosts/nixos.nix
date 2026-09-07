{ pkgs, ... }:

{
  imports = [
    ./hardware/nixos.nix
    ../modules/agents
    ../modules/cli
    ../modules/dotfiles
    ../modules/gui
    ../modules/hyprland
    ../modules/personal
  ];

  primaryUser.username = "locmai";
  # Add the public keys that may log in over SSH, for example:
  # primaryUser.authorizedKeys = [ "ssh-ed25519 AAAA..." ];
  primaryUser.authorizedKeys = [ ];

  # Intel iGPU video acceleration, LIBVA_DRIVER_NAME=iHD
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  # The laptop is docked most of the time, so favour responsiveness over battery
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
}

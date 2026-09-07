{ config, pkgs, ... }:

let
  start-hyprland = pkgs.writeShellScriptBin "start-hyprland" ''
    exec ${config.programs.hyprland.package}/bin/Hyprland "$@"
  '';
in
{
  programs.hyprland.enable = true;

  # Greeter launches Hyprland via start-hyprland, there is only ever one session
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I %M %p | %a * %h | %F' --cmd start-hyprland";
      user = "greeter";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # fcitx5 is configured in base/linux.nix
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    tuigreet
    start-hyprland
  ];

  home-manager.users.${config.primaryUser.username}.home.packages = with pkgs; [
    # Hyprland ecosystem, driven by ~/.config/hypr
    hypridle
    hyprcursor
    hyprlock
    hyprpaper
    hyprpicker
    pyprland

    # Bar, launcher, notifications
    dunst
    libnotify
    rofi
    waybar

    # Audio and display controls
    avizo
    networkmanagerapplet
    pamixer
    pavucontrol
    playerctl

    # Screenshots and clipboard, used by ~/.sh_functions
    cliphist
    grim
    gifsicle
    slurp
    swappy
    wl-clip-persist
    wl-clipboard
    wl-screenrec
    wlrctl
    wtype
    xdg-utils
  ];
}

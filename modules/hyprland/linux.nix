{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    # Launch through UWSM so Hyprland runs under a proper systemd session
    # and stops warning about being started without a session manager.
    withUWSM = true;
  };

  # Greeter launches Hyprland via UWSM, there is only ever one session
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I %M %p | %a * %h | %F' --cmd 'uwsm start hyprland-uwsm.desktop'";
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

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Themes, matching the Gruvbox setup in the dotfiles
    colloid-icon-theme
    gruvbox-dark-icons-gtk
    gruvbox-gtk-theme
    gruvbox-kvantum
    numix-icon-theme-circle

    # Qt integration for a Wayland session
    libsForQt5.qt5.qttools
    qt6.qtwayland
  ];

  environment.variables = {
    GTK_THEME = "Gruvbox-Dark-BL-LB";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  };

  console.earlySetup = true;

  # Keyboard firmware flashing
  hardware.keyboard.qmk.enable = true;
  services.udev.packages = with pkgs; [ via ];

  home-manager.users.${config.primaryUser.username}.home.packages = with pkgs; [
    # Browsers and terminals
    brave
    firefox
    ghostty
    google-chrome
    kitty

    # Media and graphics
    gimp
    vlc
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-pipewire-audio-capture
        wlrobs
      ];
    })

    # Meetings
    zoom-us

    # Keyboard firmware
    qmk
    vial
  ];
}

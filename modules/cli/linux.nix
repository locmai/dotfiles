{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dig
    file
    gcc
    gnumake
    killall
    pinentry-curses
    psmisc
    usbutils
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  environment.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  home-manager.users.${config.primaryUser.username}.home.packages = with pkgs; [
    distrobox
    podman-compose
    qemu
  ];
}

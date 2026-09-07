{
  config,
  pkgs,
  ...
}:

let
  username = config.primaryUser.username;
in

{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    initrd.systemd.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    plymouth.enable = true;
  };

  hardware = {
    enableAllHardware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  networking = {
    networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    firewall.checkReversePath = "loose";
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "America/Los_Angeles";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # Vietnamese input with Telex, cycled with Shift+Super+Ctrl
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-bamboo
          fcitx5-gtk
          qt6Packages.fcitx5-configtool
          qt6Packages.fcitx5-with-addons
        ];
        settings = {
          inputMethod = {
            "Groups/0" = {
              "Name" = "Default";
              "Default Layout" = "us";
              "DefaultIM" = "keyboard-us";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "bamboo";
          };
          globalOptions = {
            "Behavior".ShowInputMethodInformation = "False";
            "Hotkey/EnumerateForwardKeys"."0" = "Shift+Super+Ctrl";
          };
          addons.bamboo.globalSection.InputMethod = "Telex 2";
        };
      };
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    blueman.enable = true;
    dbus.enable = true;
    gvfs.enable = true;
    resolved = {
      enable = true;
      settings.Resolve.FallbackDNS = [
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
    # Sound
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  # SSH keys are held by the GnuPG agent, see modules/cli/linux.nix
  programs.ssh.startAgent = false;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune = {
      enable = true;
      flags = [
        "--all"
        "--volumes"
      ];
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = config.primaryUser.fullName;
    extraGroups = [
      "networkmanager"
      "podman"
      "video"
      "wheel"
    ];
    openssh.authorizedKeys.keys = config.primaryUser.authorizedKeys;
    shell = pkgs.zsh;
    # No credentials are committed to this repository. Set the password from
    # the installer or a root shell with `passwd ${username}`.
  };

  home-manager.users.${username} = {
    home.stateVersion = "25.11";
    home.enableNixpkgsReleaseCheck = false;
    programs.home-manager.enable = true;
  };

  # This value determines the NixOS release from which the default settings for
  # stateful data were taken. Read the documentation before changing it.
  system.stateVersion = "25.11";
}

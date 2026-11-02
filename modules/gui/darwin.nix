{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Tiling window manager and status bar
    aerospace
    sketchybar
    sketchybar-app-font

    # Input and display utilities
    keycastr
    unnaturalscrollwheels

    # Keyboard firmware
    qmk

    # Rex Beta is installed manually and ships its CLI inside the app bundle.
    # Exec it in place since it is versioned with the app it talks to.
    (writeShellScriptBin "rex" ''
      exec "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex" "$@"
    '')
  ];

  homebrew.casks = [
    "brave-browser"
    "cursor"
    "google-chrome"
    "kitty"
    "logseq"
  ];

  system.defaults = {
    dock = {
      autohide = true;
      minimize-to-application = true;
      mru-spaces = false;
      showhidden = true;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      # AeroSpace and SketchyBar replace the menu bar
      _HIHideMenuBar = true;
    };
    CustomUserPreferences = {
      "com.apple.Safari" = {
        AlwaysRestoreSessionAtLaunch = true;
        AutoOpenSafeDownloads = false;
        EnableNarrowTabs = false;
        IncludeDevelopMenu = true;
        NeverUseBackgroundColorInToolbar = true;
        ShowFullURLInSmartSearchField = true;
        ShowOverlayStatusBar = true;
        ShowStandaloneTabBar = false;
      };
    };
  };

  home-manager.users.${config.primaryUser.username}.home.packages = with pkgs; [
    # Sketchybar plugins shell out to these
    jq
    switchaudio-osx
  ];
}

{ pkgs, ... }:

{
  homebrew = {
    casks = [
      "aws-vpn-client"
      "royal-tsx"
      "session-manager-plugin"
    ];
    brews = [
    ];
  };

  environment.systemPackages = with pkgs; [
    # GlobalProtect and the VPN clients expect these on PATH
    openconnect
  ];
}

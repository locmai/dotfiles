{ pkgs, ... }:

{
  homebrew = {
    casks = [
      "aws-vpn-client"
      "royal-tsx"
    ];
    brews = [
      # Not packaged for Darwin in nixpkgs
      "session-manager-plugin"
    ];
  };

  environment.systemPackages = with pkgs; [
    # GlobalProtect and the VPN clients expect these on PATH
    openconnect
  ];
}

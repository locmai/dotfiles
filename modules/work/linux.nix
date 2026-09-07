{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openconnect
    ssm-session-manager-plugin
  ];
}

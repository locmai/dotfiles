{
  config,
  pkgs,
  platform,
  ...
}:

{
  imports = [
    ./${platform.parsed.kernel.name}.nix
  ];

  home-manager.users.${config.primaryUser.username}.home.packages = with pkgs; [
    # Cloud providers
    awscli2
    azure-cli
    azure-storage-azcopy
    kubelogin
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])

    # Access and credentials
    granted
    sops

    # Service mesh and observability
    istioctl
    prometheus.cli

    # Issue tracking
    jira-cli-go
  ];
}

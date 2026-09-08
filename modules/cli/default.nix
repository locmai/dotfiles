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

  home-manager.users.${config.primaryUser.username}.home.packages =
    (with pkgs; [
      # Shell and file utilities
      aria2
      bat
      btop
      dyff
      eza
      fastfetch
      fd
      fzf
      gnupg
      jq
      mosh
      nnn
      ripgrep
      yazi
      yq-go
      zoxide

      # Editor
      neovim
      tree-sitter

      # Git and forge
      gh
      git-lfs

      # Media
      ffmpeg
      imagemagick
      yt-dlp

      # Security
      bitwarden-cli
      openssl
      sslscan
      step-cli
      trivy
      zizmor
      (pass.withExtensions (ext: with ext; [ pass-otp ]))
      rbw

      # Build tooling
      act
      cmake
      go-task
      jsonnet
      jsonnet-bundler
      protobuf

      # Kubernetes
      argocd
      cmctl
      helm-ls
      ingress2gateway
      k3d
      k9s
      kind
      kubectl
      kubectl-tree
      kubectl-view-allocations
      kubectx
      kubernetes-helm
      kubernetes-helmPlugins.helm-unittest
      kustomize
      operator-sdk
      oras
      skaffold
      thanos

      # Infrastructure as code
      chart-testing
      opentofu
      terraform-docs
      terragrunt

      # Languages
      dotnet-sdk
      go
      lua
      nodejs_24
      pnpm
      python3
      cargo
      rustc
      uv

      # Language servers and formatters
      alejandra
      bash-language-server
      buf
      clippy
      cmake-language-server
      delve
      docker-compose-language-service
      emmet-language-server
      gopls
      gotools
      hclfmt
      jsonfmt
      jsonnet-language-server
      lua-language-server
      markdown-oxide
      marksman
      nixd
      nixfmt
      pyright
      ruff
      rust-analyzer
      rustfmt
      stylua
      terraform-ls
      tflint
      typescript-language-server
      vscode-langservers-extracted
      yaml-language-server
      yamllint
    ])
    ++ (with pkgs.unstable; [
      # AI agents, tracked on unstable so they stay current
      claude-code
      codex
      opencode
      pi-coding-agent

      # MCP servers
      mcp-grafana
      playwright-mcp
    ]);
}

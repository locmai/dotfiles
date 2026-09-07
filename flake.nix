{
  description = "Loc's NixOS and nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      darwin,
      nixos-hardware,
      home-manager,
      ...
    }:
    let
      packageOverlay =
        final: prev:
        let
          system = final.stdenv.hostPlatform.system;
        in
        {
          unstable = import nixpkgs-unstable {
            inherit system;
            config = prev.config;
          };

          unofficial = import ./pkgs { pkgs = final; };
        };

      baseModules = [
        ./base
        {
          nixpkgs.overlays = [ packageOverlay ];
        }
      ];

      mkHost =
        {
          host,
          system,
          extraModules ? [ ],
        }:
        let
          platform = nixpkgs.lib.systems.elaborate system;
          builder = if platform.isDarwin then darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
          systemModules =
            if platform.isDarwin then
              [ home-manager.darwinModules.home-manager ]
            else
              [ home-manager.nixosModules.home-manager ];
        in
        builder {
          inherit system;
          specialArgs = {
            inherit inputs platform;
          };
          modules =
            baseModules
            ++ systemModules
            ++ extraModules
            ++ [
              {
                networking.hostName = host;
              }
              ./hosts/${host}.nix
            ];
        };
    in
    {
      # ThinkPad X1 Carbon Gen 10, personal machine
      nixosConfigurations.nixos = mkHost {
        host = "nixos";
        system = "x86_64-linux";
        extraModules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
        ];
      };

      # MacBook Pro, work machine
      darwinConfigurations."AM-H6MRWRT99L" = mkHost {
        host = "AM-H6MRWRT99L";
        system = "aarch64-darwin";
      };

      formatter = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-linux"
      ] (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}

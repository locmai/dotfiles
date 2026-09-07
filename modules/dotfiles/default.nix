{
  config,
  lib,
  ...
}:

let
  username = config.primaryUser.username;
  dotfilesRoot = config.dotfilesRoot;
  sourceRoot = ./home;

  # lib.path.removePrefix returns paths like "./.zshrc", home.file wants ".zshrc"
  relativeFiles = map (path: lib.removePrefix "./" (lib.path.removePrefix sourceRoot path)) (
    lib.filesystem.listFilesRecursive sourceRoot
  );
in
{
  config.home-manager.users.${username} =
    { config, ... }:

    let
      checkoutRoot = "${config.home.homeDirectory}/${dotfilesRoot}/modules/dotfiles/home";
    in
    {
      # Symlink into the checkout rather than the Nix store: editing a config
      # takes effect immediately, at the cost of the store's purity guarantees.
      home.file = lib.genAttrs relativeFiles (relativePath: {
        source = config.lib.file.mkOutOfStoreSymlink "${checkoutRoot}/${relativePath}";
      });
    };
}

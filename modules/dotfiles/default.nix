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
      # Prefer the directory the rebuild was invoked from (exported as
      # DOTFILES_DIR by the rebuild wrapper under impure eval) so the repo can
      # live anywhere. Fall back to dotfilesRoot relative to home otherwise.
      invocationDir = builtins.getEnv "DOTFILES_DIR";
      repoRoot =
        if invocationDir != "" then invocationDir else "${config.home.homeDirectory}/${dotfilesRoot}";
      checkoutRoot = "${repoRoot}/modules/dotfiles/home";
    in
    {
      # Symlink into the checkout rather than the Nix store: editing a config
      # takes effect immediately, at the cost of the store's purity guarantees.
      home.file = lib.genAttrs relativeFiles (relativePath: {
        source = config.lib.file.mkOutOfStoreSymlink "${checkoutRoot}/${relativePath}";
      });
    };
}

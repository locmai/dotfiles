{ config, lib, ... }:

{
  config.home-manager.users.${config.primaryUser.username} =
    { config, lib, ... }:

    let
      # Agent configuration lives in its own repository so it can be shared with
      # non-Nix machines. Symlink into that checkout when it is present.
      agentSetup = "${config.home.homeDirectory}/Workspaces/agent-setup";

      link = path: {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${agentSetup}/${path}";
      };

      linkDir =
        path:
        (link path)
        // {
          recursive = true;
        };
    in
    {
      home.file = {
        ".claude/CLAUDE.md" = link "CLAUDE.md";
        ".claude/settings.json" = link "settings.json";
        ".claude/settings.local.json" = link "settings.local.json";
        ".claude/agents" = linkDir "agents";
        ".claude/hooks" = linkDir "hooks";
        ".mcp.json" = link ".mcp.json";

        # Pi reads the same instructions as Claude Code
        ".pi/agent/AGENTS.md" = link "CLAUDE.md";
        ".pi/agent/settings.json" = link "pi/settings.json";
        ".pi/agent/themes" = linkDir "pi/themes";
      };

      # Claude Code searches only ~/.claude/skills, so the locally owned skills/
      # and the vendored pstack/ have to be flattened into that one directory,
      # one symlink per skill. Done in activation instead of home.file so the
      # skill list is read at activation time rather than at eval time, which
      # would make evaluation depend on a checkout outside the flake.
      home.activation.claudeSkills = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        skills="${config.home.homeDirectory}/.claude/skills"
        if [ -d "${agentSetup}" ]; then
          # An earlier generation managed this path as a single store symlink
          if [ -L "$skills" ]; then
            run rm -f "$skills"
          fi
          run mkdir -p "$skills"

          # Drop links for skills that no longer exist in the checkout
          for link in "$skills"/*; do
            [ -L "$link" ] || continue
            case "$(readlink "$link")" in
              ${agentSetup}/*) [ -e "$link" ] || run rm -f "$link" ;;
            esac
          done

          for src in "${agentSetup}"/skills/*/ "${agentSetup}"/pstack/*/; do
            [ -d "$src" ] || continue
            run ln -sfn "''${src%/}" "$skills/$(basename "$src")"
          done
        fi
      '';
    };
}

{ config, lib, ... }:

{
  config.home-manager.users.${config.primaryUser.username} =
    { config, ... }:

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
        ".claude/CLAUDE.md" = link ".claude/CLAUDE.md";
        ".claude/settings.json" = link ".claude/settings.json";
        ".claude/settings.local.json" = link ".claude/settings.local.json";
        ".claude/agents" = linkDir ".claude/agents";
        ".claude/skills" = linkDir ".claude/skills";
        ".claude/hooks" = linkDir ".claude/hooks";
        ".mcp.json" = link ".mcp.json";

        # Pi reads the same instructions as Claude Code
        ".pi/agent/AGENTS.md" = link ".claude/CLAUDE.md";
      };
    };
}

#!/usr/bin/env lua
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprland config authored in Lua.
--
-- Hyprland itself cannot read Lua, so this script GENERATES hyprland.conf.
-- NOTE: this file must NOT be named hyprland.lua -- Hyprland (>=0.51) will
-- auto-load a file named hyprland.lua as its native Lua config and break.
-- Regenerate with:
--     lua generate.lua > hyprland.conf
-- (this happens automatically on rebuild; see modules/hyprland/linux.nix)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

----------------------------------------------------------------------
-- Tiny DSL: helpers accumulate lines, then we print the conf at end --
----------------------------------------------------------------------

local out = {}
local function emit(s)
	out[#out + 1] = s or ""
end

-- A config block, e.g. general { ... }. `entries` is an ordered array whose
-- items are either "key = value" strings or nested { name, { ... } } blocks.
local function block(name, entries, indent)
	indent = indent or ""
	emit(indent .. name .. " {")
	for _, e in ipairs(entries) do
		if type(e) == "table" then
			block(e[1], e[2], indent .. "    ")
		else
			emit(indent .. "    " .. e)
		end
	end
	emit(indent .. "}")
end

local hl = {}
function hl.comment(s)
	emit("# " .. s)
end
function hl.blank()
	emit("")
end
function hl.raw(s)
	emit(s)
end
function hl.section(title)
	emit("############################")
	emit("### " .. title)
	emit("############################")
end
function hl.monitor(name, res, pos, scale)
	emit(("monitor=%s,%s,%s,%s"):format(name, res, pos, scale))
end
function hl.workspace(id, opts)
	emit(("workspace=%s,%s"):format(id, opts))
end
function hl.var(name, value)
	emit(("$%s = %s"):format(name, value))
end
function hl.env(k, v)
	emit(("env = %s,%s"):format(k, v))
end
function hl.block(name, entries)
	block(name, entries)
end
function hl.bezier(name, a, b, c, d)
	emit(("    bezier = %s, %s, %s, %s, %s"):format(name, a, b, c, d))
end
function hl.bind(mods, key, dispatch, arg)
	emit(("bind = %s, %s, %s%s"):format(mods, key, dispatch, arg and (", " .. arg) or ","))
end
function hl.bindm(mods, key, dispatch)
	emit(("bindm = %s, %s, %s"):format(mods, key, dispatch))
end
function hl.windowrule(rule)
	emit("windowrule = " .. rule)
end
function hl.exec_once(cmd)
	emit("exec-once=" .. cmd)
end
function hl.gesture(spec)
	emit("gesture = " .. spec)
end

------------------
---- MONITORS ----
------------------

hl.section("MONITORS")
hl.monitor("HDMI-A-1", "2560x1440", "0x0", "auto")
hl.monitor("eDP-1", "preferred", "0x2160", "auto")
hl.monitor("DP-3", "3840x2160", "0x0", "auto")
hl.blank()
-- Persistent workspaces pinned to monitors
for _, w in ipairs({
	{ "1", "DP-3" },
	{ "2", "DP-3" },
	{ "3", "DP-3" },
	{ "4", "DP-3" },
	{ "5", "eDP-1" },
	{ "6", "eDP-1" },
	{ "1", "DP-1" },
	{ "2", "DP-1" },
}) do
	hl.workspace(w[1], "monitor:" .. w[2] .. ",persistent:true")
end
hl.blank()

---------------------
---- MY PROGRAMS ----
---------------------

hl.section("MY PROGRAMS")
hl.var("terminal", "kitty")
hl.var("menu", "rofi -show drun")
hl.blank()

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.section("ENVIRONMENT VARIABLES")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.blank()

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.section("LOOK AND FEEL")
hl.block("general", {
	"gaps_in = 7",
	"gaps_out = 7,7,7,7",
	"border_size = 2",
	-- Gruvbox: bright orange -> yellow gradient on the active window
	"col.active_border = rgb(fe8019) rgb(fabd2f) 45deg",
	"col.inactive_border = rgb(3c3836)",
	"resize_on_border = false",
	"allow_tearing = false",
	"layout = dwindle",
})
hl.blank()
hl.block("decoration", {
	"rounding = 4",
	"active_opacity = 1.0",
	"inactive_opacity = 1.0",
	"dim_inactive = false",
	"dim_strength = 0.2",
	{
		"blur",
		{
			"enabled = false",
			"size = 3",
			"passes = 1",
			"vibrancy = 0.1696",
		},
	},
	{ "shadow", {
		"enabled = false",
	} },
})
hl.blank()
-- animations block, with beziers/animations emitted inline
emit("animations {")
emit("    enabled = true")
emit("")
hl.bezier("myBezier", "0.05", "0.9", "0.1", "1.05")
emit("")
emit("    animation = windows, 1, 7, myBezier")
emit("    animation = windowsOut, 1, 7, default, popin 80%")
emit("    animation = border, 1, 10, default")
emit("    animation = borderangle, 1, 8, default")
emit("    animation = fade, 1, 7, default")
emit("    animation = workspaces, 1, 6, default")
emit("}")
hl.blank()
hl.block("dwindle", { "preserve_split = true" })
hl.blank()
hl.block("master", { "new_status = master" })
hl.blank()
hl.block("misc", {
	"force_default_wallpaper = 1",
	"disable_splash_rendering = true",
	"disable_hyprland_logo = true",
})
hl.blank()

---------------
---- INPUT ----
---------------

hl.section("INPUT")
hl.block("input", {
	"kb_layout = us",
	"kb_variant =",
	"kb_model =",
	"kb_options =",
	"kb_rules =",
	"follow_mouse = 1",
	"sensitivity = 0",
	{ "touchpad", {
		"natural_scroll = true",
	} },
})
hl.blank()
hl.block("device", {
	"name = epic-mouse-v1",
	"sensitivity = -0.5",
})
hl.blank()
hl.block("debug", { "enable_stdout_logs = true" })
hl.blank()

---------------------
---- KEYBINDINGS ----
---------------------

hl.section("KEYBINDINGS")
hl.var("mainMod", "SUPER")
hl.blank()

local M = "$mainMod"
hl.bind(M, "Q", "killactive")
-- Regenerate hyprland.conf from this Lua file, then reload
hl.bind(M, "P", "exec", "lua ~/.config/hypr/generate.lua > ~/.config/hypr/hyprland.conf && hyprctl reload")
hl.bind(M, "E", "exec", "$terminal -e yazi")
hl.bind(M, "F", "fullscreen")
hl.bind(M, "space", "exec", "rofi -show drun")
hl.bind(M, "Y", "exec", "youtube-music")
hl.bind(M .. " ALT", "L", "exec", "hyprlock")
hl.bind(M, "M", "fullscreen")
hl.bind(M .. " ALT", "4", "exec", "bash -c 'source ~/.sh_functions && screenshot_to_clipboard'")
hl.bind(M .. " ALT", "3", "exec", "ghostty --class yazi-ghostty -e yazi")
hl.bind(M, "B", "exec", "brave")
hl.bind(M, "T", "exec", "kitty")
hl.bind(M, "G", "exec", "ghossty")
hl.bind("", "XF86AudioRaiseVolume", "exec", "volumectl -u up")
hl.bind("", "XF86AudioLowerVolume", "exec", "volumectl -u down")
hl.bind("", "XF86AudioMute", "exec", "volumectl toggle-mute")
hl.bind("", "XF86AudioMicMute", "exec", "volumectl -m toggle-mute")
hl.blank()

-- Move focus with mainMod + hjkl
hl.bind(M, "h", "movefocus", "l")
hl.bind(M, "l", "movefocus", "r")
hl.bind(M, "k", "movefocus", "u")
hl.bind(M, "j", "movefocus", "d")
hl.bind(M, "Tab", "cyclenext")
hl.bind(M, "Tab", "bringactivetotop")
hl.bind(M .. " SHIFT", "h", "movewindow", "l")
hl.bind(M .. " SHIFT", "l", "movewindow", "r")
hl.bind(M .. " SHIFT", "k", "movewindow", "u")
hl.bind(M .. " SHIFT", "j", "movewindow", "d")
hl.blank()

-- Switch workspaces / move window to workspace with mainMod (+ SHIFT) + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(M, tostring(key), "workspace", tostring(i))
end
for i = 1, 10 do
	local key = i % 10
	hl.bind(M .. " SHIFT", tostring(key), "movetoworkspace", tostring(i))
end
hl.bind(M .. " SHIFT", "LEFT", "movecurrentworkspacetomonitor", "+1")
hl.bind(M .. " SHIFT", "RIGHT", "movecurrentworkspacetomonitor", "-1")
hl.blank()

-- Special workspace (scratchpad)
hl.bind(M, "S", "togglespecialworkspace", "magic")
hl.bind(M .. " SHIFT", "S", "movetoworkspace", "special:magic")
hl.blank()

-- Scroll through workspaces with mainMod + scroll
hl.bind(M, "mouse_down", "workspace", "e+1")
hl.bind(M, "mouse_up", "workspace", "e-1")
hl.blank()

-- Move/resize windows with mainMod + LMB/RMB drag
hl.bindm(M, "mouse:272", "movewindow")
hl.bindm(M, "mouse:273", "resizewindow")
hl.blank()

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.section("WINDOWS AND WORKSPACES")
hl.windowrule("opaque title:(YouTube Music)")
hl.windowrule("workspace 1 class:^(landing-ghostty)$")
hl.windowrule("workspace 2 class:^(landing-brave)$")
hl.windowrule("suppress_event maximize class:.*")
hl.blank()
hl.exec_once("bash ~/.config/hypr/startup.sh")
hl.blank()
hl.gesture("3, horizontal, workspace")

----------------------------------------------------------------------
-- Emit the generated hyprland.conf to stdout                        --
----------------------------------------------------------------------

print("# AUTOGENERATED from hyprland.lua -- do not edit hyprland.conf directly.")
print(table.concat(out, "\n"))

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Native Hyprland Lua config (Hyprland >= 0.51, using the runtime `hl` API).
--
-- Hyprland loads and executes this file directly; there is no generation step
-- and no hyprland.conf. Edit this file, then reload with `hyprctl reload`.
-- API reference: https://wiki.hypr.land/Configuring/
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "HDMI-A-1", mode = "2560x1440", position = "0x0", scale = "auto" })
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x2160", scale = "auto" })
hl.monitor({ output = "DP-3", mode = "3840x2160", position = "0x0", scale = "auto" })

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
	hl.workspace_rule({ workspace = w[1], monitor = w[2], persistent = true })
end

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local menu = "rofi -show drun"

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 7,
		gaps_out = 7,
		border_size = 2,
		-- Gruvbox: bright orange -> yellow gradient on the active window
		col = {
			active_border = { colors = { "rgb(fe8019)", "rgb(fabd2f)" }, angle = 45 },
			inactive_border = "rgb(3c3836)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 4,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		dim_inactive = false,
		dim_strength = 0.2,
		blur = {
			enabled = false,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
		shadow = {
			enabled = false,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 1,
		disable_splash_rendering = true,
		disable_hyprland_logo = true,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
		},
	},

	debug = {
		enable_stdout_logs = true,
	},
})

hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-- Animation curves and leaves (ports the old myBezier config)
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(terminal .. " -e yazi"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("youtube-music"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + ALT + 4", hl.dsp.exec_cmd("bash -c 'source ~/.sh_functions && screenshot_to_clipboard'"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"))

-- Audio keys (no modifier)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volumectl -u up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volumectl -u down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volumectl toggle-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("volumectl -m toggle-mute"), { locked = true })

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Tab", hl.dsp.window.bring_to_top())

-- Move windows with mainMod + SHIFT + hjkl
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

-- Switch workspaces / move window to workspace with mainMod (+ SHIFT) + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.workspace.move({ monitor = "-1" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB drag
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({ match = { title = "YouTube Music" }, opaque = true })
hl.window_rule({ match = { class = "landing-brave" }, workspace = "2" })
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-----------------
---- STARTUP ----
-----------------

hl.on("hyprland.start", function()
	hl.exec_cmd("bash ~/.config/hypr/startup.sh")
end)

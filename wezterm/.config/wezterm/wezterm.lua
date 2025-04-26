local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- +------------------------------------+
-- | APPEARANCE SETTINGS                |
-- +------------------------------------+

--[[ FONT ]]
-- Favorites: Berkeley Mono, Ubuntu Mono Nerd Font, CozetteVector Nerd Font (like Fixedsys Excelsior), Hack Nerd Font Mono, JetBrainsMonoNL Nerd Font Mono
-- ComicShannsMono Nerd Font Mono
config.font = wezterm.font("HackNerdFontMono")
config.font_size = 10.0
config.line_height = 1.0

config.color_scheme = "Hardcore (base16)"

-- [[ TAB BAR ]]
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.colors = {
	tab_bar = {
		background = "black",
		active_tab = {
			bg_color = "red",
			fg_color = "white",
			intensity = "Bold",
			italic = false,
		},
		inactive_tab = {
			bg_color = "black",
			fg_color = "white",
		},
		new_tab = {
			bg_color = "black",
			fg_color = "white",
		},
	},
}

-- +------------------------------------+
-- | FUNCTIONALITY SETTINGS             |
-- +------------------------------------+

config.scrollback_lines = 100000
config.check_for_updates = false
config.exit_behavior = "CloseOnCleanExit"
config.window_close_confirmation = "NeverPrompt"

-- +------------------------------------+
-- | STATUS BAR CONFIGURATION           |
-- +------------------------------------+

-- Helper functions for status bar
local function get_username()
	return os.getenv("USER") or "unknown"
end

local function get_hostname()
	local f = io.popen("/bin/hostnamectl hostname")
	if f then
		local hostname = f:read("*a") or "unknown"
		f:close()
		return hostname:gsub("%s+", "")
	end
	return "unknown"
end

wezterm.on("update-status", function(window, pane)
	local leader = window:leader_is_active() and "^A " or ""

	window:set_left_status(window:active_workspace() .. " § ")
	window:set_right_status(wezterm.format({
		{ Background = { Color = "#039DFC" } },
		{ Text = leader },
		{ Background = { Color = "black" } },
		{ Foreground = { Color = "white" } },
		{ Text = " " .. get_username() .. "@" .. get_hostname() },
	}))
end)

-- +------------------------------------+
-- | KEY BINDINGS                       |
-- +------------------------------------+

config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL" }

-- Helper for creating repeatble comamnds
local function make_repeatable(key, action)
	return {
		key = key,
		mods = "LEADER",
		action = wezterm.action.Multiple({
			action,
			wezterm.action.ActivateKeyTable({
				name = "repeat_" .. key,
				timeout_milliseconds = 1000,
				one_shot = false,
			}),
		}),
	}
end

-- Repeatable resize key tables
config.key_tables = {
	repeat_H = { { key = "H", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) } },
	repeat_J = { { key = "J", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) } },
	repeat_K = { { key = "K", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) } },
	repeat_L = { { key = "L", mods = "SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) } },
}

config.keys = {
	-- [[ Default terminal binds ]]
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },

	-- Tab management
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab("DefaultDomain") },
	{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{ key = "Tab", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },

	-- Scrolling
	{ key = "PageUp", mods = "SHIFT", action = wezterm.action.ScrollByPage(-1) },
	{ key = "PageDown", mods = "SHIFT", action = wezterm.action.ScrollByPage(1) },

	-- Wezterm specific binds
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ShowDebugOverlay },
	{ key = "p", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCommandPalette },
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(wezterm.action.Search("CurrentSelectionOrEmptyString"), pane)
			window:perform_action(
				wezterm.action.Multiple({
					wezterm.action.CopyMode("ClearPattern"),
					wezterm.action.ClearSelection,
					wezterm.action.CopyMode("ClearSelectionMode"),
					wezterm.action.CopyMode("MoveToScrollbackBottom"),
				}),
				pane
			)
		end),
	},

	-- [[ Tmux ]]
	{ key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = wezterm.action.ActivateTab(8) },
	{ key = "0", mods = "LEADER", action = wezterm.action.ActivateTab(-1) },

	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "f", mods = "LEADER", action = wezterm.action.ShowTabNavigator },

	-- Pane navigation
	{ key = "h", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Right") },
	make_repeatable("H", wezterm.action.AdjustPaneSize({ "Left", 1 })),
	make_repeatable("J", wezterm.action.AdjustPaneSize({ "Down", 1 })),
	make_repeatable("K", wezterm.action.AdjustPaneSize({ "Up", 1 })),
	make_repeatable("L", wezterm.action.AdjustPaneSize({ "Right", 1 })),

	-- Tab navigation and management
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "q", mods = "LEADER", action = wezterm.action.QuitApplication },
	{ key = "s", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "TABS" }) },
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{
		key = ",",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename Tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Search
	{ key = "/", mods = "LEADER", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },
	{ key = "?", mods = "LEADER|SHIFT", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },
}

return config

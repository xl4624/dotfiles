local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- +------------------------------------+
-- | APPEARANCE SETTINGS                |
-- +------------------------------------+

--[[ FONT ]]
-- Favorites: Berkeley Mono, Ubuntu Mono Nerd Font, CozetteVector Nerd Font (like Fixedsys Excelsior), Hack Nerd Font Mono, JetBrainsMonoNL Nerd Font Mono
-- ComicShannsMono Nerd Font Mono
config.font = wezterm.font("JetBrainsMonoNL")
config.font_size = 10.0
config.line_height = 1.0

-- [[ TAB BAR ]]
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.color_scheme = "Isotope (dark) (terminal.sexy)"
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

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
	local vim_pane_changed = false

	if pane:get_title():find("n?vim") ~= nil then
		local before = pane:get_cursor_position()
		window:perform_action(
			-- This should match the keybinds you set in Neovim.
			wezterm.action.SendKey({ key = vim_direction, mods = "CTRL" }),
			pane
		)
		wezterm.sleep_ms(50)
		local after = pane:get_cursor_position()

		if before.x ~= after.x and before.y ~= after.y then
			vim_pane_changed = true
		end
	end

	if not vim_pane_changed then
		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
	end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
	conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	conditionalActivatePane(window, pane, "Down", "j")
end)

-- +------------------------------------+
-- | KEY BINDINGS                       |
-- +------------------------------------+

config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = math.maxinteger }

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
			window:perform_action(wezterm.action.CopyMode("ClearPattern"), pane)
			window:perform_action(wezterm.action.ClearSelection, pane)
			window:perform_action(wezterm.action.CopyMode("ClearSelectionMode"), pane)
			window:perform_action(wezterm.action.CopyMode("MoveToScrollbackBottom"), pane)
		end),
	},

	-- Tab navigation
	{ key = "1", mods = "ALT", action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = wezterm.action.ActivateTab(4) },
	{ key = "6", mods = "ALT", action = wezterm.action.ActivateTab(5) },
	{ key = "7", mods = "ALT", action = wezterm.action.ActivateTab(6) },
	{ key = "8", mods = "ALT", action = wezterm.action.ActivateTab(7) },
	{ key = "9", mods = "ALT", action = wezterm.action.ActivateTab(8) },
	{ key = "0", mods = "ALT", action = wezterm.action.ActivateTab(9) },
	{ key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = wezterm.action.ActivateTab(8) },
	{ key = "0", mods = "LEADER", action = wezterm.action.ActivateTab(9) },

	-- [[ Tmux ]]
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "f", mods = "LEADER", action = wezterm.action.ShowTabNavigator },

	-- Pane navigation
	{ key = "h", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
	{ key = "j", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
	{ key = "k", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
	{ key = "l", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },
	make_repeatable("H", wezterm.action.AdjustPaneSize({ "Left", 1 })),
	make_repeatable("J", wezterm.action.AdjustPaneSize({ "Down", 1 })),
	make_repeatable("K", wezterm.action.AdjustPaneSize({ "Up", 1 })),
	make_repeatable("L", wezterm.action.AdjustPaneSize({ "Right", 1 })),

	-- Tab navigation and management
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER|CTRL", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "p", mods = "LEADER|CTRL", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "q", mods = "LEADER", action = wezterm.action.QuitApplication },
	{ key = "s", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "TABS" }) },
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{
		key = ",",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename Tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line and line ~= "" then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = ".",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Move tab to index:",
			action = wezterm.action_callback(function(window, pane, line)
				if line and line ~= "" then
					local index = tonumber(line)
					if index then
						-- using index - 1 to use 1-based indexing
						window:perform_action(wezterm.action.MoveTab(index - 1), pane)
					else
						window:toast_notification("Invalid input", "Please enter a number index.", nil, 4000)
					end
				end
			end),
		}),
	},

	-- Search
	{ key = "/", mods = "LEADER", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },
	{ key = "?", mods = "LEADER|SHIFT", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },
}

return config

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun"


-------------------
---- AUTOSTART ----
-------------------

-- Commands run via /bin/sh -c, so `&`, `||` and $HOME behave as before.
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start plasma-polkit-agent")
    hl.exec_cmd("brightnessctl set 50%")
    hl.exec_cmd("xremap $HOME/.config/xremap/config.yml & libinput-gestures-setup start")
    hl.exec_cmd("pidof -x battery_check.sh || $HOME/.config/hypr/battery_check.sh")
    hl.exec_cmd("wpctl set-default 51") -- set ThinkPad mic as default input
    hl.exec_cmd("nm-applet &")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar & dunst")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("HYPRCURSOR_THEME", "material-cursors")
hl.env("HYPRCURSOR_SIZE", "48")
hl.env("XCURSOR_THEME", "material-cursors-X")
hl.env("XCURSOR_SIZE", "48")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_MENU_PREFIX", "arch-")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 1,
        gaps_out = 1,

        border_size = 1,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",

        -- Don't wrap movefocus
        no_focus_fallback = true,
    },

    decoration = {
        rounding = 10,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("wind",   { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn",  { type = "bezier", points = { { 0.1, 1.1 },  { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner",  { type = "bezier", points = { { 1, 1 },      { 1, 1 } } })

hl.animation({ leaf = "windows",     enabled = true,  speed = 3,  bezier = "wind",  style = "slide" })
hl.animation({ leaf = "windowsIn",   enabled = true,  speed = 3,  bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true,  speed = 2,  bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true,  speed = 2,  bezier = "wind",  style = "slide" })
hl.animation({ leaf = "border",      enabled = true,  speed = 1,  bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true,  speed = 30, bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade",        enabled = true,  speed = 5,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = false })

hl.config({
    dwindle = {
        force_split    = 2,    -- New windows spawn to the right
        preserve_split = true, -- You probably want this
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        repeat_delay = 200,
        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        follow_mouse = 1,

        touchpad = {
            disable_while_typing = false,

            natural_scroll = true,
            scroll_factor  = 0.45,

            tap_to_click = false,
        },
    },

    cursor = {
        enable_hyprcursor = true,
    },

    ecosystem = {
        no_donation_nag = true,
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + Q",     hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W",     hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + E",     hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + O",     hl.dsp.exec_cmd("rofimoji"))
hl.bind(mainMod .. " + D",     hl.dsp.exec_cmd("vesktop"))
hl.bind(mainMod .. " + N",     hl.dsp.exec_cmd("networkmanager_dmenu"))
hl.bind(mainMod .. " + X",     hl.dsp.window.close())
hl.bind(mainMod .. " + M",     hl.dsp.submap("power"))
hl.bind(mainMod .. " + slash", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",     hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",     hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + Space", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + V",     hl.dsp.exec_cmd("$HOME/.config/hypr/cliphist-pick.sh"))

-- Fullscreen. SUPER + F is the launcher, so fullscreen takes the shifted key.
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())

-- Window finder: lists every window across all workspaces by title and jumps
-- to the one picked. Needs wlr-foreign-toplevel-management, which rofi 2.0
-- speaks and Hyprland advertises; on an older X11-only rofi this mode would
-- silently see nothing.
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("rofi -show window"))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Resize active window with mainMod + Shift + hjkl
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.resize({ x = -20, y = 0,   relative = true }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.resize({ x = 0,   y = 20,  relative = true }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.resize({ x = 0,   y = -20, relative = true }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.resize({ x = 20,  y = 0,   relative = true }))

-- Move active window to direction using mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


----------------------
---- POWER SUBMAP ----
----------------------

-- SUPER + M used to exit Hyprland outright, one key away from SUPER + N.
-- It now opens a modal menu instead, so a mistyped shortcut is harmless.
--
-- The "reset" second argument closes the submap after any bind in it fires,
-- so a single keypress always lands you back in the normal keymap.
--
-- Suspend deliberately does not lock here: hypridle's before_sleep_cmd
-- already runs loginctl lock-session on the way down.
--
-- If a submap ever does get stuck, from a terminal:
--     hyprctl dispatch 'hl.dsp.submap("reset")'

hl.define_submap("power", "reset", function()
    hl.bind("L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
    hl.bind("S", hl.dsp.exec_cmd("systemctl suspend"))
    hl.bind("R", hl.dsp.exec_cmd("systemctl reboot"))
    hl.bind("P", hl.dsp.exec_cmd("systemctl poweroff"))
    hl.bind("E", hl.dsp.exit())

    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind("Q",      hl.dsp.submap("reset"))
end)

-- On-screen hint for the power submap.
--
-- Submaps give no visual feedback on their own, so entering one is
-- invisible unless something draws the options. keybinds.submap fires with
-- the submap's name on entry and an empty string on exit.

local POWER_HINT = "  [L] lock    [S] suspend    [R] reboot    [P] poweroff    [E] exit Hyprland    [Esc] cancel"

local power_hint = nil

hl.on("keybinds.submap", function(name)
    if power_hint ~= nil then
        power_hint:dismiss()
        power_hint = nil
    end

    if name == "power" then
        power_hint = hl.notification.create({
            text      = POWER_HINT,
            timeout   = 30000,
            font_size = 18,
        })
    end
end)


-----------------
---- FN Keys ----
-----------------

-- Volume control
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/.config/hypr/round-volume.sh"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && ~/.config/hypr/round-volume.sh"))
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

-- Change Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))

-- Colour picker and screenshot
hl.bind(mainMod .. " + C",         hl.dsp.exec_cmd("hyprpicker -r -v"))
hl.bind(mainMod .. " + backslash", hl.dsp.exec_cmd("$HOME/.config/hypr/screenshot.sh"))


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "spotify-workspace",
    match = { class = "^(Spotify)$" },

    workspace = "9",
})

hl.window_rule({
    name  = "vesktop-workspace",
    match = { class = "^(vesktop)$" },

    workspace = "10",
})

hl.window_rule({
    name  = "zoom-menu-stay-focused",
    match = { title = "^(menu window)$", class = "^(zoom)$" },

    stay_focused = true,
})

hl.window_rule({
    -- Ignore maximize requests from apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- https://wiki.hypr.land/Useful-Utilities/Screen-Sharing/#xwayland
hl.window_rule({
    name  = "xwaylandvideobridge",
    match = { class = "^(xwaylandvideobridge)$" },

    opacity          = "0.0 override",
    no_anim          = true,
    no_initial_focus = true,
    max_size         = "1 1",
    no_blur          = true,
    no_focus         = true,
})

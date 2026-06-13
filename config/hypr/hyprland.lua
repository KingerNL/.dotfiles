-- Hyprland Lua config (migrated from hyprland.conf)

local mod = "ALT"

------------------
---- MONITORS ----
------------------

hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@60.05",
    position = "0x1080",
    scale = "1.2",
})

hl.monitor({
    output = "desc:HP Inc. HP E24 G5 CN442917QW",
    mode = "1920x1080@60",
    position = "0x0",
    scale = "1",
})

hl.monitor({
    output = "desc:HP Inc. HP E24 G5 CN442917RK",
    mode = "1920x1080@60",
    position = "-1920x0",
    scale = "1",
})

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME", "Simp1e-Gruvbox-Dark")
hl.env("HYPRCURSOR_THEME", "Simp1e-Gruvbox-Dark")
hl.env("HYPRCURSOR_SIZE", "20")
hl.env("XCURSOR_SIZE", "20")

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("zen-browser")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XCURSOR_THEME XCURSOR_SIZE HYPRCURSOR_THEME HYPRCURSOR_SIZE")
    hl.exec_cmd("sleep 1 && hyprctl setcursor Simp1e-Gruvbox-Dark 20")
end)

-----------------------
---- LOOK AND FEEL -----
-----------------------

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 3,
        layout = "dwindle",
        border_size = 1,
        col = {
            inactive_border = "rgba(7c6f64ee)",
            active_border = "rgba(ec4935ee)",
        },
        resize_on_border = true,
    },

    render = {
        cm_enabled = false,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    decoration = {
        shadow = {
            enabled = false,
        },
    },

    animations = {
        enabled = false,
    },

    cursor = {
        inactive_timeout = 0,
        hide_on_key_press = false,
        hide_on_touch = false,
        no_hardware_cursors = true,
        use_cpu_buffer = true,
        enable_hyprcursor = true,
    },

    ecosystem = {
        no_donation_nag = true,
        no_update_news = true,
    },

    ["misc.disable_hyprland_logo"] = true,
    ["misc.disable_splash_rendering"] = true,
    ["misc.force_default_wallpaper"] = 0,

    input = {
        kb_layout = "us",
        touchpad = {
            natural_scroll = true,
        },
    },
})

-----------------
---- CURVES ----
-----------------

hl.curve("default", { type = "bezier", points = { {0.12, 0.92}, {0.08, 1.0} } })
hl.curve("wind",    { type = "bezier", points = { {0.12, 0.92}, {0.08, 1.0} } })
hl.curve("overshot",{ type = "bezier", points = { {0.18, 0.95}, {0.22, 1.03} } })
hl.curve("liner",   { type = "bezier", points = { {1, 1}, {1, 1} } })

--------------------
---- ANIMATIONS ----
--------------------

hl.animation({ leaf = "windows",     enabled = true,  speed = 5,    bezier = "wind",     style = "popin 60%" })
hl.animation({ leaf = "windowsIn",   enabled = true,  speed = 6,    bezier = "overshot", style = "popin 60%" })
hl.animation({ leaf = "windowsOut",  enabled = true,  speed = 4,    bezier = "overshot", style = "popin 60%" })
hl.animation({ leaf = "windowsMove", enabled = true,  speed = 4,    bezier = "overshot", style = "popin" })
hl.animation({ leaf = "layers",      enabled = true,  speed = 4,    bezier = "default",  style = "popin" })
hl.animation({ leaf = "fadeIn",      enabled = true,  speed = 0.01, bezier = "default" })
hl.animation({ leaf = "fadeOut",     enabled = false, speed = 7,    bezier = "default" })
hl.animation({ leaf = "fadeSwitch",  enabled = true,  speed = 1,    bezier = "default" })
hl.animation({ leaf = "fadeShadow",  enabled = true,  speed = 1,    bezier = "default" })
hl.animation({ leaf = "fadeDim",     enabled = true,  speed = 1,    bezier = "default" })
hl.animation({ leaf = "fadeLayers",  enabled = true,  speed = 1,    bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = false, speed = 5,    bezier = "overshot", style = "slidevert" })
hl.animation({ leaf = "border",      enabled = true,  speed = 1,    bezier = "liner" })

------------------
---- KEYBINDS ----
------------------

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd("~/.config/hypr/scripts/nerd_rofi_picker.sh"))
hl.bind(mod .. " + D",      hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd("zen-browser"))
hl.bind(mod .. " + C",      hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mod .. " + SPACE",  hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod .. " + L",      hl.dsp.exec_cmd("hyprlock"))

hl.bind(mod .. " + H",     hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J",     hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K",     hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))

hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })

hl.bind("code:107", hl.dsp.exec_cmd("~/.config/hypr/scripts/grim-screenshot.sh"))
hl.bind("code:208", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("code:171", hl.dsp.exec_cmd("playerctl next"))
hl.bind("code:173", hl.dsp.exec_cmd("playerctl previous"))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

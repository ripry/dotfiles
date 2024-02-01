local wezterm = require("wezterm")

local config = {
    font = wezterm.font {
        family = "HackGen35 Console NF",
        weight = "Regular",
        stretch = "Normal",
        style = "Normal",
    },
    font_size = 14.0,
    window_decorations = 'INTEGRATED_BUTTONS | RESIZE',
}

return config

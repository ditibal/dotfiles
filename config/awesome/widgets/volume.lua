local lain = require("lain")
local wibox = require("wibox")
local gears = require("gears")

volume = lain.widget.alsabar({
    notification_preset = { font = "Monospace 9" },
    ticks = true,
    width = 80,
    height = 10,
    border_width = 0,
    colors = {
        background = "#383838",
        unmute = "#80CCE6",
        mute = "#FF9F9F"
    },
})

volume.bar.paddings = 0
volume.bar.margins = 5
local volumewidget = wibox.container.background(volume.bar, theme.bg_focus, gears.shape.rectangle)
volumewidget = wibox.container.margin(volumewidget, 0, 0, 5, 5)

return volumewidget

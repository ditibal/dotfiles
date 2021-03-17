local wibox = require("wibox")
local lain = require("lain")
local gears = require("gears")

local markup = lain.util.markup

local icon = wibox.widget.imagebox(theme.cpu)

local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(
            markup.font(theme.font, "CPU " .. cpu_now.usage .. "% ") ..
            markup.font("Roboto 5", " ")
        )
    end
})
local cpubg = wibox.container.background(cpu.widget, theme.bg_focus, gears.shape.rectangle)
local cpuwidget = wibox.container.margin(cpubg)
cpuwidget.forced_width = 90

local widget = wibox.widget {
    icon,
    cpuwidget,
    layout = wibox.layout.fixed.horizontal,
}

return widget

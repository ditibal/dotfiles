local wibox = require("wibox")
local lain = require("lain")

local markup = lain.util.markup

local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(
            markup.font(theme.font, "⚙ CPU " .. cpu_now.usage .. "% ")
        )
    end
})
local cpuwidget = wibox.container.margin(cpu.widget)

local widget = wibox.widget {
    cpuwidget,
    layout = wibox.layout.fixed.horizontal,
}

return wibox.container.margin(widget, 15, 15)
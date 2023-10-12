local wibox = require("wibox")
local vicious = require("vicious")

netwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.net)
vicious.register(
        netwidget,
        vicious.widgets.net,
        '<b>↓</b> <span color="#CC9393">${enp5s0 down_mb}</span>  <span color="#7F9F7F">${enp5s0 up_mb}</span> <b>↑</b>',
        2
)

local networkwidget = wibox.container.margin(netwidget, 0, 0, 5, 5)

local widget = wibox.widget {
    networkwidget,
    layout = wibox.layout.fixed.horizontal,
}

return widget

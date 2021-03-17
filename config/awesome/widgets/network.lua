local wibox = require("wibox")
local vicious = require("vicious")

local netdown_icon = wibox.widget.imagebox(theme.net_down)
local netup_icon = wibox.widget.imagebox(theme.net_up)

netwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.net)
vicious.register(netwidget, vicious.widgets.net,
    '<span color="#CC9393">${enp3s0 down_kb}</span>' ..
    ' <span color="#7F9F7F">${enp3s0 up_kb}</span>', 2)

local networkwidget = wibox.container.margin(netwidget, 0, 0, 5, 5)

local widget = wibox.widget {
    netdown_icon,
    networkwidget,
    netup_icon,
    layout = wibox.layout.fixed.horizontal,
}

return widget

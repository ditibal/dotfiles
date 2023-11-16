local wibox = require("wibox")
local vicious = require("vicious")

local netwidget = wibox.widget.textbox()
local template = string.format(
        '<b>↓</b> <span color="#CC9393">${%s down_mb}</span>  <span color="#7F9F7F">${%s up_mb}</span> <b>↑</b>',
        NETWORK_INTERFACE,
        NETWORK_INTERFACE
)
vicious.cache(vicious.widgets.net)
vicious.register(
        netwidget,
        vicious.widgets.net,
        template,
        2
)

local networkwidget = wibox.container.margin(netwidget, 0, 0, 5, 5)

local widget = wibox.widget {
    networkwidget,
    layout = wibox.layout.fixed.horizontal,
}

return widget

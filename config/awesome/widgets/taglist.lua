local wibox = require("wibox")
local awful = require("awful")

local taglist = {}

taglist.create = function(screen)
    local taglistwidget = awful.widget.taglist {
        screen = screen,
        filter = awful.widget.taglist.filter.all,
        style = {
            bg_focus = theme.bg_focus,
        }
    }

    return wibox.container.margin(taglistwidget)
end

return taglist

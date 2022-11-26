local wibox = require("wibox")
local awful = require("awful")

local taglist = {}

local taglist_buttons = awful.util.table.join(
        awful.button({ }, 1, function(t)
            t:view_only()
        end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({ }, 3, function(t)
            t.hidden = not t.hidden
            t:emit_signal("property::name")
        end)
)

taglist.create = function(screen)
    local taglistwidget = awful.widget.taglist {
        screen = screen,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style = {
            bg_focus = theme.bg_focus,
        }
    }

    return wibox.container.margin(taglistwidget)
end

return taglist

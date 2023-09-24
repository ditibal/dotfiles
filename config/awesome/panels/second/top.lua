local wibox = require("wibox")
local awful = require("awful")

local top_panel = {}

top_panel.create = function(screen)
    local taglist = require('widgets.taglist')

    local panel = awful.wibar({
        position = "top",
        screen = screen,
    })

    panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            taglist.create(screen),
        },
    }

    awesome.connect_signal("toggle_panel",
        function()
            panel.visible = not panel.visible
        end
    )
end

return top_panel
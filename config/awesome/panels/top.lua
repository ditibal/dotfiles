local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local lain = require("lain")

local top_panel = {}

top_panel.create = function(s)
    local taglist = require('widgets.taglist')

    local panel = awful.wibar({
        position = "top",
        screen = s,
        height = 24,
    })

    panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            taglist.create(s),
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            require('widgets.network'),
            require('widgets.cpu'),
            require('widgets.volume'),
        },
    }

    awesome.connect_signal("toggle_panel",
        function()
            panel.visible = not panel.visible
        end
    )
end

return top_panel

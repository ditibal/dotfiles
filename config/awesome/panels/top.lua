local wibox = require("wibox")
local awful = require("awful")

local top_panel = {}

top_panel.create = function(s)
    local taglist = require('widgets.taglist')
    local expenses = require('widgets.expenses')

    local panel = awful.wibar({
        position = "top",
        screen = s,
        height = 24,
    })

    local expensesWidget = expenses.create()
    local expensesContainer = wibox.container.margin(expensesWidget, 20, 0, 0, 0)

    panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            taglist.create(s),

            expensesContainer
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
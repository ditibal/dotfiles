local wibox = require("wibox")
local awful = require("awful")

local top_panel = {}

top_panel.create = function(screen)
    local taglist = require('widgets.taglist')
    local expenses = require('widgets.expenses')
    local audio_output = require('widgets.audio_output')
    local vpn_credit_btn = require('widgets.vpn_credit')

    local panel = awful.wibar({
        position = "top",
        screen = screen,
    })

    local expenses_widget = expenses.create()

    panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            taglist.create(screen),
            expenses_widget,
            vpn_credit_btn.widget,
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            require('widgets.network'),
            require('widgets.cpu'),
            audio_output.create(),
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
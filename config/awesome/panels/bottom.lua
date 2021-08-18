local wibox = require("wibox")
local awful = require("awful")
local lain = require("lain")
local beautiful = require("beautiful")

local markup = lain.util.markup

local bottom_panel = {}

bottom_panel.create = function(screen)
    local tasklist = awful.widget.tasklist(
            screen,
            awful.widget.tasklist.filter.currenttags,
            awful.util.tasklist_buttons,
            {
                bg_focus = theme.bg_focus,
                align = "center",
            }
    )

    local clockwidget = wibox.widget.textclock(markup("#FFFFFF", "%H:%M   " .. markup.font("Noto 4", " ")))
    clockwidget.forced_width = 65

    local panel = awful.wibar({
        position = "bottom",
        screen = screen,
        border_width = 5,
        border_color = beautiful.border_normal,
        height = 24,
    })

    panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            tasklist
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            clockwidget,
        },
    }

    awesome.connect_signal("toggle_panel",
            function()
                panel.visible = not panel.visible
            end
    )
end

return bottom_panel
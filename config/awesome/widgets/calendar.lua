local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local python = require('python')

local Calendar = {}

Calendar.create = function()
    Calendar.cal = python.import "cal".create()
    Calendar.textWidget = wibox.widget.textbox('')

    awesome.connect_signal('login', function()
        Calendar.update()
    end)

    gears.timer {
        timeout = 1,
        call_now = false,
        autostart = true,
        callback = Calendar.update
    }

    gears.timer {
        timeout = 3600,
        call_now = false,
        autostart = true,
        callback = Calendar.fetch
    }

    local container = wibox.container.margin(Calendar.textWidget, 30, 30)
    Calendar.container = wibox.container.background(container, '#5484ed')

    Calendar.update()

    local widget = wibox.container.margin(Calendar.container, 50, 0, 0, 0)

    local tooltip = awful.tooltip { }

    tooltip:add_to_object(widget)

    widget:connect_signal('mouse::enter', function()
        tooltip.visible = true

        --if Calendar.menu_showed then
        --    tooltip.visible = false
        --    return
        --end

        if Calendar.cal.error then
            tooltip.text = Calendar.cal.error
            return
        end

        local event = Calendar.cal.current_event()
        local text = 'Задача:' .. event.name
        text = text .. '\nВремя:' .. event.start_time .. ' - ' .. event.end_time

        if event.desc then
            text = text .. '\n' .. 'Описание: \n' .. event.desc
        else
            text = text .. '\n' .. 'Описание: -'
        end

        text = text .. '\nЦвет:' .. event.color

        tooltip.text = text
    end)

    widget:connect_signal('button::press', function()
        Calendar.fetch()
        --if button ~= 3 then
        --    return
        --end

        --local main_menu = awful.menu({
        --    { "Обновить", function() Calendar.fetch() end }
        --})
        --
        ----Calendar.menu_showed = true
        --main_menu:show()
    end)

    return widget
end

Calendar.update = function()
    if Calendar.cal.error then
        Calendar.textWidget:set_markup_silently('Error')
        Calendar.container.bg = '#d06b64'
        return
    end

    local event = Calendar.cal.current_event()
    Calendar.textWidget:set_markup_silently(event.name)
    Calendar.container.bg = event.color
end

Calendar.fetch = function()
    Calendar.cal.fetch_event()
end

Calendar.updateText = function(text)
    Calendar.textWidget:set_markup_silently(text)
end

return Calendar
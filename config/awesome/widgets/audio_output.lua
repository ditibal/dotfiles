local wibox = require("wibox")
local gears = require("gears")
local python = require('python')

local Pulse = {}

Pulse.create = function()
    Pulse.pulse_ctr = python.import "pulseaudio".create()
    Pulse.textWidget = wibox.widget.textbox('')

    awesome.connect_signal('login', function()
        Pulse.update()
    end)

    gears.timer {
        timeout = 1,
        call_now = false,
        autostart = true,
        callback = Pulse.update
    }

    Pulse.update()

    local widget = wibox.container.margin(Pulse.textWidget, 0, 15)

    widget:connect_signal('button::press', function(_, _, _, button)
        if button == 1 then
            Pulse.pulse_ctr.switch_sink()
            Pulse.update()
        end
    end)

    return widget
end

Pulse.get_icon = function(sink)
    if sink == 'headphone' then
        return "🎧"
    end

    if sink == 'speakers' then
        return "🔊"
    end

    return "❓"
end

Pulse.update = function()
    local sink = Pulse.pulse_ctr.get_current_sink()
    Pulse.textWidget:set_markup_silently(Pulse.get_icon(sink))
end

return Pulse
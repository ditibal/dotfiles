local awful = require("awful")
local gears = require("gears")
local buttons = require("widgets.button")

local btn = buttons {
    type = 'outline',
    text = 'VPN: credit',
    style = {
        inactive = {
            text = '#616161',
            border = '#616161',
            bg = nil,
        },
        active = {
            text = '#ffffff',
            border = '#ff4a00',
            bg = '#ff4a00',
        },
        disabled = {
            text = '',
            border = '',
            bg = '',
        },
        hover = {
            text = '',
            border = '',
            bg = '',
        },
    },
    text_size = 8,
    on_click = function(button)
        awful.spawn.easy_async('systemctl -q is-active openvpn-client@credit', function(_, _, _, exitcode)
            if exitcode == 0 then
                awful.spawn.easy_async('systemctl -q stop openvpn-client@credit', function(_, _, _, exitcode_stop)
                    if exitcode_stop == 0 then
                        button:inactive()
                    else
                        n('error')
                    end
                end)
            else
                awful.spawn.easy_async('systemctl -q start openvpn-client@credit', function(_, _, _, exitcode_start)
                    if exitcode_start == 0 then
                        button:active()
                    else
                        n('error')
                    end
                end)
            end
        end)
    end
}


local function update()
    local command = 'systemctl -q is-active openvpn-client@credit'
    awful.spawn.easy_async(command, function(_, _, _, exitcode)
        if exitcode == 0 then
            btn:active()
        else
            btn:inactive()
        end
    end)
end

update()

gears.timer {
    timeout = 1,
    call_now = false,
    autostart = true,
    callback = update
}


return btn
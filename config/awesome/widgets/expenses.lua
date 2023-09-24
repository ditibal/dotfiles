local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local LIP = require("lib.LIP")
local json = require("lib.json")

local text_from_result = function(result)
    local reports = json.decode(result)
    local text = ''

    text = reports.perfect_spending .. ' / '

    if reports.overspending ~= '0' then
        text = text .. '<b><span foreground="red">' .. reports.month .. '</span></b>'
    else
        text = text .. reports.month
    end

    if reports.overspending ~= '0' then
        text = text .. ' / ' .. '<b><span foreground="red">' .. reports.overspending .. '</span></b>'
    end

    return text
end


local Expenses = {}

Expenses.create = function()
    Expenses.textWidget = wibox.widget.textbox('-')

    awful.tooltip {
        objects = { Expenses.textWidget },
        timer_function = function()
            return os.date('%d.%B %H:%M:%S', Expenses.updatedAt)
        end,
    }

    awesome.connect_signal('login', function()
        Expenses.update()
    end)

    Expenses.textWidget:connect_signal('button::press', function()
        Expenses.update(true)
    end)

    gears.timer {
        timeout = 7200, -- 2 hours
        call_now = false,
        autostart = true,
        callback = Expenses.update
    }

    Expenses.update()
    Expenses.updatedAt = storage:get('drebe_updated_at')

    return wibox.container.margin(Expenses.textWidget, 20, 0, 0, 0)
end

Expenses.update = function(force)
    force = force or false

    local fPid = io.popen("pgrep slimlock")
    local pid = fPid:read("*n")
    fPid:close()

    if pid ~= nil then
        return
    end

    local data = LIP.load(ini_file);
    local drebe = data.drebe

    local updatedAt = storage:get('drebe_updated_at')
    local result = storage:get('drebe_result')

    if (force ~= true
        and updatedAt ~= nil
        and updatedAt + 7200 > os.time()
    ) then
        Expenses.updateText(text_from_result(result))
        return
    end

    local command = '/usr/bin/python ' .. cfg_dir .. 'drebe.py --cookie="' .. drebe.cookie .. '"'

    awful.spawn.easy_async(command, function(r)
        r = string.gsub(r, '^%s*(.-)%s*$', '%1')

        Expenses.updateText(text_from_result(r))
        updatedAt = os.time()

        storage:set('drebe_result', r)
        storage:set('drebe_updated_at', updatedAt)

        Expenses.updatedAt = updatedAt
    end)
end

Expenses.updateText = function(text)
    Expenses.textWidget:set_markup_silently(text)
end

return Expenses
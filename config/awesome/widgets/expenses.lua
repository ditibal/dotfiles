local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local LIP = require("libs.LIP")

local Expenses = {}

Expenses.create = function()
    Expenses.textWidget = wibox.widget.textbox('0 000.00 Р')

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

    local updatedAt = storage:get('drebe_updated_at')
    local amount = storage:get('drebe_amount')

    if (updatedAt ~= nil) then
        Expenses.updatedAt = updatedAt
        Expenses.amount = amount
    end

    return Expenses.textWidget
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
    local amount = storage:get('drebe_amount')

    if (force ~= true
        and updatedAt ~= nil
        and updatedAt + 7200 > os.time()
    ) then
        Expenses.updateText(amount or 'Error')
        return
    end

    local command = '/usr/bin/python ' .. cfg_dir .. 'drebe.py --cookie="' .. drebe.cookie .. '"'

    awful.spawn.easy_async(command, function(amount)
        amount = amount or 'Error'
        amount = string.gsub(amount, '^%s*(.-)%s*$', '%1')
        Expenses.updateText(amount)
        updatedAt = os.time()

        storage:set('drebe_amount', amount)
        storage:set('drebe_updated_at', updatedAt)

        Expenses.updatedAt = updatedAt
        Expenses.amount = amount

        print(os.date("[%d/%b/%Y %H:%M:%S] Update drebe"))
    end)
end

Expenses.updateText = function(text)
    Expenses.textWidget:set_markup_silently('<b>' .. text .. '</b>')
end

return Expenses
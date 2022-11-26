local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local LIP = require("libs.LIP")

Expenses = {}

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

    local data = LIP.load(ini_file);
    local drebe = data.drebe

    if (drebe ~= nil and drebe.updatedAt ~= nil) then
        Expenses.updatedAt = drebe.updatedAt
        Expenses.amount = drebe.amount
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
    local cookie = drebe.cookie

    if (force ~= true
        and drebe ~= nil
        and drebe.updatedAt ~= nil
        and drebe.updatedAt + 7200 > os.time()
    ) then
        Expenses.updateText(drebe.amount or 'Error')
        return
    end

    local command = '/usr/bin/python ' .. cfg_dir .. 'drebe.py --cookie="' .. drebe.cookie .. '"'

    awful.spawn.easy_async(command, function(amount)
        amount = amount or 'Error'
        Expenses.updateText(amount)
        local updatedAt = os.time()

        data.drebe = {
            amount = amount,
            updatedAt = updatedAt,
            cookie = cookie
        }

        Expenses.updatedAt = updatedAt
        Expenses.amount = amount

        LIP.save(ini_file, data)

        print(os.date("[%d/%b/%Y %H:%M:%S] Update drebe"))
    end)
end

Expenses.updateText = function(text)
    Expenses.textWidget:set_markup_silently('<b>' .. text .. '</b>')
end

return Expenses

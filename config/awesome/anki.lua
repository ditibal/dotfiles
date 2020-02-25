local naughty = require("naughty")
local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local anki = {}
local grabber
local notification
local markup = lain.util.markup
local question = ''
local gears = require("gears")

function d(var, depth) gears.debug.dump(var, 'dump', depth) end

anki.widget = wibox.widget{
    widget = wibox.widget.textbox
}

anki.menu = awful.menu({
    items = {
        { "sync", function() anki.sync() end },
    }
})

anki.widget:connect_signal('button::press', function(w, lx)
    anki.menu:show()
end)

function set_widget_text(text)
    anki.widget.markup = markup.font("Ubuntu 12", trim(text))
end

function anki.sync()
    awful.spawn.easy_async("qdbus com.AnkiService / com.Interface.Sync", function(stdout, strerr)
        notification = naughty.notify({
            text = stdout,
            timeout = 0,
            position = 'top_middle',
        })
    end)
end

function anki.get_question()
    awful.spawn.easy_async("qdbus com.AnkiService / com.Interface.GetQuestion", function(stdout, strerr)
        if stdout == '' or stdout == nil then
            stdout = '-'
        end
        question = stdout
        set_widget_text(stdout)
    end)
end

function anki.get_answer_buttons()
    awful.spawn.easy_async("qdbus com.AnkiService / com.Interface.GetAnswerButtons", function(stdout, strerr)
        set_widget_text(stdout)
    end)
end

function anki.answer(ease)
    naughty.destroy(notification, naughty.notificationClosedReason.dismissedByUser)
    awful.keygrabber.stop(grabber)
    awful.spawn.easy_async("qdbus com.AnkiService / com.Interface.Answer " .. ease, function(stdout, strerr)
        anki.get_question()
    end)
end

function anki.get_answer()
    if question == '-' then
        return
    end

    awful.spawn.easy_async("qdbus com.AnkiService / com.Interface.GetAnswer", function(stdout, strerr)
        if stdout == '' or stdout == nil then
            return
        end

        notification = naughty.notify({
            text = stdout,
            timeout = 0,
            position = 'top_middle',
        })

        grabber = awful.keygrabber.run(function(mod, key, event)
            if event == "release" then return end

            if key == "j" then
                anki.answer(1)
            end

            if key == "k" then
                anki.answer(2)
            end

            if key == "l" then
                anki.answer(3)
            end

            if key == ";" then
                anki.answer(4)
            end

            if key == "q" then
                naughty.destroy(notification, naughty.notificationClosedReason.dismissedByUser)
                awful.keygrabber.stop(grabber)
            end
        end)
    end)
end

anki.get_question()


-- dbus.request_name("session", "ru.console.df")
-- dbus.add_match("session", "interface='ru.console.df', member='fsValue'")
dbus.connect_signal("com.anki", function (...)
    local data = { ... }
    local method = data[1].member

    if method == 'start' then
        anki.get_question()
    end

    if method == 'end' then
        question = '-'
        set_widget_text(question)
    end
end)

return anki

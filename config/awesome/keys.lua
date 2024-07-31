local awful = require("awful")
local modalbind = require("lib.modalbind")

modalbind.init()

local keys = {}


client_buffer = nil

local client_map = {
    { { "Shift" }, "n", function()
        awful.client.restore()
    end, "Restore client" },

    { "x", function()
        if client.focus then
            client_buffer = client.focus
        end
    end, "Cut client" },

    { "v", function()
        if client_buffer then
            local screen = awful.screen.focused()
            client_buffer:move_to_tag(screen.selected_tag)
            client_buffer:emit_signal("request::activate", "client.focus.byidx", { raise = true })
            client_buffer = nil
        end

    end, "Paste client" },
}

local tag_map = {
    { "n", function()
        local screen = awful.screen.focused()
        screen.selected_tag:toggle_active()
    end, "Toggle tag" },
}


keys.globalkeys = awful.util.table.join(
        awful.key({ modkey }, "w", function()
            modalbind.grab { keymap = client_map, name = "Windows", stay_in_mode = false }
        end),

        awful.key({ modkey }, "t", function()
            modalbind.grab { keymap = tag_map, name = "Tags", stay_in_mode = false }
        end),

        awful.key({ modkey }, ";", function()
            awful.spawn.with_shell("python ~/dotfiles/actions/actions.py")
        end),

        awful.key({ modkey }, "h",
                function()
                    awful.tag.viewprev()
                end),

        awful.key({ modkey }, "l",
                function()
                    awful.tag.viewnext()
                end),

        awful.key({ modkey, 'Shift' }, "h",
                function()
                    awful.tag.viewprev(true)
                end),

        awful.key({ modkey, 'Shift' }, "l",
                function()
                    awful.tag.viewnext(true)
                end),

        awful.key({ modkey }, "k",
                function()
                    awful.client.focus.byidx(1)
                end),

        awful.key({ modkey }, "j",
                function()
                    awful.client.focus.byidx(-1)
                end),

        awful.key({ modkey }, "Left",
                function()
                    awful.tag.viewprev()
                end),

        awful.key({ modkey }, "Right",
                function()
                    awful.tag.viewnext()
                end),

        awful.key({ modkey, "Shift" }, "Left",
                function()
                    awful.tag.viewprev(true)
                end),

        awful.key({ modkey, "Shift" }, "Right",
                function()
                    awful.tag.viewnext(true)
                end),

        awful.key({ modkey, "Control" }, "Right",
                function()
                    awful.tag.next_group()
                end),

        awful.key({ modkey, "Control" }, "Left",
                function()
                    awful.tag.prev_group()
                end),

        awful.key({ modkey, "Control" }, "l",
                function()
                    awful.tag.next_group()
                end),

        awful.key({ modkey, "Control" }, "h",
                function()
                    awful.tag.prev_group()
                end),

        awful.key({ modkey }, "Tab",
                function()
                    awful.tag.history.restore()
                end),

        awful.key({ modkey }, "Down",
                function()
                    awful.client.focus.byidx(1)
                end),

        awful.key({ modkey }, "Up",
                function()
                    awful.client.focus.byidx(-1)
                end),

        -- hide / show Wibox
        awful.key({ modkey }, "b",
            function()
                awesome.emit_signal("toggle_panel")
            end),

        -- dmenu
        awful.key({ modkey }, "/",
            function()
                awful.spawn("rofi -show drun")
            end),

        -- ALSA volume control
        awful.key({ modkey }, ".",
                function()
                    pactl_set('+5%')
                end),

        awful.key({ modkey }, ",",
                function()
                    pactl_set('-5%')
                end),

        awful.key({ modkey, 'Mod1' }, ".",
                function()
                    pactl_set('+10%')
                end),

        awful.key({ modkey, 'Mod1' }, ",",
                function()
                    pactl_set('-10%')
                end),

        awful.key({ modkey }, "m",
                function()
                    -- TODO
                    awful.spawn(string.format("amixer set %s toggle", 'Master'))
                    volume.update()
                end),

        -- Standard program
        awful.key({ modkey }, "Return", function()
            awful.spawn(terminal)
        end),

        awful.key({ modkey }, "space",
                function()
                    awful.layout.inc(layouts, 1)
                end),

        awful.key({ modkey, "Control" }, "n", awful.client.restore),

        -- Capture screen to buffer
        awful.key({ }, "Print",
                function()
                    awful.spawn("flameshot gui")
                end),

        -- Lock screen
        awful.key({ modkey }, "y",
                function()
                    awesome.emit_signal("logout")
                    awful.spawn("qdbus org.mpris.MediaPlayer2.strawberry /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause")
                    awful.spawn("xset dpms force suspend")
                    awful.spawn.easy_async("python2 " .. cfg_dir .. "/slimlock.py", function()
                        awesome.emit_signal("login")
                        awful.spawn("xset s off -dpms")
                    end)
                end),

        awful.key({ modkey }, "r",
                function()
                    --for _, c in ipairs(client.get()) do
                    --    if c.id == 'ranger' then
                    --        c:move_to_tag(client.focus.first_tag)
                    --        client.focus = c
                    --        c:raise()
                    --        return
                    --    end
                    --end

                    awful.spawn.raise_or_spawn('alacritty -e /bin/fish -c "ranger"', {}, function()
                        --c.id = 'ranger'
                        --
                        --client.focus = c
                        --c:raise()

                        return false
                    end)
                end),

        awful.key({ modkey }, "u",
                function()
                    n('not reserved')
                end),

        awful.key({ }, "F1",
                function()
                    --awful.spawn.spawn('xterm -e /bin/fish -c "ranger"', {}, function(c)
                    --    n('asfd')
                    --    --c.previousFocusedClient = client.focus
                    --    --c:move_to_screen(2)
                    --end)

                    f = client.focus
                    f:raise()
                    client.focus = nil
                    awful.spawn("python /home/ditibal/test.py")
                    client.focus = f
                    f:raise()
                end),

        awful.key({ modkey }, "s",
                function()
                    awful.spawn("qdbus org.mpris.MediaPlayer2.strawberry /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
                end),

        awful.key({ modkey }, "a",
                function()
                    awful.spawn("qdbus org.mpris.MediaPlayer2.strawberry /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
                end),

        awful.key({ modkey }, "d",
                function()
                    awful.spawn("qdbus org.mpris.MediaPlayer2.strawberry /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
                end),

        awful.key({ modkey }, "F12", function()
            clients_hidden = true
            update_hidden_clients()

            awesome.restart()
        end),

        awful.key({ modkey }, "F1",
                function()
                    clients_hidden = false
                    update_hidden_clients()
                end),

        awful.key({}, "F1",
                function()
                    clients_hidden = true
                    update_hidden_clients()
                end),

        awful.key({ modkey, "Shift" }, "t",
                function()
                    awful.spawn("telegram-desktop")
                end)
)

keynumber = 0
for _ = 1, screen.count() do
    keynumber = 9;
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    keys.globalkeys = awful.util.table.join(keys.globalkeys,
    -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local tag = awful.tag.get_visible_tab_by_id(i)
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local tag = awful.tag.get_visible_tab_by_id(i)
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = awful.tag.get_visible_tab_by_id(i)
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                local tag = awful.tag.get_visible_tab_by_id(i)
                tag.hide = not tag.hide
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

keys.clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function(c)
        client.focus = c;
        c:raise()
    end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    awful.button({ modkey, 'Control' }, 3, function()
        local mmenu = require("modules.menu")

        local mainmenu = mmenu({
            {
                text = 'rembox',
                keys = {
                    t = "xterm -e /bin/fish -C \"cd ~/tmp/rembox\"",
                    r = "xterm -e /bin/fish -c \"ranger ~/tmp/rembox\"",
                }
            }
        })

        mainmenu:show()

        mousegrabber.run(function(mouse)
            d(mouse.x);
            if mouse.x == 42 then
                mousegrabber.stop()
            end
        end, "fleur")

        awesome.connect_signal('mouse::press', function()
            mainmenu:hide()
        end)
    end)
)

keys.clientkeys = awful.util.table.join(
-- Num +
    awful.key({ modkey }, "#86",
        function(c)
            c.opacity = c.opacity + 0.1
        end),

-- Num -
    awful.key({ modkey }, "#82",
        function(c)
            c.opacity = c.opacity - 0.1
        end),

    awful.key({ modkey }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
        end),

    awful.key({ modkey, "Control" }, "c",
        function(c)
            c:kill()
        end),

    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),

    awful.key({ modkey, "Control" }, "t",
        function(c)
            c.ontop = not c.ontop
        end),

    awful.key({ modkey, "Mod1" }, "F1",
        function(c)
            if c.hideable then
                unset_client_hideable(c)
            else
                set_client_hideable(c)
            end
        end),

    awful.key({ modkey }, "n",
        function(c)
            c.minimized = true
        end),

    awful.key({ modkey }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical = not c.maximized_vertical
        end)
)

return keys
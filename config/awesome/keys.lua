local awful = require("awful")

local keys = {}

keys.globalkeys = awful.util.table.join(
    awful.key({ modkey }, "h",
        function ()
            awful.tag.viewprev()
        end),

    awful.key({ modkey }, "l",
        function ()
            awful.tag.viewnext()
        end),

    awful.key({ modkey }, "k",
        function ()
            awful.client.focus.byidx( 1)
        end),

    awful.key({ modkey }, "j",
        function ()
            awful.client.focus.byidx(-1)
        end),

    awful.key({ modkey }, "Left",
        function ()
            awful.tag.viewprev()
        end),

    awful.key({ modkey }, "Right",
        function ()
            awful.tag.viewnext()
        end),

    awful.key({ modkey }, "Down",
        function ()
            awful.client.focus.byidx( 1)
        end),

    awful.key({ modkey }, "Up",
        function ()
            awful.client.focus.byidx(-1)
        end),

    awful.key({ modkey }, "Page_Up",
        function ()
            awful.client.focus.byidx(-1)
        end),

    awful.key({ modkey }, "Page_Down",
        function ()
            awful.client.focus.byidx( 1)
        end),

    awful.key({ modkey }, "w",
        function ()
            awesome.emit_signal("show_mainmenu")
        end),

    -- hide / show Wibox
    awful.key({ modkey }, "b",
        function ()
            awesome.emit_signal("toggle_panel")
        end),

    -- dmenu
    awful.key({ modkey }, "/",
        function()
            awful.spawn(
                "/usr/bin/bash -c \"export LANGUAGE=en_US.UTF8; export PATH=$PATH:~/bin;" ..
                "dmenu_run -b -i -fn " ..
                "'-*-dejavu sans mono-*-r-*-*-16-*-*-*-*-*-*-*' -p 'run:'\"")
        end),

    -- ALSA volume control
    awful.key({ modkey }, ".",
        function()
            amixer_set('5%+')
        end),

    awful.key({ modkey }, ",",
        function()
            amixer_set('5%-')
        end),

    awful.key({ modkey, 'Mod1' }, ".",
        function()
            amixer_set('10%+')
        end),

    awful.key({ modkey, 'Mod1' }, ",",
        function()
            amixer_set('10%-')
        end),

    awful.key({ modkey }, "m",
        function()
            -- TODO
            awful.spawn(string.format("amixer set %s toggle", 'Master'))
            volume.update()
        end),

    -- Standard program
    awful.key({ modkey }, "Return", function () awful.spawn(terminal) end),

    awful.key({ modkey }, "space",
        function ()
            awful.layout.inc(layouts,  1)
        end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Capture screen to buffer
    awful.key({ }, "Print",
        function ()
            awful.spawn("/usr/bin/bash -c \" sleep 0.2 && scrot -sf /tmp/scrot-screenshot.png -e 'xclip -selection c -t image/png < $f' && rm /tmp/scrot-screenshot.png  \"")
        end),

    -- -- copy music to ~/_phone
    -- awful.key({ modkey }, "Delete",
    --     function ()
    --         awful.spawn("python /home/ditibal/cp-music.py")
    --     end),

    -- Lock screen
    awful.key({ modkey }, "y",
        function ()
            awesome.emit_signal("logout")
            awful.spawn("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause")
            awful.spawn("xset dpms force suspend")
            awful.spawn.easy_async("python2 " .. cfg_dir .."/slimlock.py", function()
                awesome.emit_signal("login")
            end)
        end),

    awful.key({ modkey }, "r",
        function ()
            for _, c in ipairs(client.get()) do
                if c.id == 'ranger' then
                    c:move_to_tag(client.focus.first_tag)
                    client.focus = c
                    c:raise()
                    return
                end
            end

            awful.spawn.raise_or_spawn('xterm -e /bin/fish -c "ranger"', {}, function (c)
                c.id = 'ranger'

                client.focus = c
                c:raise()
            end)
        end),

    awful.key({ modkey }, "u",
        function ()
            awesome.emit_signal("show_projectmenu")
        end),

    awful.key({ modkey }, "s",
        function ()
            awful.spawn("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
        end),

    awful.key({ modkey }, "a",
        function ()
            awful.spawn("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
        end),

    awful.key({ modkey }, "d",
        function ()
            awful.spawn("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
        end),

    awful.key({ modkey }, "F12", function ()
        clients_hidden = true
        update_hidden_clients()

        awesome.restart()
    end),

    awful.key({ modkey }, "F1",
        function ()
            clients_hidden = false
            update_hidden_clients()
        end),

    awful.key({}, "F1",
        function ()
            clients_hidden = true
            update_hidden_clients()
        end),

    awful.key({ modkey }, "t",
        function (c)
            awful.spawn("telegram-desktop")
        end)
)

keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    keys.globalkeys = awful.util.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end


keys.clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize),
    awful.button({ modkey, 'Control' }, 3, function (c)
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

        mousegrabber.run(function(mouse) d(mouse.x); if mouse.x == 42 then mousegrabber.stop() end end,"fleur")

        awesome.connect_signal('mouse::press', function()
            mainmenu:hide()
        end)
    end)
)

keys.clientkeys = awful.util.table.join(
    -- Num +
    awful.key({ modkey }, "#86",
        function (c)
            c.opacity = c.opacity + 0.1
        end),

    -- Num -
    awful.key({ modkey }, "#82",
        function (c)
            c.opacity = c.opacity - 0.1
        end),

    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
        end),

    awful.key({ modkey, "Control" }, "c",
        function (c)
            c:kill()
        end),

    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),

    awful.key({ modkey, "Control" }, "t",
        function (c)
            c.ontop = not c.ontop
        end),

    awful.key({ modkey, "Mod1" }, "F1",
        function (c)
            if c.hideable then
                unset_client_hideable(c)
            else
                set_client_hideable(c)
            end
        end),

    awful.key({ modkey }, "n",
        function (c)
            c.minimized = true
        end),

    awful.key({ modkey }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

return keys

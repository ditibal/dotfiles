--                                     _
--                          _ __ ___  | |_   _  __ _
--                         | '__/ __| | | | | |/ _` |
--                         | | | (__ _| | |_| | (_| |
--                         |_|  \___(_)_|\__,_|\__,_|

-- {{{ Load libraries
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Vicious library
vicious = require("vicious")
vicious.contrib = require("vicious.contrib")

local naughty = require("naughty")
local lain = require("lain")

local opacity = require("modules.opacity")
-- }}}

local clients_hidden = true

function set_client_hideable(c)
    c.floating = true
    c.focusable = false
    c.hidden = clients_hidden
    c.hideable = true
    c.ontop = true
    c.skip_taskbar = true
end

function unset_client_hideable(c)
    c.floating = false
    c.focusable = true
    c.hideable = false
    c.ontop = false
    c.skip_taskbar = false
end

function update_hidden_clients()
    for _, c in ipairs(client.get()) do
        if c.hideable then
            if not clients_hidden then
                c.hidden = false
                c.focusable = true
                c:emit_signal("request::activate", "client.focus.byidx", {raise=true})
                c.focusable = false

                if client.focus then client.focus:raise() end
            else
                c.hidden = true
            end
        end
    end
end

-- {{{ Functions
function d(var, depth) gears.debug.dump(var, 'dump', depth) end

function amixer_set(step)
    awful.spawn(string.format("amixer sset %s %s &> /dev/null", 'Master', step))
    volume.update()
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    awful.util.spawn_with_shell("notify-send -u 'critical' " ..
                                "'Oops, there were errors during startup!'" ..
                                awesome.startup_errors
                               )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Some initializations
-- set the local settings
os.setlocale('es_ES.UTF-8')
-- }}}

-- {{{ Variable definitions

-- Directories
home_dir = os.getenv("HOME")
cfg_dir = awful.util.getdir("config")
theme_dir = cfg_dir .. "/themes"

-- Themes define colours, icons, and wallpapers
beautiful.init(theme_dir .. "/holo/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "vim"

-- Default modkey.
modkey = "Mod4"

-- set notifications icon size
naughty.config.presets.normal.icon_size = 50
naughty.config.presets.low.icon_size = 50
naughty.config.presets.critical.icon_size = 50

dofile(cfg_dir .. "/" .. "rc.locale.lua")
-- }}}

local anki = require("anki")

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
}
-- }}}

-- {{{ Tags
tags = {
   names = { " 1 ", " 2 ", " 3 " },
   layout = { layouts[1], layouts[1], layouts[1] }
}
for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- create a launcher widget and a main menu

myawesomemenu = {
    { "manual", terminal .. " -e man awesome" },
    { "restart", awesome.restart }
}

configsmenu = {
    { "vim", "xvim ~/.vimrc" },
    { "awesome", "xvim " .. cfg_dir .. "/rc.lua" },
    { "ranger", "xvim ~/.config/ranger/rc.conf" },
    { "bashrc", "xvim ~/.bashrc" },
    { "bashrc locale", "xvim ~/.bashrc_locale" },
}

mymainmenu = awful.menu({
    items = {
        { "chromium", "/home/ditibal/bin/chromium" },
        { "configs", configsmenu },
        { "awesome", myawesomemenu },
        { "fbless", "xterm fbless" }
    }
})

projectmenu = require('projectmenu')

-- }}}

-- {{{ Wibox
markup = lain.util.markup
blue   = "#80CCE6"
space3 = markup.font("Ubuntu 3", " ")
space2 = markup.font("Ubuntu 2", " ")

awful.client.property.persist("hideable", "boolean")

-- ALSA volume bar {{{
volume = lain.widget.alsabar({
    notification_preset = { font = "Monospace 9"},
    ticks  = true,
    width = 80,
    height = 10,
    border_width = 0,
    colors = {
        background = "#383838",
        unmute     = "#80CCE6",
        mute       = "#FF9F9F"
    },
})

volume.bar.paddings = 0
volume.bar.margins = 5
local volumewidget = wibox.container.background(volume.bar, theme.bg_focus, gears.shape.rectangle)
volumewidget = wibox.container.margin(volumewidget, 0, 0, 5, 5)
-- }}}

-- CPU {{{
local cpu_icon = wibox.widget.imagebox(theme.cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(space3 .. markup.font(theme.font, "CPU " .. cpu_now.usage
                          .. "% ") .. markup.font("Roboto 5", " "))
    end
})
local cpubg = wibox.container.background(cpu.widget, theme.bg_focus, gears.shape.rectangle)
local cpuwidget = wibox.container.margin(cpubg)
cpuwidget.forced_width = 90
-- }}}

-- Net {{{
local netdown_icon = wibox.widget.imagebox(theme.net_down)
local netup_icon = wibox.widget.imagebox(theme.net_up)

netwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.net)
vicious.register(netwidget, vicious.widgets.net,
                '<span color="#CC9393">${enp3s0 down_kb}</span>' ..
                ' <span color="#7F9F7F">${enp3s0 up_kb}</span>', 2)

local networkwidget = wibox.container.margin(netwidget, 0, 0, 5, 5)
-- }}}

-- Clock {{{
local clockwidget = wibox.widget.textclock(markup("#FFFFFF", space3 .. "%H:%M   " .. markup.font("Roboto 4", " ")))
-- local clockwidget = wibox.container.margin(clock)
clockwidget.forced_width = 60
-- }}}

-- Separators
local first = wibox.widget.textbox('<span font="Roboto 7"> </span>')
local spr_small = wibox.widget.imagebox(theme.spr_small)
local spr_very_small = wibox.widget.imagebox(theme.spr_very_small)
local spr_right = wibox.widget.imagebox(theme.spr_right)
local spr_bottom_right = wibox.widget.imagebox(theme.spr_bottom_right)
local spr_left = wibox.widget.imagebox(theme.spr_left)
local bar = wibox.widget.imagebox(theme.bar)
local bottom_bar = wibox.widget.imagebox(theme.bottom_bar)


-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )

awful.screen.connect_for_each_screen(function(s)
    s.mypromptbox = awful.widget.prompt()

    s.mytasklist = awful.widget.tasklist(
        s,
        awful.widget.tasklist.filter.currenttags,
        awful.util.tasklist_buttons,
        { bg_focus = theme.bg_focus, align = "center" }
    )

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons, { bg_focus = barcolor })

    mytaglistcont = wibox.container.background(s.mytaglist, theme.bg_focus, gears.shape.rectangle)
    s.mytag = wibox.container.margin(mytaglistcont, 0, 0, 5, 5)

    s.panel_top = awful.wibar({
        position = "top",
        screen = s,
        height = 24
    })

    s.panel_top:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytag,
            s.mypromptbox,
            spr_bottom_right,
            anki.widget,
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            bottom_bar,
            netdown_icon,
            networkwidget,
            netup_icon,
            cpu_icon,
            cpuwidget,
            volumewidget
        },
    }

    s.panel_bottom = awful.wibar({
        position = "bottom",
        screen = s,
        border_width = 5,
        height = 24
    })
    s.panel_bottom:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytasklist
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            clockwidget,
        },
    }
end)
-- }}}

-- {{{ Key bind
-- {{{ Global Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

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
            mymainmenu:show({keygrabber=true, coords={x=0, y=0}})
        end),

    -- hide / show Wibox
    awful.key({ modkey }, "b",
        function ()
            local screen = awful.screen.focused()
            screen.panel_top.visible = not screen.panel_top.visible
            screen.panel_bottom.visible = not screen.panel_bottom.visible
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

    -- Capture screen
    awful.key({ }, "Print",
        function ()
            naughty.notify({
                title = "imgur-screenshot",
                text = "Please select area!",
                timeout = 3,
                ontop = false,
                run = function (n)
                    n.die()
                    awful.spawn("/home/ditibal/bin/imgur-screenshot/imgur-screenshot.sh")
                end
            })
        end),

    -- -- copy music to ~/_phone
    -- awful.key({ modkey }, "Delete",
    --     function ()
    --         awful.spawn("python /home/ditibal/cp-music.py")
    --     end),

    -- Lock screen
    awful.key({ modkey }, "y",
        function ()
            awful.spawn("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause")
            awful.spawn("python2 " .. cfg_dir .."/slimlock.py")
        end),

    awful.key({ modkey }, "r",
        function ()
            awful.spawn('xterm -e /bin/fish -c "ranger"')
        end),

    awful.key({ modkey }, "u",
        function ()
            projectmenu:show({coords={x=10, y=10}})
        end),

    awful.key({ modkey }, "s",
        function ()
            awful.spawn("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
        end),

    awful.key({ modkey }, "o", anki.get_answer),

    awful.key({ modkey }, "a",
        function ()
            awful.spawn("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
        end),

    awful.key({ modkey }, "d",
        function ()
            awful.spawn("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
        end),

    awful.key({ modkey }, "i", function () end),

    awful.key({ modkey }, "p", function () end),

    awful.key({ modkey }, "F12", awesome.restart),

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

    awful.key({ modkey, 'Mod1' }, "i", -- Alt + num_4
        function ()
            awful.spawn("qdbus org.kde.amarok /Player org.freedesktop.MediaPlayer.Backward 3000")
        end)
)
-- }}}

-- {{{ Per client Key bindings
clientkeys = awful.util.table.join(
    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
        end),

    awful.key({ modkey, "Control" }, "c",
        function (c)
            c:kill()
        end),

    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),

    awful.key({ modkey }, "t",
        function (c)
            awful.spawn("telegram-desktop")
        end),

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

    awful.key({ modkey, "Control" }, "0", function (c) opacity.adjust(c,  0.01) end),
    awful.key({ modkey, "Control" }, "9", function (c) opacity.adjust(c, -0.01) end),

    awful.key({ modkey }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)
-- }}}

-- {{{ Tags bindings
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
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
-- }}}

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    -- xprop |awk '/WM_CLASS/{print $4}'
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = true,
            keys = clientkeys,
            buttons = clientbuttons,
            maximized = false,
            size_hints_honor = false
        }
    },

    {
        rule = { class = "Gvim" },
        properties = {
            size_hints_honor = false
        }
    },

    {
        rule = { instance = "crx_nckgahadagoaajjgafhacjanaoiihapd" },
        properties = {
            floating = true,
            ontop = true,
            border_width = 1,
            border_color = "#575757",
        },
        callback = function(c)
            local c_geometry = c:geometry()
            local s_geometry = screen[c.screen].geometry

            c:geometry({ x = s_geometry.x + (s_geometry.width - c_geometry.width),
                                y = s_geometry.y + (s_geometry.height - c_geometry.height) - 33 })
        end
    },

    {
        rule = { class = "Skype" },
        properties = {
            floating = true,
            ontop = true,
            border_width = 1,
            border_color = "#575757",
        },
        callback = function(c)
            local c_geometry = c:geometry()
            local s_geometry = screen[c.screen].geometry

            c:geometry({ x = s_geometry.x + (s_geometry.width - c_geometry.width),
                                y = s_geometry.y + (s_geometry.height - c_geometry.height) - 33 })
        end
    },

    {
        rule = { class = "telegram-desktop" },
        properties = {
            floating = true,
            ontop = true,
            border_width = 1,
            border_color = "#575757",
            height = 300,
            width = 300,
        },
        callback = function(c)
            local c_geometry = c:geometry()
            local s_geometry = screen[c.screen].geometry

            c:geometry({ x = s_geometry.x + (s_geometry.width - c_geometry.width),
                                y = s_geometry.y + (s_geometry.height - c_geometry.height) - 33 })
        end
    },

    {
        rule = { class = "Genymotion Player" },
        properties = {
            floating = true,
            ontop = true,
            border_width = 0,
            height = 162,
            width = 116,
        },
        callback = function(c)
            local c_geometry = c:geometry()
            local s_geometry = screen[c.screen].geometry

            c:geometry({ x = s_geometry.x + (s_geometry.width - c_geometry.width),
                                y = s_geometry.y + (s_geometry.height - c_geometry.height) - 33 })
        end
    },

    {
        rule = { class = "TelegramDesktop" },
        properties = {
            floating = true,
            ontop = true,
            border_width = 1,
            border_color = "#575757",
            height = 750,
            width = 600,
        },
        callback = function(c)
            local c_geometry = c:geometry()
            local s_geometry = screen[c.screen].geometry

            c:geometry({ x = s_geometry.x + (s_geometry.width - c_geometry.width),
                                y = s_geometry.y + (s_geometry.height - c_geometry.height) - 33 })
        end
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    if not startup then
        -- Put windows in a smart way, only if they does not set an initial
        -- position.
        if not c.size_hints.user_position and
            not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end

        if c.hideable then
            set_client_hideable(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = "#DD0000" end)
client.connect_signal("unfocus", function(c) c.border_color = "#242424" end)
-- }}}

-- {{{ Folding for Vim
-- This fold the sections in vim, for a better handling
-- vim:foldmethod=marker
-- }}}

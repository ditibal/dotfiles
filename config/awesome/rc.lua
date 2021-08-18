--                                     _
--                          _ __ ___  | |_   _  __ _
--                         | '__/ __| | | | | |/ _` |
--                         | | | (__ _| | |_| | (_| |
--                         |_|  \___(_)_|\__,_|\__,_|

-- Load libraries
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local LIP = require("libs.LIP")

-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

clients_hidden = true

awful.client.property.persist("hideable", "boolean")
awful.client.property.persist("id", "string")

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
    c.opacity = 1
    c.skip_taskbar = false
end

function update_hidden_clients()
    for _, c in ipairs(client.get()) do
        if c.hideable then
            if not clients_hidden then
                c.hidden = false
                c.focusable = true
                c:emit_signal("request::activate", "client.focus.byidx", { raise = true })
                c.focusable = false

                if c.id == 'shop' then
                    c.opacity = 0.5
                end

                if client.focus then
                    client.focus:raise()
                end
            else
                c.hidden = true
            end
        end
    end
end

-- Functions
function d(var, depth)
    gears.debug.dump(var, 'dump', depth)
end

function amixer_set(step)
    awful.spawn(string.format("amixer sset %s %s &> /dev/null", 'Master', step))
    volume.update()
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end


-- Error handling
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
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Some initializations
-- set the local settings
os.setlocale('es_ES.UTF-8')

-- Variable definitions
-- Directories
home_dir = os.getenv("HOME")
cfg_dir = awful.util.getdir("config")
ini_file = cfg_dir .. "/data.ini"
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

-- Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

local file = io.open(ini_file, 'r')
if (file == nil) then
    data = {}
    LIP.save(ini_file, data);
end

-- Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
}

-- Tags
tags = {
    names = { " 1 ", " 2 ", " 3 " },
    layout = { layouts[1], layouts[1], layouts[1] }
}
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end

require('components.mainmenu')

if (gears.filesystem.file_readable(cfg_dir .. 'components/projectmenu.lua')) then
    require('components.projectmenu')
end

local panels = require('panels.panels')
awful.screen.connect_for_each_screen(function(s)
    panels.top.create(s)
    panels.bottom.create(s)
end)

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)


-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c, startup)
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
--                                     _
--                          _ __ ___  | |_   _  __ _
--                         | '__/ __| | | | | |/ _` |
--                         | | | (__ _| | |_| | (_| |
--                         |_|  \___(_)_|\__,_|\__,_|

-- Load libraries
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local tag = require("lib.awful.tag")
local beautiful = require("beautiful")
local naughty = require("naughty")
local LIP = require("lib.LIP")
local Storage = require("lib.storage")
local python = require("python")
local array = require "lib.luarray"

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

                if c.id == "shop" then
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
    gears.debug.dump(var, "dump", depth)
end

function n(var)
	naughty.notify({ text = var })
end

function pactl_set(step)
    awful.spawn(string.format("pactl set-sink-volume @DEFAULT_SINK@ %s", step))

    volume.update()
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    awful.util.spawn_with_shell(
            "notify-send -u 'critical' " .. "'Oops, there were errors during startup!'" .. awesome.startup_errors
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

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })
        in_error = false
    end)
end

-- Some initializations
-- set the local settings
os.setlocale("es_ES.UTF-8")

-- Variable definitions
-- Directories
home_dir = os.getenv("HOME")
hostname = os.getenv("HOSTNAME")
cfg_dir = awful.util.getdir("config")
ini_file = cfg_dir .. "/data.ini"
theme_dir = cfg_dir .. "/themes"

python.import("sys").path.insert(0, cfg_dir .. "/python")

-- Themes define colours, icons, and wallpapers
beautiful.init(theme_dir .. "/holo/theme.lua")

storage = Storage(cfg_dir .. "storage_data.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"

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

local file = io.open(ini_file, "r")
if file == nil then
    data = {}
    LIP.save(ini_file, data)
end

if hostname == 'laptop' then
    TELEGRAM_WIDTH = 700
    TELEGRAM_HEIGHT = 1000
    NETWORK_INTERFACE = 'wlp0s20f3'
end

if hostname == 'comp' then
    TELEGRAM_WIDTH = 900
    TELEGRAM_HEIGHT = 1200
    NETWORK_INTERFACE = 'enp5s0'
end

-- Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts = {
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
}

local tags = array(
    {
        label = 'general',
        screen = 1,
        group = {'default'},
    },
    {
        label = 'general 2',
        screen = 1,
        group = {'default'},
    },
    {
        label = 'discord',
        screen = 1,
        group = {'default', 'work'},
    },
    {
        label = 'autoshina',
        screen = 1,
        group = {'autoshina'},
    },
    {
        label = 'terminal',
        screen = 1,
        group = {'autoshina'},
    },
    {
        label = 'webpack',
        screen = 1,
        group = {'autoshina'},
    },
    {
        label = 'work',
        screen = 1,
        group = {'work'},
    },
    {
        label = 'terminal',
        screen = 1,
        group = {'work'},
    },
    {
        label = 'webpack',
        screen = 1,
        group = {'work'},
    },
    {
        label = 'shop',
        screen = 1,
        group = {'shop'},
    },
    {
        label = 'terminal',
        screen = 1,
        group = {'shop'},
    },
    {
        label = 'webpack',
        screen = 1,
        group = {'shop'},
    },

    {
        label = 'general',
        screen = 2,
        group = {'*'},
    },
    {
        label = 'general 2',
        screen = 2,
        group = {'*'},
    },
    {
        label = 'general 3',
        screen = 2,
        group = {'*'},
    },
    {
        label = 'general 4',
        screen = 2,
        group = {'*'},
    }
)

 tag.set_group('default')

for i = screen.count(), 1, -1 do
    screen_tags = tags:filter(function(_, v) return v.screen == i end)

    for k, t in pairs(screen_tags) do
        tag.add(t.label, {
            id = k,
            screen = t.screen,
            layout = layouts[1],
            group = t.group,
            selected = k == 1 and true or false,
        })
    end
end

local mainTop = require("panels.main.top")
local mainBottom = require("panels.main.bottom")
mainTop.create(screen[1])
mainBottom.create(screen[1])

if screen[2] ~= nil then
    local secondTop = require("panels.second.top")
    local secondBottom = require("panels.second.bottom")
    secondTop.create(screen[2])
    secondBottom.create(screen[2])
end

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
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end

        if c.hideable then
            set_client_hideable(c)
        end
    end
end)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
            awful.button({}, 1, function()
                c:emit_signal("request::activate", "titlebar", { raise = true })
                awful.mouse.client.move(c)
            end),
            awful.button({}, 3, function()
                c:emit_signal("request::activate", "titlebar", { raise = true })
                awful.mouse.client.resize(c)
            end)
    )

    awful.titlebar(c):setup({
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })
end)

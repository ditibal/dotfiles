local wibox = require("wibox")
local lain = require("lain")
local gears = require("gears")
local awful = require("awful")

local taglist = {}

taglist.create = function(s)
    local taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons, { bg_focus = barcolor })
    local taglistcont = wibox.container.background(taglist, theme.bg_focus, gears.shape.rectangle)
    local taglist = wibox.container.margin(taglistcont, 0, 0, 5, 5)
    return taglist
end

return taglist

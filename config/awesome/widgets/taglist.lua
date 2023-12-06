local wibox = require("wibox")
local awful = require("awful")

local original_taglist_label = awful.widget.taglist.taglist_label
function awful.widget.taglist.taglist_label(tag, args)
    local text, bg, bg_image, icon, other_args = original_taglist_label(tag, args)

    if not tag.active then
        text = '<span color="#4E4E4E"> ' .. text .. '</span>'
    end

    return text, bg, bg_image, icon, other_args
end

local taglist = {}

local taglist_buttons = awful.util.table.join(
        awful.button({ }, 1, function(tag)
            tag:view_only()
        end),

        awful.button({ modkey }, 1, function(tag)
            if client.focus then
                client.focus:move_to_tag(tag)
            end
        end),

        awful.button({ }, 3, function(tag)
            tag:toggle_active()
        end)
)

function taglist_filter(t)
    return not t:is_hidden()
end

taglist.create = function(screen)
    local taglistwidget = awful.widget.taglist {
        screen = screen,
        filter = taglist_filter,
        buttons = taglist_buttons,
        style = {
            bg_focus = theme.bg_focus,
        }
    }

    return wibox.container.margin(taglistwidget)
end

return taglist

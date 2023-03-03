local awful = require("awful")
local local_tag = require("awful.tag")
local gtable = require("gears.table")

function local_tag.object.toggle_hide(self)
    local screen = awful.screen.focused()
    local tags = screen.tags
    local tag_idx = gtable.find_first_key(tags, function(_, t) return t == self end, true)
    local tags_visible = storage:get('tags_visible', {})

    self.hidden = not self.hidden

    tags_visible[self.name:gsub("%s+", "_")] = self.hidden
    self:emit_signal("property::name")

    if trim(self.name) == 't' then
        local prev_tag = tags[tag_idx - 1] or false

        if prev_tag then
            prev_tag.hidden = self.hidden
            prev_tag:emit_signal("property::name")
            tags_visible[prev_tag.name:gsub("%s+", "_")] = prev_tag.hidden
        end
    end

    local next_tag = tags[tag_idx + 1] or false

    if next_tag and trim(next_tag.name) == 't' then
        next_tag.hidden = self.hidden
        next_tag:emit_signal("property::name")
        tags_visible[next_tag.name:gsub("%s+", "_")] = next_tag.hidden
    end

    storage:set('tags_visible', tags_visible)
end

return local_tag
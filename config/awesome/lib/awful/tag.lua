local awful = require("awful")
local local_tag = require("awful.tag")
local gtable = require("gears.table")

local parent_add = local_tag.add
function local_tag.add(name, props)
    local tag = parent_add(name, props)
    local screen_index = props.screen.index

    local tags_visible = storage:get('tags_visible', {})
    tag.hidden = tags_visible['screen_' .. tostring(screen_index) .. '_tag_' .. tostring(tag.id)] or false

    tag:connect_signal("property::hidden", function()
        tags_visible = storage:get('tags_visible', {})
        tags_visible['screen_' .. tostring(screen_index) .. '_tag_' .. tostring(tag.id)] = tag.hidden
        storage:set('tags_visible', tags_visible)
    end)

    return tag
end

function local_tag.object.toggle_hide(self)
    local screen = awful.screen.focused()
    local tags = screen.tags
    local tag_idx = gtable.find_first_key(tags, function(_, t) return t == self end, true)

    self.hidden = not self.hidden
    self:emit_signal("property::name")

    if trim(self.name) == 't' then
        local prev_tag = tags[tag_idx - 1] or false

        if prev_tag then
            prev_tag.hidden = self.hidden
            prev_tag:emit_signal("property::name")
        end
    end

    local next_tag = tags[tag_idx + 1] or false

    if next_tag and trim(next_tag.name) == 't' then
        next_tag.hidden = self.hidden
        next_tag:emit_signal("property::name")
    end

end

return local_tag

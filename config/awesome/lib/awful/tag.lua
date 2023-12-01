local awful = require("awful")
local local_tag = require("awful.tag")
local gtable = require("gears.table")
local table = table
local gmath = require("gears.math")

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

function local_tag.set_group(name)
    if not name then
        return
    end

    local is_need_switch = name ~= local_tag.active_group
    local_tag.active_group = name

    if is_need_switch then
        local tag = awful.tag.get_visible_tab_by_id(1)
        if tag then
            tag:view_only()
        end
    end
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

function local_tag.object.is_hidden(self)
    if self.hide then
        return true
    end

    for _, group_name in pairs(self.group) do
        if group_name == local_tag.active_group or group_name == '*' then
            return false
        end
    end

    return true
end


function local_tag.viewidx(i, force)
    force = force or false
    local screen = awful.screen.focused()
    local tags = screen.tags
    local showntags = {}
    local sel = screen.selected_tag

    for _, t in ipairs(tags) do
        if force or (not t.hide and not t.hidden) then
            table.insert(showntags, t)
        else
            if t == sel then
                table.insert(showntags, t)
            end
        end
    end

    awful.tag.viewnone(screen)
    for k, t in ipairs(showntags) do
        if t == sel then
            showntags[gmath.cycle(#showntags, k + i)].selected = true
        end
    end
    screen:emit_signal("tag::history::update")
end

function local_tag.viewnext(force)
    local_tag.viewidx(1, force)
end

function local_tag.viewprev(force)
    local_tag.viewidx(-1, force)
end

function local_tag.get_visible_tab_by_id(id)
    local screen = awful.screen.focused()
    local tags = screen.tags

    local visible_tags = {}

    for _, t in ipairs(tags) do
        if (not t:is_hidden()) then
            table.insert(visible_tags, t)
        end
    end

    return visible_tags[id]
end

return local_tag

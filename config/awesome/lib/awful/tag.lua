local awful = require("awful")
local local_tag = require("awful.tag")
local table = table
local gmath = require("gears.math")

local parent_add = local_tag.add
function local_tag.add(name, props)
    local tag = parent_add(name, props)
    local screen_index = props.screen.index

    local tags_visible = storage:get('tags_visible', {})
    local active = tags_visible['screen_' .. tostring(screen_index) .. '_tag_' .. tostring(tag.id)]

    if active == nil then
        active = true
    end

    tag.active = active

    if local_tag.groups == nil then
        local_tag.groups = {}
    end

    for _, group in ipairs(tag.group) do
        if local_tag.groups[group] == nil then
            local_tag.groups[group] = {
                last_tag = nil
            }
        end
    end

    tag:connect_signal("property::active", function()
        tags_visible = storage:get('tags_visible', {})
        tags_visible['screen_' .. tostring(screen_index) .. '_tag_' .. tostring(tag.id)] = tag.active
        storage:set('tags_visible', tags_visible)
    end)

    tag:connect_signal("property::selected", function()
        if not tag.selected then
            return
        end

        local_tag.groups[local_tag.active_group].last_tag = tag
    end)

    return tag
end

function local_tag.get_groups()
    return {
        'Default',
        'Work',
        'Autoshina',
        'Shop',
    }
end

function local_tag.get_next_group()
    local groups = local_tag.get_groups()
    local group = local_tag.get_group()

    for i, g in ipairs(groups) do
        g = string.lower(g)
        if g == group then
            if i == #groups then
                return groups[1]
            else
                return groups[i + 1]
            end
        end
    end
end

function local_tag.get_prev_group()
    local groups = local_tag.get_groups()
    local group = local_tag.get_group()

    for i, g in ipairs(groups) do
        g = string.lower(g)
        if g == group then
            if i == 1 then
                return groups[#groups]
            else
                return groups[i - 1]
            end
        end
    end
end

function local_tag.next_group()
    local next_group = string.lower(local_tag.get_next_group())
    local_tag.set_group(next_group)
end

function local_tag.prev_group()
    local prev_group = string.lower(local_tag.get_prev_group())
    local_tag.set_group(prev_group)
end

function local_tag.set_group(name)
    if not name then
        return
    end

    local is_need_switch = name ~= local_tag.active_group
    local_tag.active_group = name

    if is_need_switch then
        local tag = awful.tag.get_visible_tab_by_id(1)

          if local_tag.groups ~= nil and local_tag.groups[name] ~= nil and local_tag.groups[name].last_tag ~= nil then
             tag = local_tag.groups[name].last_tag
          end

        if tag then
            tag:view_only()
        end
    end
end

function local_tag.get_group()
    return local_tag.active_group
end

function local_tag.object.toggle_active(self)
    self.active = not self.active
    self:emit_signal("property::name")
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
        if force or (not t:is_hidden() and t.active) then
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
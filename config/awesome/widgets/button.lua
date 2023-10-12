local wibox = require("wibox")
local gears = require("gears")

return function(args)
    local Button = {}
    Button.text = args.text
    local on_click = args.on_click or function() end
    Button.style = args.style

    Button.textWidget = wibox.widget.textbox(Button.text)
    local container = wibox.container.margin(Button.textWidget, 8, 8, 4, 4)
    Button.bgWidget = wibox.container.background(container, nil, function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 4) end)
    Button.widget = wibox.container.margin(Button.bgWidget, 30)

    Button.bgWidget:connect_signal("button::press", function() on_click(Button) end)
    Button.bgWidget:set_shape_border_width(1)

    Button.update_markup = function(self, color)
        self.textWidget:set_markup_silently('<span foreground="' .. color ..'" >' .. self.text ..  '</span>')
    end

    Button.active = function(self)
        self:set_color(self.style.active.text)
        self:set_bg(self.style.active.bg)
        self:set_border_color(self.style.active.border)
    end

    Button.inactive = function(self)
        self:set_color(self.style.inactive.text)
        self:set_bg(self.style.inactive.bg)
        self:set_border_color(self.style.inactive.border)
    end

    Button.set_color = function(self, color)
        self:update_markup(color)
    end

    Button.set_bg = function(self, color)
        self.bgWidget:set_bg(color)
    end

    Button.set_border_color = function(self, color)
        self.bgWidget:set_shape_border_color(color)
    end

    return Button
end
local beautiful = require("beautiful")

local rules = {}

function rules.create(clientkeys, clientbuttons)
   return {
        -- All clients will match this rule.
        -- xprop |awk '/WM_CLASS/{print $4}'
        {
            rule = { },
            properties = {
                border_width = 0,
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
            rule = { class = "TelegramDesktop" },
            properties = {
                floating = true,
                ontop = true,
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
end

-- return module table
return rules

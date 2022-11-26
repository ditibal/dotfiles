local beautiful = require("beautiful")
local awful = require("awful")

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
            rule = {
                class = "zoom",
                name = "zoom",
                instance = "zoom",
                type = "normal"
            },
            properties = {
                floating = true
            },
            callback = function(c)
                local c_geometry = c:geometry()
                local s_geometry = screen[c.screen].geometry

                c:geometry({
                    x = s_geometry.x + (s_geometry.width - c_geometry.width),
                    y = s_geometry.y + (s_geometry.height - c_geometry.height) - 33
                })

                client.connect_signal("property::x", function(client)
                    local cc_geometry = client:geometry()
                    local ss_geometry = screen[client.screen].geometry

                    client:geometry({
                        x = ss_geometry.x + (ss_geometry.width - cc_geometry.width),
                        y = ss_geometry.y + (ss_geometry.height - cc_geometry.height) - 33
                    })
                end)
            end
        },
        {
            rule = { class = "TelegramDesktop" },
            properties = {
                floating = true,
                ontop = true,
                height = 1200,
                width = 900,
                sticky = true,
            },
            tags = awful.screen.tags,
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

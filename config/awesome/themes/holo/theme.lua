theme = {}

theme.icon_dir = os.getenv("HOME") .. "/.config/awesome/themes/holo/icons"
theme.default_dir = require("awful.util").get_themes_dir() .. "default"
theme.wallpaper = os.getenv("HOME") .. "/.config/awesome/themes/holo/clean.jpg"

theme.font = "Noto 13"
theme.taglist_font = "Noto 13"
theme.fg_normal = "#FFFFFF"
theme.fg_focus = "#0099CC"
theme.bg_normal = "#242424"
theme.fg_urgent = "#CC9393"
theme.bg_urgent = "#2A1F1E"
theme.border_width = "2"
theme.border_normal = "#252525"
theme.border_focus = "#0099CC"

theme.taglist_bg_focus = "png:" .. theme.icon_dir .. "/taglist_bg_focus.png"
theme.tasklist_bg_normal = "#222222"
theme.tasklist_fg_focus = "#4CB7DB"
theme.tasklist_bg_focus = "png:" .. theme.icon_dir .. "/bg_focus_noline.png"
theme.textbox_widget_margin_top = 1
theme.awful_widget_height = 14
theme.awful_widget_margin_top = 2
theme.menu_height = "26"
theme.menu_width = "300"
theme.bg_focus = "#303030"

theme.submenu_icon = theme.icon_dir .. "/submenu.png"
theme.taglist_squares_sel = theme.icon_dir .. "/square_sel.png"
theme.taglist_squares_unsel = theme.icon_dir .. "/square_unsel.png"

theme.titlebar_close_button_normal = theme.default_dir .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus = theme.default_dir .. "/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal = theme.default_dir .. "/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = theme.default_dir .. "/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive = theme.default_dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = theme.default_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.default_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = theme.default_dir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive = theme.default_dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = theme.default_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.default_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = theme.default_dir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive = theme.default_dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = theme.default_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.default_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = theme.default_dir .. "/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.default_dir .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = theme.default_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.default_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = theme.default_dir .. "/titlebar/maximized_focus_active.png"

theme.tasklist_floating = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical = ""

return theme
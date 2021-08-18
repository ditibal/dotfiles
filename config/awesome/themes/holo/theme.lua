theme = {}

theme.icon_dir = os.getenv("HOME") .. "/.config/awesome/themes/holo/icons"
theme.wallpaper = os.getenv("HOME") .. "/.config/awesome/themes/holo/clean.jpg"

theme.font = "Noto 12"
theme.taglist_font = "Noto 10"
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
theme.cpu = theme.icon_dir .. "/cpu.png"
theme.net_up = theme.icon_dir .. "/net_up.png"
theme.net_down = theme.icon_dir .. "/net_down.png"

theme.tasklist_disable_icon = true
theme.tasklist_floating = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical = ""

return theme